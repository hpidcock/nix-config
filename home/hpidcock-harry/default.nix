{ inputs, ... }:
inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = import inputs.nixpkgs {
    system = "x86_64-linux";
    config = {
      allowUnfree = true;
    };
    overlays = [
      (self: super: {
        swaylock = super.callPackage ../../pkgs/host-sway-lock { };
      })
    ];
  };
  modules = [ ./home.nix ];
  extraSpecialArgs = {
    inherit inputs;
    pkgs-unstable = import inputs.nixpkgs-unstable {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
      };
    };
    pkgs-23-11 = import inputs.nixpkgs-23-11 {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
      };
    };
  };
}
