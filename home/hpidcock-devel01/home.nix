{
  pkgs,
  ...
}:
{
  imports = [
    ../../desktop/zsh.nix
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
  services.gpg-agent = {
    enable = false;
  };

  home.packages = [
    pkgs.vim
    pkgs.gh
    pkgs.htop
    pkgs.wget
    pkgs.curl
    pkgs.gnupg
    pkgs.esphome
    pkgs.difftastic

    pkgs.podman
    pkgs.podman-compose
    pkgs.skopeo
    pkgs.minikube
    pkgs.kubectl
    pkgs.awscli2
    pkgs.google-cloud-sdk
    pkgs.ssm-session-manager-plugin

    pkgs.juju-dev-shell
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.ssh = {
    enable = true;
  };

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = "Harry Pidcock";
    userEmail = "harry.pidcock@canonical.com";
    signing = {
      signByDefault = true;
      key = "C80B31F3A3B03C28C9ACAFFB89E735F9C1156A58";
    };
    extraConfig.url = {
      "git+ssh://git.launchpad.net/" = {
        insteadOf = "lp:";
      };
      "ssh://git@github.com/" = {
        insteadOf = "https://github.com/";
      };
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
