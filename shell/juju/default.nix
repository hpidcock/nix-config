{ inputs, system, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit system;
  };
  pkgs-23-11 = import inputs.nixpkgs-23-11 {
    inherit system;
  };
in
import ./shell.nix {
  pkgs = import inputs.nixpkgs {
    inherit system;
    overlays = [
      (final: prev: {
        signal-desktop-bin = pkgs-unstable.signal-desktop-bin;
        zed-editor = pkgs-unstable.zed-editor;
        element-desktop = pkgs-unstable.element-desktop;
      })
    ];
  };
}
