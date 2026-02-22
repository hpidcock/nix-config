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
        zed-editor = pkgs-unstable.zed-editor.overrideAttrs (
          final: prev: {
            version = "0.225.0";
            src = super.fetchFromGitHub {
              owner = "zed-industries";
              repo = "zed";
              rev = "9e0c5f42a9d41a1a47f168f9dc7403b4bc8b320f";
              hash = "sha256-JhdtzUa9s5C8CeEFH8Z3SOhR6i0JfXfceg6PPuzOqMY=";
            };
            postPatch = builtins.replaceStrings [ prev.version ] [ final.version ] prev.postPatch;
            cargoDeps =
              super.callPackage "${inputs.nixpkgs-staging}/pkgs/build-support/rust/fetch-cargo-vendor.nix"
                { inherit (super) cargo; }
                {
                  inherit (final)
                    pname
                    version
                    src
                    ;
                  hash = "sha256-K1ZVlPWD+yysL17pMMYNxJxcHDGHms8XlNm8iIhXc5k=";
                  postBuild = ''
                    rm -r $out/git/*/candle-book/
                  '';
                };
            env = prev.env // {
              RELEASE_VERSION = final.version;
            };
          }
        );
        ollama-vulkan = pkgs-unstable.ollama-vulkan;
        ollama = pkgs-unstable.ollama;
      })
    ];
  };
  modules = [ ./home.nix ];
  extraSpecialArgs = {
    inherit inputs;
  };
}
