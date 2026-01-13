{ inputs, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
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
      permittedInsecurePackages = [
        "openssl-1.1.1w"
      ];
    };
    overlays = [
      (self: super: {
        swaylock = super.callPackage ../../pkgs/host-sway-lock { };
        minikube = pkgs-unstable.minikube;
        zed-editor = pkgs-unstable.zed-editor;
        ollama-rocm = pkgs-unstable.ollama-rocm;
        ollama = pkgs-unstable.ollama;
      })
    ];
  };
  modules = [ ./home.nix ];
  extraSpecialArgs = {
    inherit inputs;
  };
}
