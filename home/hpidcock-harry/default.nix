{ inputs, ... }:
let
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
in
inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = import inputs.nixpkgs {
    system = "x86_64-linux";
    config = {
      allowUnfree = true;
    };
    overlays = [
      (self: super: {
        swaylock = super.callPackage ../../pkgs/host-sway-lock { };
        juju-dev-shell = super.callPackage ../../pkgs/juju-dev-shell {
          inherit pkgs-23-11 pkgs-unstable;
        };
        minikube = pkgs-unstable.minikube;
      })
    ];
  };
  modules = [ ./home.nix ];
  extraSpecialArgs = {
    inherit inputs;
  };
}
