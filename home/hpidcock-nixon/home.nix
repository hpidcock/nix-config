{ config, pkgs, lib, inputs, ... }:
let sway-run = (import ./sway-run.nix { inherit pkgs lib; });
in {
  home.username = "hpidcock";
  home.homeDirectory = "/home/hpidcock";
  home.packages = [
    pkgs.zsh
    pkgs.vim
    pkgs.git
    pkgs.htop
    pkgs.wget
    pkgs.curl

    pkgs.nixd
    pkgs.nil
    pkgs.nixfmt

    sway-run
    pkgs.mako
    pkgs.grim
    pkgs.waybar
    pkgs.wl-clipboard
    pkgs.slurp
    pkgs.wl-mirror
    pkgs.powerline-fonts

    pkgs.firefox
    pkgs.brave
    pkgs.standardnotes
    pkgs.spotify
    pkgs._1password-gui
    pkgs.signal-desktop
    pkgs.zed-editor
  ];
  home.sessionVariables = {
    EDITOR = "vim";
    PATH = "/home/hpidcock/go/bin:$PATH";
  };
  home.language = { base = "en_AU.utf8"; };
  programs.git = {
    enable = true;
    userName = "Harry Pidcock";
    userEmail = "harry.pidcock@canonical.com";
    signing = {
      signByDefault = true;
      key = "47A14177CFB4DB92";
    };
    extraConfig.url = {
      "git+ssh://git.launchpad.net/" = { insteadOf = "lp:"; };
      "ssh://git@github.com/" = { insteadOf = "https://github.com/"; };
    };
  };

  programs.alacritty = {
    enable = true;
    package = pkgs.alacritty;
    settings = {
      general = { live_config_reload = true; };
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
      terminal = { shell.program = "zsh"; };
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

  programs.zsh = {
    enable = true;
    initExtraFirst = ''
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
    plugins = [{
      name = "vi-mode";
      src = pkgs.zsh-vi-mode;
      file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
    }];
  };

  programs.wofi = {
    enable = true;
    package = pkgs.wofi;
    style = ''
      window {
        margin: 0px;
        border: 1px solid #928374;
        background-color: #002b36;
      }
      #input {
        margin: 5px;
        border: none;
        color: #839496;
        background-color: #073642;
      }
      #inner-box {
        margin: 5px;
        border: none;
        background-color: #002b36;
      }
      #outer-box {
        margin: 5px;
        border: none;
        background-color: #002b36;
      }
      #scroll {
        margin: 0px;
        border: none;
      }
      #text {
        margin: 5px;
        border: none;
        color: #839496;
      }
      #entry:selected {
        background-color: #073642;
      }
    '';
  };

  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;
    wrapperFeatures.gtk = true;
    config = null;
    extraConfig = ''
      # Font for window titles. Will also be used by the bar unless a different font
      # is used in the bar {} block below.
      font pango:Noto 0.001

      set $mod Mod4

      gaps inner 8
      gaps outer 4

      set $base00 #101218
      set $base01 #1f222d
      set $base02 #252936
      set $base03 #7780a1
      set $base04 #C0C5CE
      set $base05 #d1d4e0
      set $base06 #C9CCDB
      set $base07 #ffffff
      set $base08 #ee829f
      set $base09 #f99170
      set $base0A #ffefcc
      set $base0B #a5ffe1
      set $base0C #97e0ff
      set $base0D #97bbf7
      set $base0E #c0b7f9
      set $base0F #fcc09e

      # Define names for default workspaces for which we configure key bindings later on.
      # We use variables to avoid repeating the names in multiple places.
      set $ws1 "1"
      set $ws2 "2"
      set $ws3 "3"
      set $ws4 "4"
      set $ws5 "5"
      set $ws6 "6"
      set $ws7 "7"
      set $ws8 "8"
      set $ws9 "9"
      set $ws10 "10"

      # use Mouse+$mod to drag floating windows to their wanted position
      floating_modifier $mod

      bindsym $mod+Return exec alacritty 
      bindsym $mod+Shift+q kill
      bindsym $mod+d exec LC_ALL="C" wofi --show run --font "DejaVu Serif 18" -m -4 
      bindsym $mod+Left focus left
      bindsym $mod+Down focus down
      bindsym $mod+Up focus up
      bindsym $mod+Right focus right
      bindsym $mod+Shift+Left move left
      bindsym $mod+Shift+Down move down
      bindsym $mod+Shift+Up move up
      bindsym $mod+Shift+Right move right
      bindsym $mod+h split h
      bindsym $mod+v split v
      bindsym $mod+f fullscreen toggle
      bindsym $mod+e layout toggle split
      bindsym $mod+Shift+space floating toggle
      bindsym $mod+space focus mode_toggle
      bindsym $mod+a focus parent

      # focus the child container
      #bindsym $mod+d focus child

      # switch to workspace
      bindsym $mod+1 workspace $ws1
      bindsym $mod+2 workspace $ws2
      bindsym $mod+3 workspace $ws3
      bindsym $mod+4 workspace $ws4
      bindsym $mod+5 workspace $ws5
      bindsym $mod+6 workspace $ws6
      bindsym $mod+7 workspace $ws7
      bindsym $mod+8 workspace $ws8
      bindsym $mod+9 workspace $ws9
      bindsym $mod+0 workspace $ws10

      # move focused container to workspace
      bindsym $mod+Shift+1 move container to workspace $ws1
      bindsym $mod+Shift+2 move container to workspace $ws2
      bindsym $mod+Shift+3 move container to workspace $ws3
      bindsym $mod+Shift+4 move container to workspace $ws4
      bindsym $mod+Shift+5 move container to workspace $ws5
      bindsym $mod+Shift+6 move container to workspace $ws6
      bindsym $mod+Shift+7 move container to workspace $ws7
      bindsym $mod+Shift+8 move container to workspace $ws8
      bindsym $mod+Shift+9 move container to workspace $ws9
      bindsym $mod+Shift+0 move container to workspace $ws10

      # reload the configuration file
      bindsym $mod+Shift+c reload
      # exit i3 (logs you out of your X session)
      bindsym $mod+Shift+e exec "swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your session.' -B 'Yes, exit sway' 'swaymsg exit'"

      bindsym $mod+shift+s exec grim -g "$(slurp)" -t png /dev/stdout | wl-copy -t image/png 

      # resize window (you can also use the mouse for that)
      mode "resize" {
      # same bindings, but for the arrow keys
      bindsym Left        resize shrink width 10 px or 10 ppt
      bindsym Down        resize grow height 10 px or 10 ppt
      bindsym Up          resize shrink height 10 px or 10 ppt
      bindsym Right       resize grow width 10 px or 10 ppt
      # back to normal: Enter or Escape or $mod+r
      bindsym Return mode "default"
      bindsym Escape mode "default"
      bindsym $mod+r mode "default"
      }

      bindsym $mod+r mode "resize"

      # Widow Colours
      #                       border  background text    indicator
      client.focused          $base01 $base01    $base07 $base0F $base01
      client.focused_inactive $base02 $base02    $base03 $base0F $base02
      client.unfocused        $base02 $base02    $base03 $base0F $base02
      client.urgent           $base02 $base08    $base00 $base0F $base02

      hide_edge_borders both
      titlebar_border_thickness 0
      titlebar_padding 0
      exec dbus-update-activation-environment 2>/dev/null && \
           dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP=sway

      exec --no-startup-id ${pkgs.mako}/bin/mako
      exec --no-startup-id ${pkgs.waybar}/bin/waybar

      set $disp1 "DP-2"
      set $disp2 "DP-1"
      output $disp1 pos 0 0 res 3840x2160@143.963Hz
      output $disp2 pos 3840 0 res 3840x2160@143.963Hz
      output "*" background ${./bg.jpg} fill

      workspace 1 output $disp1 $disp2
      workspace 2 output $disp1 $disp2
      workspace 3 output $disp1 $disp2
      workspace 4 output $disp1 $disp2
      workspace 5 output $disp1 $disp2
      workspace 6 output $disp1 $disp2
      workspace 7 output $disp1 $disp2
      workspace 8 output $disp2 $disp1
      workspace 9 output $disp2 $disp1
      workspace 10 output $disp2 $disp1

      bindsym $mod+l exec ${pkgs.swaylock}/bin/swaylock -c 303030 

      for_window [app_id="galculator"] floating enable
      for_window [app_id="firefox" title="^Picture-in-Picture$"] floating enable, move position 877 450, sticky enable
    '';
  };

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
        height = 20;
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ ];
        modules-right = [ "clock" "tray" ];
        "sway/mode" = { format = ''<span style="italic">{}</span>''; };
        "tray" = { spacing = 10; };
        "clock" = {
          tooltip-format = "{:%Y-%m-%d | %H:%M}";
          format-alt = "{:%Y-%m-%d}";
        };
      };
    };
  };

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
