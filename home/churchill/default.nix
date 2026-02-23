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
        libinput = super.libinput.overrideAttrs (
          final: prev: {
            version = "1.31.0";
            src = super.fetchFromGitLab {
              domain = "gitlab.freedesktop.org";
              owner = "libinput";
              repo = "libinput";
              rev = final.version;
              hash = "sha256-sDe8BxR3E5CQj/RjuFWW2XSWb8tu98dtDuBSpACYkvY=";
            };
          }
        );
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
