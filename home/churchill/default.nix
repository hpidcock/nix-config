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
      (inputs.private.sys.churchill.home.overlay {
        inherit inputs;
        inherit pkgs-unstable;
      })
      (self: super: {
        swaylock = super.callPackage ../../pkgs/host-sway-lock { };
        minikube = pkgs-unstable.minikube;
        ollama-vulkan = pkgs-unstable.ollama-vulkan.overrideAttrs (
          final: prev: {
            version = "0.17.7";
            src = super.fetchFromGitHub {
              owner = "ollama";
              repo = "ollama";
              tag = "v${final.version}";
              hash = "sha256-cAqc38NHvUo5gphq1csTyosTcpUjFcs0dzB0wreEGjs=";
            };
            vendorHash = "sha256-Lc1Ktdqtv2VhJQssk8K1UOimeEjVNvDWePE9WkamCos=";
          }
        );
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
            patches = [ ];
            buildInputs = prev.buildInputs ++ [ super.lua5_4_compat ];
          }
        );
        wlroots_0_19 = super.wlroots_0_19.overrideAttrs (
          final: prev: {
            version = "0.19.2";
            src = super.fetchFromGitHub {
              owner = "hpidcock";
              repo = "wlroots";
              rev = "patched-0.19";
              hash = "sha256-lw1ACzE1wPAzIfbdv5Cc3NyvCdFXBM+HJtcKI7bAgyw=";
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
