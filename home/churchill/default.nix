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
        swayosd = pkgs-unstable.swayosd;
        minikube = pkgs-unstable.minikube;
        ollama-vulkan = pkgs-unstable.ollama-vulkan;
        ollama = pkgs-unstable.ollama;
        zed-editor = pkgs-unstable.zed-editor;
        sway-unwrapped = pkgs-unstable.sway-unwrapped.overrideAttrs (
          final: prev: {
            version = "1.12-rc3";
            src = super.fetchFromGitHub {
              owner = "swaywm";
              repo = "sway";
              rev = final.version;
              hash = "sha256-SuVEUxz/PN9kJV4GG4bW4BojY6KEoW0qf3UF93AxCDI=";
            };
            buildInputs = with pkgs-unstable; [
              libGL
              wayland
              libxkbcommon
              pcre2
              json_c
              libevdev
              pango
              cairo
              self.libinput
              gdk-pixbuf
              librsvg
              wayland-protocols
              libdrm
              (wlroots_0_20.override { enableXWayland = true; })
              libxcb-wm
            ];
          }
        );
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
