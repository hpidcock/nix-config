{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./alacritty.nix
    ./sway.nix
    ./waybar.nix
    ./wofi.nix
  ];

  home.username = "hpidcock";
  home.homeDirectory = "/home/hpidcock";
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
  ];
  home.sessionVariables = {
    EDITOR = "vim";
    PATH = "/home/hpidcock/go/bin:$PATH";
  };
  home.language = {
    base = "en_AU.utf8";
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-rofi;
  };

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
        TZ=UTC git --no-pager show \
        --quiet \
        --abbrev=12 \
        --date='format-local:%Y%m%d%H%M%S' \
        --format="%cd-%h"
      }
      alias modver=modver
      function juju_kill_controllers() {
        juju controllers --format=yaml | yq '.controllers | keys | .[]' | xargs -n 1 juju kill-controller --no-prompt --timeout 0s
      }
      alias juju-kill-controllers=juju_kill_controllers
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

  home.pointerCursor = {
    enable = true;
    package = pkgs.apple-cursor;
    name = "macOS";
    gtk.enable = true;
  };

  programs.zed-editor = {
    enable = true;
    extraPackages = [
      pkgs.package-version-server
      pkgs.nixd
      pkgs.nil
      pkgs.nixfmt-rfc-style
    ];
    userSettings = {
      theme = "Gruvbox Light";
      buffer_font_size = 14.0;
      vim_mode = true;
      buffer_font_features = {
        calt = false;
      };
      terminal = {
        font_family = "DejaVu Sans Mono";
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
