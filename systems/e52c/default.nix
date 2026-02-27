{ inputs, ... }:
inputs.nixpkgs-unstable.lib.nixosSystem {
  system = "aarch64-linux";
  modules = [
    ./configuration.nix
    ./bootloader.nix
  ];
  specialArgs = inputs;
}
