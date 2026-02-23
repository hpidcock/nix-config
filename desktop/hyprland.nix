{
  pkgs,
  lib,
  ...
}:
let
  hypr-run = (import ./hypr-run.nix { inherit pkgs lib; });
in
{
  imports = [
    ./waybar.nix
    ./wofi.nix
  ];

  home.packages = [
    hypr-run

    pkgs.alacritty
    pkgs.grim
    pkgs.mako
    pkgs.slurp
    pkgs.waybar
    pkgs.wl-clipboard
    pkgs.wofi
    pkgs.wlogout
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    extraConfig = ''
      exec-once = mako
      exec-once = waybar
      exec-once = 1password --silent
      exec-once = signal-desktop --disable-screen-security --start-in-tray --enable-gpu
      
      # Monitors
      monitor = DP-2, 3840x2160@144, 0x0, 1
      monitor = DP-1, 3840x2160@144, 3840x0, 1
      
      # Workspaces (1-7 on DP-2, 8-10 on DP-1)
      workspace = 1, monitor:DP-2, persistent:true
      workspace = 2, monitor:DP-2, persistent:true
      workspace = 3, monitor:DP-2, persistent:true
      workspace = 4, monitor:DP-2, persistent:true
      workspace = 5, monitor:DP-2, persistent:true
      workspace = 6, monitor:DP-2, persistent:true
      workspace = 7, monitor:DP-2, persistent:true
      workspace = 8, monitor:DP-1, persistent:true
      workspace = 9, monitor:DP-1, persistent:true
      workspace = 10, monitor:DP-1, persistent:true
      
      # Window rules
      #windowrulev2 = float, override, class:^1password$
      #windowrulev2 = float, override, class:^swaylock$
      #windowrulev2 = float, override, class:^grim$
      
      # Borders and gaps
      general {
        border_size = 0
        gaps_in = 6
        gaps_out = 0
        col.active_border = rgba(00000000)
        col.inactive_border = rgba(00000000)
      }
      
      decoration {
        rounding = 0
        blur {
          enabled = false
        }
        shadow {
          enabled = false
        }
      }
      
      # Animations
      animations {
        enabled = true
        animation = windows, 1, 8, default
        animation = border, 1, 8, default
      }
      
      # Input
      input {
        kb_layout = us
        kb_options = grp:win_menu
        follow_mouse = 1
      }
      
      # Keyboard shortcuts
      bind = SUPER, Q, killactive
      bind = SUPER, F, fullscreen
      bind = SUPER, H, togglefloating
      bind = SUPER, V, togglefloating
      bind = SUPER, E, togglesplit
      bind = SUPER, RETURN, exec, alacritty
      bind = SUPER, D, exec, wofi --show run -m -4
      bind = SUPER SHIFT, C, exec, hyprctl reload
      bind = SUPER SHIFT, E, exec, swaynag -t warning -m 'Confirm' -B 'Yes, exit hyprland' 'hyprctl dispatch exit'
      bind = SUPER SHIFT, S, exec, grim -g "$(slurp)" -t png /dev/stdout | wl-copy -t image/png
      bind = SUPER, L, exec, 1password --lock && swaylock -c 303030 -i ${../resources/bg.jpg}
      
      # Window movement
      bind = SUPER, LEFT, movewindow, l
      bind = SUPER, RIGHT, movewindow, r
      bind = SUPER, UP, movewindow, u
      bind = SUPER, DOWN, movewindow, d
      
      # Focus movement
      bind = SUPER, LEFT, movefocus, l
      bind = SUPER, RIGHT, movefocus, r
      bind = SUPER, UP, movefocus, u
      bind = SUPER, DOWN, movefocus, d
      
      # Workspace switching
      bind = SUPER, 1, workspace, 1
      bind = SUPER, 2, workspace, 2
      bind = SUPER, 3, workspace, 3
      bind = SUPER, 4, workspace, 4
      bind = SUPER, 5, workspace, 5
      bind = SUPER, 6, workspace, 6
      bind = SUPER, 7, workspace, 7
      bind = SUPER, 8, workspace, 8
      bind = SUPER, 9, workspace, 9
      bind = SUPER, 0, workspace, 10
      
      # Move window to workspace
      bind = SUPER SHIFT, 1, movetoworkspace, 1
      bind = SUPER SHIFT, 2, movetoworkspace, 2
      bind = SUPER SHIFT, 3, movetoworkspace, 3
      bind = SUPER SHIFT, 4, movetoworkspace, 4
      bind = SUPER SHIFT, 5, movetoworkspace, 5
      bind = SUPER SHIFT, 6, movetoworkspace, 6
      bind = SUPER SHIFT, 7, movetoworkspace, 7
      bind = SUPER SHIFT, 8, movetoworkspace, 8
      bind = SUPER SHIFT, 9, movetoworkspace, 9
      bind = SUPER SHIFT, 0, movetoworkspace, 10
    '';
  };
}
