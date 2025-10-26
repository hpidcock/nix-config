{ inputs, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = "aarch64-darwin";
    config = {
      allowUnfree = true;
    };
    overlays = [
      (import ./overlays/signal.nix)
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
        zed-editor = pkgs-unstable.zed-editor;
        element-desktop = pkgs-unstable.element-desktop;
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
