{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./alacritty.nix
    ./sway.nix
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
    pkgs.zsh
    pkgs.vim
    pkgs.git
    pkgs.htop
    pkgs.wget
    pkgs.curl
    pkgs.gnupg
    pkgs.pinentry-rofi

    pkgs.firefox
    pkgs.standardnotes
    pkgs.spotify
    pkgs._1password-gui
    pkgs.signal-desktop

    pkgs.podman
  ];

  programs.git = {
    enable = true;
    userName = "Harry Pidcock";
    userEmail = "harry.pidcock@canonical.com";
    signing = {
      signByDefault = true;
      key = "47A14177CFB4DB92";
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

  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; } # 1password
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

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
