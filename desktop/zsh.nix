{
  pkgs,
  lib,
  ...
}:
{
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
      function test_changed_packages() {
        local changed_files=$(git diff --name-only HEAD | grep '\.go$')          
        if [ -z "$changed_files" ]; then
          echo "No Go files changed"
          return 0
        fi
        local packages=$(echo "$changed_files" | xargs -n1 dirname | sort -u | sed 's|^|./|' | tr '\n' ' ')
        go test "$@" $packages
      }
      alias ggt=test_changed_packages
    '';
    plugins = [
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];
  };
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      # Transliteration of https://github.com/starship/starship/blob/master/docs
      # /public/presets/toml/pastel-powerline.toml
      # Heavily modified but under original ISC license.
      add_newline = false;
      format = lib.concatStrings [
        "[](color_orange)"
        "$os"
        "$username"
        "[](bg:color_yellow fg:color_orange)"
        "$directory"
        "[](fg:color_yellow bg:color_aqua)"
        "$git_branch"
        "$git_status"
        "[](fg:color_aqua bg:color_bg1)"
        "$character"
        "[ ](fg:color_bg1)"
      ];
      palette = "solarized_dark";
      palettes.solarized_dark = {
        color_fg0 = "#eee8d5";
        color_bg1 = "#073642";
        color_bg3 = "#586e75";
        color_blue = "#268bd2";
        color_aqua = "#2aa198";
        color_green = "#859900";
        color_orange = "#cb4b16";
        color_purple = "#6c71c4";
        color_red = "#dc322f";
        color_yellow = "#b58900";
      };
      os = {
        disabled = false;
        style = "bg:color_orange fg:color_fg0";
        symbols = {
          Ubuntu = "󰕈";
          Linux = "󰌽";
          Macos = "󰀵";
          NixOS = "";
        };
      };
      username = {
        show_always = true;
        style_user = "bg:color_orange fg:color_fg0";
        style_root = "bg:color_orange fg:color_fg0";
        format = "[ $user ]($style)";
      };
      directory = {
        style = "fg:color_fg0 bg:color_yellow";
        format = "[ $path ]($style)";
        truncation_length = 0;
        truncation_symbol = "…/";
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = "󰝚 ";
          "Pictures" = " ";
          "Developer" = "󰲋 ";
        };
      };
      git_branch = {
        symbol = "";
        style = "bg:color_aqua";
        format = "[[ $symbol $branch ](fg:color_fg0 bg:color_aqua)]($style)";
      };
      git_status = {
        style = "bg:color_aqua";
        format = "[[($all_status$ahead_behind )](fg:color_fg0 bg:color_aqua)]($style)";
      };
      line_break = {
        disabled = true;
      };
      character = {
        disabled = false;
        format = "[ ](bg:color_bg1)$symbol";
        success_symbol = "[#](fg:color_aqua bg:color_bg1)";
        error_symbol = "[#](fg:color_red bg:color_bg1)";
        vimcmd_symbol = "[#](fg:color_green bg:color_bg1)";
        vimcmd_replace_one_symbol = "[#](fg:color_purple bg:color_bg1)";
        vimcmd_replace_symbol = "[#](fg:color_purple bg:color_bg1)";
        vimcmd_visual_symbol = "[#](fg:color_yellow bg:color_bg1)";
      };
    };
  };
}
