{ inputs, ... }:
inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = import inputs.nixpkgs {
    system = "aarch64-darwin";
    config = {
      allowUnfree = true;
    };
  };
  modules = [ ./home.nix ];
  extraSpecialArgs = { inherit inputs; };
}
