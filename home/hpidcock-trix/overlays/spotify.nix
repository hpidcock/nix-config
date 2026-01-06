final: prev: {
  spotify = prev.spotify.overrideAttrs {
    version = "1.2.78.418";
    src = prev.fetchurl {
      url = "https://download.scdn.co/SpotifyARM64.dmg";
      hash = "sha256-/rrThZOpjzaHPX1raDe5X8PqtJeTI4GDS5sXSfthXTQ=";
    };
  };
}
