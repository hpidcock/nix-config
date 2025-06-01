{
  pkgs,
  lib,
  ...
}:
let
  sway-run = (import ./sway-run.nix { inherit pkgs lib; });
in
{
  imports = [
    ./waybar.nix
    ./wofi.nix
  ];

  home.packages = [
    sway-run

    pkgs.alacritty
    pkgs.grim
    pkgs.mako
    pkgs.slurp
    pkgs.waybar
    pkgs.wl-clipboard
    pkgs.wofi
  ];

  home.pointerCursor = {
    enable = true;
    package = pkgs.apple-cursor;
    name = "macOS";
    gtk.enable = true;
  };

  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;
    wrapperFeatures.gtk = true;
    config = null;
    extraConfig = ''
      font pango:monospace 1
      seat seat0 xcursor_theme macOS 32

      set $mod Mod4

      # Control bindings
      bindsym $mod+Shift+q kill
      bindsym $mod+f fullscreen toggle
      bindsym $mod+h split h
      bindsym $mod+v split v
      bindsym $mod+e layout toggle split
      floating_modifier $mod

      # Motion bindings
      bindsym $mod+Left focus left
      bindsym $mod+Down focus down
      bindsym $mod+Up focus up
      bindsym $mod+Right focus right
      bindsym $mod+Shift+Left move left
      bindsym $mod+Shift+Down move down
      bindsym $mod+Shift+Up move up
      bindsym $mod+Shift+Right move right

      # Switch workspaces
      bindsym $mod+1 workspace 1
      bindsym $mod+2 workspace 2
      bindsym $mod+3 workspace 3
      bindsym $mod+4 workspace 4
      bindsym $mod+5 workspace 5
      bindsym $mod+6 workspace 6
      bindsym $mod+7 workspace 7
      bindsym $mod+8 workspace 8
      bindsym $mod+9 workspace 9
      bindsym $mod+0 workspace 10
      workspace_auto_back_and_forth yes

      # Move containers to workspaces
      bindsym $mod+Shift+1 move container to workspace 1
      bindsym $mod+Shift+2 move container to workspace 2
      bindsym $mod+Shift+3 move container to workspace 3
      bindsym $mod+Shift+4 move container to workspace 4
      bindsym $mod+Shift+5 move container to workspace 5
      bindsym $mod+Shift+6 move container to workspace 6
      bindsym $mod+Shift+7 move container to workspace 7
      bindsym $mod+Shift+8 move container to workspace 8
      bindsym $mod+Shift+9 move container to workspace 9
      bindsym $mod+Shift+0 move container to workspace 10

      # Commands
      bindsym $mod+Return exec ${pkgs.alacritty}/bin/alacritty
      bindsym $mod+d exec ${pkgs.wofi}/bin/wofi --show run -m -4
      bindsym $mod+Shift+c reload
      bindsym $mod+Shift+e exec "swaynag -t warning -m 'Confirm' -B 'Yes, exit sway' 'swaymsg exit'"
      bindsym $mod+shift+s exec ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" -t png /dev/stdout | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png
      bindsym $mod+l exec ${pkgs._1password-gui}/bin/1password --lock && ${pkgs.swaylock}/bin/swaylock -c 303030 -i ${./bg.jpg}

      # Window Colours        border    bg        text      indicator c_border
      client.focused          #00000000 #859900AA #00000000 #00000000 #00000000
      client.focused_inactive #00000000 #00000000 #00000000 #00000000 #00000000
      client.unfocused        #00000000 #00000000 #00000000 #00000000 #00000000
      client.urgent           #00000000 #00000000 #00000000 #00000000 #00000000

      # Layout and Borders
      gaps inner 8
      gaps outer 4
      hide_edge_borders both
      titlebar_border_thickness 0
      titlebar_padding 0
      default_border none
      tiling_drag disable

      # Environment
      exec --no-startup-id ${pkgs.mako}/bin/mako
      exec --no-startup-id ${pkgs.waybar}/bin/waybar
      exec --no-startup-id ${pkgs._1password-gui}/bin/1password --silent

      # Display setup
      set $left "DP-2"
      set $right "DP-1"

      output $left pos 0 0 res 3840x2160@143.963Hz
      output $right pos 3840 0 res 3840x2160@143.963Hz
      output "*" background ${./bg.jpg} fill

      workspace 1 output $left $right
      workspace 2 output $left $right
      workspace 3 output $left $right
      workspace 4 output $left $right
      workspace 5 output $left $right
      workspace 6 output $left $right
      workspace 7 output $left $right
      workspace 8 output $right $left
      workspace 9 output $right $left
      workspace 10 output $right $left
    '';
  };
}
