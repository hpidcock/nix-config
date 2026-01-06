final: prev: {
  signal-desktop-bin = prev.signal-desktop-bin.overrideAttrs {
    version = "7.82.0";
    src = prev.fetchurl {
      url = "https://updates.signal.org/desktop/signal-desktop-mac-universal-7.82.0.dmg";
      hash = "sha256-MGzmaodX+9co2AEN7qnTDq0ACKnURrMDluwtyTsTSwY=";
    };
  };
}
