final: prev: {
  signal-desktop-bin = prev.signal-desktop-bin.overrideAttrs {
    version = "7.75.1";
    src = prev.fetchurl {
      url = "https://updates.signal.org/desktop/signal-desktop-mac-universal-7.75.1.dmg";
      hash = "sha256-6sFPKHw+ggfWpb1NHn80Gd/L3wdMQfg8/efcNZ6WhWU=";
    };
  };
}
