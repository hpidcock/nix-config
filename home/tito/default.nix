{ inputs, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = "aarch64-darwin";
    config = {
      allowUnfree = true;
    };
  };
in
inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = import inputs.nixpkgs {
    system = "aarch64-darwin";
    config = {
      allowUnfree = true;
    };
    overlays = [
      (inputs.private.sys.tito.home.overlay {
        inherit inputs;
        inherit pkgs-unstable;
      })
    ];
  };
  modules = [
    inputs.private.sys.tito.home.default
    inputs.mac-app-util.homeManagerModules.default
    ./home.nix
  ];
  extraSpecialArgs = {
    inherit inputs;
    inherit pkgs-unstable;
  };
}
