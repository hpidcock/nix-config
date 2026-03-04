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
      (inputs.private.sys.eisenhower.home.overlay {
        inherit inputs;
        inherit pkgs-unstable;
      })
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
            postPatch = ''
              # Dynamically link WebRTC instead of static
              substituteInPlace $cargoDepsCopy/*/webrtc-sys-*/build.rs \
                  --replace-fail "cargo:rustc-link-lib=static=webrtc" "cargo:rustc-link-lib=dylib=webrtc"
            
              # The generate-licenses script wants a specific version of cargo-about eventhough
              # newer versions work just as well.
              substituteInPlace script/generate-licenses \
                  --replace-fail '$CARGO_ABOUT_VERSION' '${pkgs-unstable.cargo-about.version}'
            '';
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
        signal-desktop = super.symlinkJoin {
          name = "signal-desktop";
          paths = [ super.signal-desktop ];
          buildInputs = [ super.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/signal-desktop --add-flag '--password-store=gnome-libsecret'
           '';
        };
        ollama-vulkan = pkgs-unstable.ollama-vulkan;
        ollama = pkgs-unstable.ollama;
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
