{ inputs, ... }:
let
  pkgsHost = import inputs.nixpkgs-unstable {
    system = "x86_64-linux";
  };
  pkgsCross = import inputs.nixpkgs-unstable {
    crossSystem = "aarch64-linux";
    config = {
      allowUnfree = true;
    };
  };
  pkgs = import inputs.nixpkgs-unstable {
    system = "aarch64-linux";
    overlays = [
      (final: prev: {
        qemu_kvm = pkgsHost.qemu;
        lkl = pkgsHost.lkl;
        linuxPackages_latest = pkgsCross.linuxPackages_latest;
      })
    ];
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
