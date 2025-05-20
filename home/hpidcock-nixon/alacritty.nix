{
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.powerline-fonts
  ];

  programs.alacritty = {
    enable = true;
    settings = {
      general = {
        live_config_reload = true;
      };
      font.size = 17.0;
      font.bold.family = "DejaVu Sans Mono";
      font.italic.family = "DejaVu Sans Mono";
      font.normal.family = "DejaVu Sans Mono";
      cursor = {
        style = "Block";
        unfocused_hollow = true;
      };
      mouse.hide_when_typing = false;
      scrolling.history = 10000;
      scrolling.multiplier = 3;
      selection.save_to_clipboard = false;
      terminal = {
        shell.program = "zsh";
      };
      window = {
        decorations = "full";
        dynamic_padding = false;
        opacity = 0.85;
        startup_mode = "Windowed";
        padding.x = 2;
        padding.y = 2;
      };
      colors = {
        draw_bold_text_with_bright_colors = true;
        primary = {
          background = "0x002b36";
          foreground = "0x839496";
        };
        bright = {
          black = "0x002b36";
          blue = "0x839496";
          cyan = "0x93a1a1";
          green = "0x586e75";
          magenta = "0x6c71c4";
          red = "0xcb4b16";
          white = "0xfdf6e3";
          yellow = "0x657b83";
        };
        normal = {
          black = "0x073642";
          blue = "0x268bd2";
          cyan = "0x2aa198";
          green = "0x859900";
          magenta = "0xd33682";
          red = "0xdc322f";
          white = "0xeee8d5";
          yellow = "0xb58900";
        };
      };
    };
  };
}
