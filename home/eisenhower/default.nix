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
        zed-editor = pkgs-unstable.zed-editor;
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
