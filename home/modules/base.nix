{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ../../desktop/settings.nix
    ../../desktop/zsh.nix
  ];

  news.display = "silent";

  home.sessionVariables = {
    EDITOR = "vim";
    PATH = "${config.home.homeDirectory}/go/bin:$PATH";
  };
  home.language = {
    base = "en_AU.utf8";
  };

  home.packages = [
    pkgs.htop
    pkgs.wget
    pkgs.curl
    pkgs.gnupg
  ];

  programs.git = {
    enable = true;
    signing = {
      signByDefault = true;
      key = "~/.ssh/id_ed25519_sk_rk_ca-key.pub";
      format = "ssh";
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

  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ NeoSolarized ];
    extraConfig = ''
      vnoremap p "_dP
    '';
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
