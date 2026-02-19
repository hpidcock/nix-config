{
  pkgs,
  ...
}:
{
  imports = [
    ../../desktop/alacritty.nix
    ../../desktop/sway.nix
    ../../desktop/zsh.nix
    ../../desktop/zed.nix
  ];

  home.username = "hpidcock";
  home.homeDirectory = "/home/hpidcock";
  home.sessionVariables = {
    EDITOR = "vim";
    PATH = "/home/hpidcock/go/bin:$PATH";
  };
  home.language = {
    base = "en_AU.utf8";
  };
  fonts.fontconfig = {
    enable = true;
  };
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-rofi;
  };

  home.packages = [
    pkgs.vim
    pkgs.gh
    pkgs.htop
    pkgs.wget
    pkgs.curl
    pkgs.gnupg
    pkgs.pinentry-rofi
    pkgs.difftastic
    pkgs.ripgrep
    pkgs.ollama-vulkan
    pkgs.mpv

    pkgs.firefox
    pkgs.standardnotes
    pkgs.spotify
    pkgs._1password-gui
    pkgs.signal-desktop
    pkgs.element-desktop
    pkgs.nheko

    pkgs.podman
    pkgs.podman-compose
    pkgs.skopeo
    pkgs.minikube
    pkgs.kubectl
    pkgs.awscli2
    pkgs.google-cloud-sdk
    pkgs.ssm-session-manager-plugin
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      identityAgent = "\"~/.1password/agent.sock\"";
    };
    matchBlocks."github.com" = {
      identityAgent = "\"~/.1password/agent.sock\"";
    };
    matchBlocks."i-*" = {
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
    enable = true;
    package = pkgs.gitFull;
    settings.user.name = "Harry Pidcock";
    settings.user.email = "harry.pidcock@canonical.com";
    signing = {
      signByDefault = true;
      key = "C80B31F3A3B03C28C9ACAFFB89E735F9C1156A58";
    };
    settings.url = {
      "git+ssh://git.launchpad.net/" = {
        insteadOf = "lp:";
      };
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
    ignores = [
      ".envrc"
      ".direnv/"
    ];
  };

  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; } # 1password
    ];
  };

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
