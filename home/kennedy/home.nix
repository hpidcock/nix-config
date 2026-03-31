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
    ../modules/base.nix
    ../modules/desktop.nix
  ];

  home.homeDirectory = "/Users/hpidcock";

  age.identityPaths = [ "/Users/hpidcock/.ssh/age" ];

  services.gpg-agent = {
    enableZshIntegration = true;
    enableExtraSocket = true;
  };

  home.packages = with pkgs; [
    mas
    uutils-coreutils-noprefix
    zsh
    git
    gh
    spotify
    signal-desktop
    openssh
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
    settings.url = {
      "ssh://git@github.com/hpidcock" = {
        insteadOf = "https://github.com/hpidcock";
      };
    };
  };

  programs.ssh = {
    enable = true;
    matchBlocks."*" = {
      identityFile = "~/.ssh/id_ed25519";
    };
  };

  home.stateVersion = "25.05";
}
