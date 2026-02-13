{ inputs, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = "x86_64-linux";
    config = {
      allowUnfree = true;
    };
  };
  pkgs-fixrust = import inputs.nixpkgs-fixrust {
    system = "x86_64-linux";
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
            version = "0.223.3-pre";
            src = super.fetchFromGitHub {
              owner = "zed-industries";
              repo = "zed";
              rev = "d7129634eed30ec5a4140686e3f2885f77c39af0";
              hash = "sha256-as9XE0uxPW1nRqK/71Wqf7/wPigubhyZpgzC7rEgVUo=
";
            };
            postPatch = builtins.replaceStrings [ prev.version ] [ final.version ] prev.postPatch;
            cargoDeps = pkgs-fixrust.rustPlatform.fetchCargoVendor {
              inherit (final)
                pname
                version
                src
                ;
              hash = "sha256-QWxzsCiwBWXdDXjTPKDuVH+xRzaeu5P+av+RQiMzaV4=";
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
