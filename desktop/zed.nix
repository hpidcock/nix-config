{
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.nil
    pkgs.nixd
    pkgs.nixfmt-rfc-style
  ];
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor;
    extraPackages = [
      pkgs.nerd-fonts.blex-mono
      pkgs.git
    ];
    userSettings = {
      theme = "Gruvbox Light";
      vim_mode = true;
      hide_mouse = "never";
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
      show_whitespaces = "all";
      wrap_guides = [
        80
        81
        82
      ];
      "experimental.theme_overrides" = {
        "editor.wrap_guide" = "#28282840";
      };
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
            path = "${pkgs.package-version-server}/bin/package-version-server";
          };
        };
        "nixd" = {
          binary = {
            path = "${pkgs.nixd}/bin/nixd";
          };
        };
        "nil" = {
          binary = {
            path = "${pkgs.nil}/bin/nil";
          };
          initialization_options = {
            formatting = {
              command = [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];
            };
          };
        };
      };
    };
  };
}
