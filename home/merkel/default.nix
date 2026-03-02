{ inputs, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = "x86_64-linux";
    config = {
      allowUnfree = true;
    };
  };
in
inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = import inputs.nixpkgs {
    system = "x86_64-linux";
    config = {
      allowUnfree = true;
    };
    overlays = [
      (inputs.private.sys.merkel.home.overlay {
        inherit inputs;
        inherit pkgs-unstable;
      })
    ];
  };
  modules = [
    inputs.private.sys.merkel.home.default
    inputs.secrets.homeManagerModules.default
    ./home.nix
  ];
  extraSpecialArgs = {
    inherit inputs;
  };
}
