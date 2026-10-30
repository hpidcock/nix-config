{
  pkgs,
  ...
}:
{
  imports = [
    ../modules/base.nix
    ../modules/development.nix
    ../modules/desktop.nix
    ../modules/sway.nix
    ../modules/ugc.nix
    ../modules/openshell.nix
  ];

  varying = {
    #fontSize = 12;
    #uiFontSize = 12;
    #cursorSize = 22;
    #gapSize = 2;
    hasBattery = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk # fallback for other portal types
    ];
    configPackages = [ pkgs.sway ];
    config = {
      sway = {
        default = [
          "wlr"
          "gtk"
        ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
        "org.freedesktop.impl.portal.Secret" = [
          "gnome-keyring"
        ];
      };
    };
  };

  services.gnome-keyring.enable = true;

  # Local OpenShell gateway on top of the host's rootless podman.socket.
  services.openshell = {
    enable = true;
    managePodmanSocket = false;
  };

  services.ap = {
    enable = true;
    sync.interval = "6h";
    browsers = {
      chromium = true;
      chromeExtensionId = "aengjimeghgknfnmakbkphamneakgfib";
    };
  };

  home.packages = [
    pkgs.ollama-vulkan
    pkgs.brightnessctl
    pkgs.spotify
    pkgs.signal-desktop
    pkgs.claude-code
    pkgs.mattermost-desktop
    pkgs.element-desktop
  ];

  programs.ssh = {
    package = pkgs.openssh_gssapi;
    matchBlocks = {
    };
  };

  programs.git = {
    package = pkgs.gitFull;
    settings.url = {
      "ssh://git@github.com/" = {
        insteadOf = "https://github.com/";
      };
    };
  };

  home.stateVersion = "25.11";
}
