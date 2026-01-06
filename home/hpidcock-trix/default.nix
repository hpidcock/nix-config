{ inputs, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = "aarch64-darwin";
    config = {
      allowUnfree = true;
    };
    overlays = [
      (import ./overlays/signal.nix)
      (import ./overlays/spotify.nix)
    ];
  };
in
inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = import inputs.nixpkgs {
    system = "aarch64-darwin";
    config = {
      allowUnfree = true;
    };
    overlays = [
      (final: prev: {
        signal-desktop-bin = pkgs-unstable.signal-desktop-bin;
        spotify = pkgs-unstable.spotify;
        esphome = pkgs-unstable.esphome;
      })
    ];
  };
  modules = [
    inputs.mac-app-util.homeManagerModules.default
    ./home.nix
  ];
  extraSpecialArgs = {
    inherit inputs;
  };
}
