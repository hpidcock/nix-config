{
  ...
}:
{
  programs.waybar = {
    enable = true;
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: Noto, sans-serif;
        font-size: 12px;
        min-height: 0;
      }
      window#waybar {
        background: rgba(0, 43, 54, 0.8);
        border-bottom: 2px dotted rgba(7, 54, 66, 0.8);
        color: rgba(238, 232, 213, 1);
      }
      #workspaces button {
        padding: 3px 5px 0px 5px;
        background: transparent;
        color: rgba(238, 232, 213, 1);
        border-bottom: 2px solid transparent;
      }
      #workspaces button.focused {
        background-color: rgba(7, 54, 66, 0.8);
        border-bottom: 2px solid rgba(238, 232, 213, 1);
      }
      #mode, #clock {
        padding: 3px 10px 0px 10px;
        margin: 0 5px;
      }
      #mode {
        background: rgba(181, 137, 0, 0.8);
        border-bottom: 2px solid rgba(238, 232, 213, 1);
      }
      #clock {
        background-color: rgba(7, 54, 66, 0.8);
      }
      @keyframes blink {
        to {
          background-color: #ffffff;
          color: black;
        }
      }
    '';
    settings = {
      mainBar = {
        layer = "top";
        height = 18;
        modules-left = [
          "sway/workspaces"
          "sway/mode"
        ];
        modules-center = [ ];
        modules-right = [
          "clock"
          "tray"
        ];
        "sway/mode" = {
          format = ''<span style="italic">{}</span>'';
        };
        "tray" = {
          spacing = 8;
        };
        "clock" = {
          tooltip-format = "{:%Y-%m-%d | %H:%M}";
          format-alt = "{:%Y-%m-%d}";
        };
      };
    };
  };
}
