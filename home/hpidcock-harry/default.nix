{ inputs, ... }:
inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = import inputs.nixpkgs {
    system = "x86_64-linux";
    config = {
      allowUnfree = true;
    };
  };
  modules = [ ./home.nix ];
  extraSpecialArgs = { inherit inputs; };
}
