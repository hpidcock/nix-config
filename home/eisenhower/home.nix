{
  pkgs,
  lib,
  ...
}:
let
  # The nixpkgs wrapper for chromium/electron apps hardcodes CHROME_DEVEL_SANDBOX
  # to the nix store sandbox path, which can never be SUID (read-only store).
  # sandboxExecutablePath is not exposed as a top-level override in this nixpkgs,
  # so instead we patch the generated wrapper scripts in-place via a thin
  # runCommand + symlinkJoin layer (no source rebuild needed).
  chromiumSandboxOverlay =
    final: prev:
    let
      # Creates a small derivation that recursively patches wrapper scripts to
      # fix CHROME_DEVEL_SANDBOX, then overlays them onto the original package
      # via symlinkJoin.
      #
      # The build-time bash logic follows three cases at each script in the chain:
      #   1. Script directly sets CHROME_DEVEL_SANDBOX → sed-patch the store path.
      #   2. Script execs another shell script → recurse; rewrite caller to point
      #      at the patched callee (so the chain is preserved).
      #   3. Script execs an ELF (or recursion is exhausted) → inject an
      #      'export CHROME_DEVEL_SANDBOX=...' before the exec line.
      patchSandbox =
        {
          pkg,
          path,
          sandbox,
        }:
        let
          sandboxPath = "/run/wrappers/bin/${sandbox}-sandbox";
          patchedBin = prev.runCommand "${pkg.name}-sandbox-patched" { } ''
            process_script() {
              local input="$1" output="$2" sandboxPath="$3"

              # Only process shell scripts (require a #! shebang)
              head -c 2 "$input" | grep -q '^#!' || return 1

              # Extract the exec target (first /nix/store/... path on an exec line)
              local exec_target
              exec_target=$(grep -m1 '^\s*exec ' "$input" | grep -oE '/nix/store/[^ "]+' | head -1)
              [ -n "$exec_target" ] || return 1

              # Case 1: exec target is another shell script → recurse and rewrite caller
              if head -c 2 "$exec_target" 2>/dev/null | grep -q '^#!'; then
                local store_dir inner_output
                store_dir=$(echo "$exec_target" | sed 's|/nix/store/\([^/]*\)/.*|\1|')
                inner_output="$out/patched/$store_dir/$(basename "$exec_target")"
                if process_script "$exec_target" "$inner_output" "$sandboxPath"; then
                  mkdir -p "$(dirname "$output")"
                  sed "s|$exec_target|$inner_output|g" "$input" > "$output"
                  chmod +x "$output"
                  return 0
                fi
              fi

              # Case 2: exec target is an ELF (or recursion failed) → inject export before exec
              mkdir -p "$(dirname "$output")"
              awk -v sandbox="$sandboxPath" '
                !injected && /^[[:space:]]*exec / {
                  print "export CHROME_DEVEL_SANDBOX=\"" sandbox "\""
                  print "export XDG_CURRENT_DESKTOP=GNOME"
                  injected = 1
                }
                { print }
              ' "$input" > "$output"
              chmod +x "$output"
            }

            process_script "${pkg.out}/${path}" "$out/${path}" "${sandboxPath}"
          '';
        in
        # symlinkJoin doesn't preserve pkg attributes (version, meta, sandbox,
        # etc.), so merge them back: pkg's attributes are the base, joined's
        # outPath/drvPath win where they conflict, giving us the patched output
        # while preserving everything else the original package exposed.
        pkg
        // prev.symlinkJoin {
          name = pkg.name;
          paths = [
            patchedBin
            pkg
          ];
        };
    in
    {
      signal-desktop = patchSandbox {
        pkg = prev.signal-desktop;
        path = "bin/signal-desktop";
        sandbox = "electron";
      };
      element-desktop = patchSandbox {
        pkg = prev.element-desktop;
        path = "bin/element-desktop";
        sandbox = "electron";
      };
      filen-desktop = patchSandbox {
        pkg = prev.filen-desktop;
        path = "bin/filen-desktop";
        sandbox = "electron";
      };
      _1password-gui = prev._1password-gui.overrideAttrs {
        postInstall = ''
          rm $out/share/1password/chrome-sandbox
          ln -s /run/wrappers/bin/_1password-gui-sandbox $out/share/1password/chrome-sandbox
        '';
      };
    };
in
{
  imports = [
    ../modules/base.nix
    ../modules/development.nix
    ../modules/desktop.nix
    ../modules/sway.nix
    ../modules/ugc.nix
  ];

  nixpkgs.overlays = [ chromiumSandboxOverlay ];

  services.gnome-keyring.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk # fallback for other portal types
    ];
    configPackages = [ pkgs.sway ];
    config = {
      sway = {
        default = [
          "wlr"
          "gtk"
        ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
        "org.freedesktop.impl.portal.Secret" = [
          "gnome-keyring"
        ];
      };
    };
  };

  home.packages = [
    pkgs.ollama-rocm
    pkgs.llama-cpp-rocm
    pkgs.mpv

    pkgs.firefox
    pkgs.spotify
    pkgs._1password-gui
    pkgs.signal-desktop
    pkgs.element-desktop
    pkgs.filen-desktop
    pkgs.filen-cli

    pkgs.age
    pkgs.libfido2
    pkgs.yubikey-manager
  ];

  services.podman = {
    enable = true;
  };

  programs.ssh = {
    settings = {
      "*" = {
        IdentityFile = "~/.ssh/id_ed25519";
      };
      "i-*" = {
        User = "jenkins";
        StrictHostKeyChecking = "accept-new";
        ProxyCommand = builtins.concatStringsSep " " [
          "sh -c '"
          "if [ -n \"$EC2_SSH_REGION\" ]; then"
          "  REGIONS=\"$EC2_SSH_REGION\";"
          "else"
          "  REGIONS=\"us-east-1 us-west-2 ap-southeast-2\";"
          "fi;"
          "for region in $REGIONS; do"
          "  IP=$(aws ec2 describe-instances --region \"$region\" --instance-ids %h --query \"Reservations[0].Instances[0].PublicIpAddress\" --output text 2>/dev/null);"
          "  if [ -n \"$IP\" ] && [ \"$IP\" != \"None\" ]; then"
          "    exec nc \"$IP\" %p;"
          "  fi;"
          "done;"
          "echo \"Error: Could not resolve public IP for %h in any region\" >&2;"
          "exit 1'"
        ];
      };
    };
  };

  programs.git = {
    package = pkgs.gitFull;
    settings.url = {
      "ssh://git@github.com/canonical" = {
        insteadOf = "https://github.com/canonical";
      };
      "ssh://git@github.com/juju" = {
        insteadOf = "https://github.com/juju";
      };
      "ssh://git@github.com/hpidcock" = {
        insteadOf = "https://github.com/hpidcock";
      };
    };
  };

  home.stateVersion = "24.11";
}
