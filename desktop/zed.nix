{
  pkgs,
  pkgs-unstable,
  ...
}:
{
  programs.zed-editor = {
    enable = true;
    package = pkgs-unstable.zed-editor;
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
        line_height = "standard";
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
      edit_predictions = {
        mode = "subtle";
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
}
