{ inputs, system, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit system;
    config = {
      allowUnfree = true;
    };
  };
in
import ./shell.nix {
  pkgs = import inputs.nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
    };
    overlays = [
      (final: prev: {
        go = pkgs-unstable.go;
      })
    ];
  };
}
