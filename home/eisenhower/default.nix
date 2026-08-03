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
        "pnpm-10.29.2"
      ];
    };
    overlays = [
      (inputs.private.sys.eisenhower.home.overlay {
        inherit inputs;
        inherit pkgs-unstable;
      })
      (self: super: {
        swaylock = super.callPackage ../../pkgs/host-sway-lock { };
        minikube = pkgs-unstable.minikube;
        zed-editor = pkgs-unstable.zed-editor.overrideAttrs (
          final: prev: {
            version = "1.3.6";
            src = pkgs-unstable.fetchFromGitHub {
              owner = "zed-industries";
              repo = "zed";
              rev = "4ce18741ad2ea007cb20a1dd96d2a170d224cc01";
              hash = "sha256-GUjKj2p1EP9Sn2eihF745JzKH2t01h7JH4HyAyiJfDI=";
            };
            postPatch = builtins.replaceStrings [ prev.version ] [ final.version ] prev.postPatch;
            cargoDeps =
              pkgs-unstable.callPackage
                "${inputs.nixpkgs-unstable}/pkgs/build-support/rust/fetch-cargo-vendor.nix"
                { inherit (pkgs-unstable) cargo; }
                {
                  inherit (final)
                    pname
                    version
                    src
                    ;
                  hash = "sha256-OptshSughuv3ZRtM+7syxagtZSdvsUjHuYSKEHvYIWc=";
                  postBuild = ''
                    rm -r $out/git/*/candle-book/
                  '';
                };
            env = prev.env // {
              RELEASE_VERSION = final.version;
            };
          }
        );
        signal-desktop = super.symlinkJoin {
          name = "signal-desktop";
          paths = [ super.signal-desktop ];
          buildInputs = [ super.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/signal-desktop --add-flag '--password-store=gnome-libsecret'
          '';
        };
        ollama-vulkan = pkgs-unstable.ollama-vulkan;
        ollama-rocm = pkgs-unstable.ollama-rocm;
        ollama = pkgs-unstable.ollama;
        llama-cpp-rocm = pkgs-unstable.llama-cpp-rocm;
      })
    ];
  };
  modules = [
    inputs.private.sys.eisenhower.home.default
    ./home.nix
  ];
  extraSpecialArgs = {
    inherit inputs;
  };
}
