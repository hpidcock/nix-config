{ inputs, ... }:
inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = import inputs.nixpkgs {
    system = "aarch64-darwin";
    config = {
      allowUnfree = true;
    };
  };
  modules = [
    inputs.mac-app-util.homeManagerModules.default
    ./home.nix
  ];
  extraSpecialArgs = {
    inherit inputs;
    pkgs-unstable = import inputs.nixpkgs-unstable {
      system = "aarch64-darwin";
      config = {
        allowUnfree = true;
      };
    };
  };
}
