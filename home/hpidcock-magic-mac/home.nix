{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./alacritty.nix
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

  programs.zsh = {
    enable = true;
    initContent = lib.mkBefore ''
      zvm_config() {
        ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLOCK
        ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_UNDERLINE
      }
      function modver() {
        TZ=UTC git --no-pager show --quiet --abbrev=12 \
        --date='format-local:%Y%m%d%H%M%S' \
        --format="%cd-%h"
      }
      alias modver=modver
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [ ];
      theme = "agnoster";
    };
    plugins = [
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];
  };

  programs.zed-editor = {
    enable = true;
    extraPackages = [
      pkgs.nerd-fonts.blex-mono
      pkgs.nil
      pkgs.nixd
      pkgs.nixfmt-rfc-style
      pkgs.package-version-server
    ];
    userSettings = {
      theme = "Gruvbox Light";
      vim_mode = true;
      ui_font_size = 18.0;
      buffer_font_size = 18.0;
      buffer_font_features = {
        calt = false;
      };
      terminal = {
        font_family = "BlexMono Nerd Font";
        shell = {
          program = "${pkgs.zsh}/bin/zsh";
        };
      };
      remove_trailing_whitespace_on_save = false;
      show_whitespace = "all";
      wrap_guides = [ 80 ];
      languages = {
        "Go" = {
          remove_trailing_whitespace_on_save = false;
          use_autoclose = false;
          tab_size = 4;
        };
        "YAML" = {
          tab_size = 2;
        };
      };
      lsp = {
        "package-version-server" = {
          binary = {
            path = "package-version-server";
          };
        };
        "nil" = {
          initialization_options = {
            formatting = {
              command = [ "nixfmt" ];
            };
          };
        };
      };
    };
  };
  
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
