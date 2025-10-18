{ inputs, ... }:
inputs.nix-darwin.lib.darwinSystem {
  modules = [ ./configuration.nix ];
  specialArgs = {
    inherit inputs;
    pkgs-unstable = import inputs.nixpkgs-unstable {
      system = "aarch64-darwin";
      config = {
        allowUnfree = true;
      };
    };
  };
}
