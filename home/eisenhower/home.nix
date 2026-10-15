{
  pkgs,
  ...
}:
{
  imports = [
    ../modules/base.nix
    ../modules/development.nix
    ../modules/desktop.nix
    ../modules/sway.nix
    ../modules/ugc.nix
    ../modules/chromium-sandbox.nix
  ];

  chromiumSandbox = {
    electronApps = [
      "signal-desktop"
      "element-desktop"
      "filen-desktop"
    ];
    onePassword = true;
  };

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

    pkgs.bambu-studio
    pkgs.freecad

    pkgs.esphome
    pkgs.claude-code
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
      "ssh://git@github.com/" = {
        insteadOf = "https://github.com/";
      };
    };
  };

  home.stateVersion = "24.11";
}
