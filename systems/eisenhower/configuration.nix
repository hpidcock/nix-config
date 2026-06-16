{
  pkgs,
  ...
}:
let
  system = "x86_64-linux";
  # A thin, content-stable wrapper so that the GDM desktop file's Exec path
  # never changes when home-manager rebuilds sway-run with a new store hash.
  # At runtime it simply delegates to the current home-manager profile's
  # sway-run, which is always up-to-date after `home-manager switch`.
  sway-session = pkgs.writeShellScriptBin "sway-session" ''
    exec "$HOME/.nix-profile/bin/sway-run" "$@"
  '';
in
{
  config = {
    nixpkgs.hostPlatform = system;
    nixpkgs.config.allowUnfree = true;
    system-manager.allowAnyDistro = true;
    system-graphics.enable = true;
    environment.systemPackages = [
      pkgs.vim
      pkgs.home-manager
    ];

    security.wrappers."__chromium-suid-sandbox" = {
      owner = "root";
      group = "root";
      source = "${pkgs.ungoogled-chromium.sandbox}/bin/__chromium-suid-sandbox";
      setuid = true;
    };
    security.wrappers.electron-sandbox = {
      owner = "root";
      group = "root";
      source = "${pkgs.electron.out}/libexec/electron/chrome-sandbox";
      setuid = true;
    };
    security.wrappers._1password-gui-sandbox = {
      owner = "root";
      group = "root";
      source = "${pkgs._1password-gui.out}/share/1password/chrome-sandbox";
      setuid = true;
    };

    # GDM only scans system-level XDG_DATA_DIRS for wayland-sessions/.
    # Symlink the session file into /usr/local/share/wayland-sessions/,
    # which is in GDM's default XDG_DATA_DIRS on Ubuntu.
    environment.etc."wayland-sessions/sway.desktop".text = ''
      [Desktop Entry]
      Name=Sway
      Comment=An i3-compatible Wayland compositor
      Exec=${sway-session}/bin/sway-session
      Type=Application
      DesktopNames=sway
    '';

    systemd.services."sway-wayland-session" = {
      description = "Expose sway wayland session to GDM";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = [
          "${pkgs.bash}/bin/bash -c 'mkdir -p /usr/local/share/wayland-sessions && ln -sf /etc/wayland-sessions/sway.desktop /usr/local/share/wayland-sessions/sway.desktop'"
        ];
        ExecStop = "${pkgs.coreutils}/bin/rm -f /usr/local/share/wayland-sessions/sway.desktop";
      };
    };

    # Chromium and Electron apps require a SUID sandbox helper.
    # The nix store is read-only so the binary there can never have mode 4755.
    # Create a mutable SUID copy at a stable path that the nixpkgs overlay below
    # (in home-manager) points CHROME_DEVEL_SANDBOX at.
    #systemd.services."chromium-suid-sandbox" = {
    #  description = "Set up Chromium/Electron SUID sandbox";
    #  wantedBy = [ "multi-user.target" ];
    #  after = [ "local-fs.target" ];
    #  serviceConfig = {
    #    Type = "oneshot";
    #    RemainAfterExit = true;
    #    ExecStart = toString (
    #      pkgs.writeShellScript "chromium-sandbox-setup" ''
    #        mkdir -p /run/wrappers/bin
    #        install -m 4755 -o root -g root \
    #          ${pkgs.ungoogled-chromium.sandbox}/bin/__chromium-suid-sandbox \
    #          /run/wrappers/bin/chrome-sandbox
    #      ''
    #    );
    #    ExecStop = "${pkgs.coreutils}/bin/rm -f /run/wrappers/bin/chrome-sandbox";
    #  };
    #};
  };
}
