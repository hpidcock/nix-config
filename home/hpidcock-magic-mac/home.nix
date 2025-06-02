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
  };

  home.packages = [
    pkgs.zsh
    pkgs.vim
    pkgs.git
    pkgs.gh
    pkgs.htop
    pkgs.wget
    pkgs.curl
    pkgs.gnupg
    pkgs.podman
  ];

  programs.git = {
    enable = true;
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
    extraConfig.safe.directory = "/etc/nixos";
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
