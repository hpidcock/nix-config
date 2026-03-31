final: prev: {
  signal-desktop = prev.signal-desktop.overrideAttrs {
    version = "8.5.0";
    src = prev.fetchurl {
      url = "https://updates.signal.org/desktop/signal-desktop-mac-universal-8.5.0.dmg";
      hash = "sha256-Qg1W8njo9DCkNgYOn9ju/wijR88n5V1EZ3Y8ynoCISw=";
    };
  };
}
