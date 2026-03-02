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
    };
    overlays = [
      (inputs.private.sys.holt.home.overlay {
        inherit inputs;
        inherit pkgs-unstable;
      })
      (self: super: {
        minikube = pkgs-unstable.minikube;
        zed-editor = pkgs-unstable.zed-editor;
      })
    ];
  };
  modules = [
    inputs.private.sys.holt.home.default
    ./home.nix
  ];
  extraSpecialArgs = {
    inherit inputs;
  };
}
