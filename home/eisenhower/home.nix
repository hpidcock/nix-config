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
  ];

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
    pkgs.xdg-desktop-portal-hyprland

    pkgs.ollama-rocm
    pkgs.llama-cpp-rocm
    pkgs.mpv

    pkgs.firefox
    pkgs.standardnotes
    pkgs.spotify
    pkgs._1password-gui
    pkgs.signal-desktop
    pkgs.element-desktop
    pkgs.nheko

    pkgs.age
  ];

  services.podman = {
    enable = true;
  };

  programs.ssh.matchBlocks = {
    "*" = {
      identityAgent = "\"~/.1password/agent.sock\"";
    };
    "github.com" = {
      identityAgent = "\"~/.1password/agent.sock\"";
    };
    "i-*" = {
      user = "jenkins";
      extraOptions = {
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
