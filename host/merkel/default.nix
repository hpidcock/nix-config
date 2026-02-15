{ inputs, ... }:
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    inputs.nix-secrets.nixosModules.default
    ./configuration.nix
  ];
  specialArgs = inputs;
}
