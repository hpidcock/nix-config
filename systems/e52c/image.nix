{ inputs, ... }:
let
  pkgs = import inputs.nixpkgs-unstable {
    system = "aarch64-linux";
    config = {
      allowUnfree = true;
    };
  };
  sys = inputs.nixpkgs-unstable.lib.nixosSystem {
    system = "aarch64-linux";
    modules = [
      ./configuration.nix
      ./bootloader.nix
      ./image-build.nix
    ];
    pkgs = pkgs;
    specialArgs = inputs;
  };
in
sys.config.system.build.raw
