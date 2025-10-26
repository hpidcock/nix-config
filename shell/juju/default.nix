{ inputs, system, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit system;
  };
in
import ./shell.nix {
  pkgs = import inputs.nixpkgs {
    inherit system;
    overlays = [
      (final: prev: {
        go = pkgs-unstable.go;
      })
    ];
  };
}
