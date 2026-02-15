{ inputs, ... }:
inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = import inputs.nixpkgs {
    system = "x86_64-linux";
    config = {
      allowUnfree = true;
    };
    overlays = [ ];
  };
  modules = [
    inputs.nix-secrets.homeManagerModules.default
    ./home.nix
  ];
  extraSpecialArgs = {
    inherit inputs;
  };
}
