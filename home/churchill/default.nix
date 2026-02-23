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
        "olm-3.2.16"
      ];
    };
    overlays = [
      (self: super: {
        swaylock = super.callPackage ../../pkgs/host-sway-lock { };
        minikube = pkgs-unstable.minikube;
        ollama-vulkan = pkgs-unstable.ollama-vulkan;
        ollama = pkgs-unstable.ollama;
      })
    ];
  };
  modules = [
    inputs.private.sys.churchill.home.default
    ./home.nix
  ];
  extraSpecialArgs = {
    inherit inputs;
  };
}
