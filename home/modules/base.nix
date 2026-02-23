{ pkgs, lib, config, ... }:
{
  imports = [
    ../../desktop/zsh.nix
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    PATH = "${config.home.homeDirectory}/go/bin:$PATH";
  };
  home.language = {
    base = "en_AU.utf8";
  };

  home.packages = [
    pkgs.vim
    pkgs.htop
    pkgs.wget
    pkgs.curl
    pkgs.gnupg
  ];

  programs.git = {
    enable = true;
    signing = {
      signByDefault = true;
      key = "C80B31F3A3B03C28C9ACAFFB89E735F9C1156A58";
    };
    settings.url = {
      "git+ssh://git.launchpad.net/" = {
        insteadOf = "lp:";
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
  };

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  programs.home-manager.enable = true;
}
