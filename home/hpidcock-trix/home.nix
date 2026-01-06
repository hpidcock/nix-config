{
  pkgs,
  ...
}:
{
  imports = [
    ../../desktop/alacritty.nix
    ../../desktop/zsh.nix
    ../../desktop/zed.nix
  ];

  home.username = "hpidcock";
  home.homeDirectory = "/Users/hpidcock";
  home.sessionVariables = {
    EDITOR = "vim";
    PATH = "/Users/hpidcock/go/bin:$PATH";
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
    enableZshIntegration = true;
    enableExtraSocket = true;
  };

  home.packages = [
    pkgs.uutils-coreutils-noprefix
    pkgs.zsh
    pkgs.vim
    pkgs.git
    pkgs.gh
    pkgs.htop
    pkgs.wget
    pkgs.curl
    pkgs.gnupg
    pkgs.podman
    pkgs.librewolf
    pkgs.spotify
    pkgs.signal-desktop-bin
    pkgs.element-desktop
    pkgs.ollama
    pkgs.utm
    pkgs.esphome
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
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
      "ssh://git@github.com/hpidcock" = {
        insteadOf = "https://github.com/hpidcock";
      };
    };
    ignores = [
      ".envrc"
      ".direnv/"
    ];
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      identityAgent = "\"/Users/hpidcock/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
    };
    matchBlocks."github.com" = {
      identityAgent = "\"/Users/hpidcock/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
    };
    matchBlocks."devel01.tail5183a3.ts.net" = {
      identityAgent = "\"/Users/hpidcock/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
      forwardAgent = true;
      remoteForwards = [
        {
          bind.address = "/run/user/1000/gnupg/S.gpg-agent";
          host.address = "/Users/hpidcock/.gnupg/S.gpg-agent.extra";
        }
      ];
    };
  };

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  programs.home-manager.enable = true;
  home.stateVersion = "25.05";
}
