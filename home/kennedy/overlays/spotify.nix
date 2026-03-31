final: prev: {
  spotify = prev.spotify.overrideAttrs {
    version = "1.2.86.502";
    src = prev.fetchurl {
      url = "https://download.scdn.co/SpotifyARM64.dmg";
      hash = "sha256-04VhZ8XUpJIg5Kv/Q18s0cE/nV1tO03XlwQHwmBBT0g=";
    };
  };
}
