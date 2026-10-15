{ pkgs, ... }:
{
  # Chromium and Electron apps require a SUID sandbox helper. The nix store is
  # read-only so the binary there can never have mode 4755, so expose SUID
  # copies at stable paths under /run/wrappers/bin. The home-manager side
  # (home/modules/chromium-sandbox.nix) patches app wrappers to point
  # CHROME_DEVEL_SANDBOX at these.
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
}
