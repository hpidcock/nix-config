{
  pkgs,
  lib,
  config,
  ...
}:
let
  masApps = [
    "1475387142" # Tailscale
    "1569813296" # 1Password for Safari
    "682658836" # GarageBand
    "408981434" # iMovie
    "409183694" # Keynote
    "409203825" # Numbers
    "409201541" # Pages
  ];
in
{
  imports = [
    ../../desktop/alacritty.nix
    ../../desktop/zsh.nix
    ../../desktop/zed.nix
  ];

  age.identityPaths = [ "/Users/hpidcock/.ssh/age" ];

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

  home.packages = with pkgs; [
    mas
    uutils-coreutils-noprefix
    zsh
    vim
    git
    gh
    htop
    wget
    curl
    gnupg
    spotify
    signal-desktop-bin
    #element-desktop
    #ollama
    #utm
    #esphome
  ];

  home.activation = {
    mas = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      comm -1 -3\
        <(${pkgs.mas}/bin/mas list | ${pkgs.gawk}/bin/awk '{print $1}' | sort)\
        <(echo ${lib.concatStringsSep " " masApps} | tr " " "\n" | sort)\
        | run xargs -I % -n1 ${pkgs.mas}/bin/mas install %
      comm -2 -3\
        <(${pkgs.mas}/bin/mas list | ${pkgs.gawk}/bin/awk '{print $1}' | sort)\
        <(echo ${lib.concatStringsSep " " masApps} | tr " " "\n" | sort)\
        | run xargs -I % -n1 ${pkgs.mas}/bin/mas uninstall %
    '';
  };

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
    matchBlocks."merkel.local" = {
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
