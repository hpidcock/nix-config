{ inputs, system, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit system;
  };
  pkgs-23-11 = import inputs.nixpkgs-23-11 {
    inherit system;
    config.allowUnfree = true;
  };
in
import ./shell.nix {
  pkgs = import inputs.nixpkgs {
    inherit system;
    overlays = [
      (final: prev: {
        go = pkgs-unstable.go;
        mongodb-4_4 = pkgs-23-11.mongodb-4_4;
      })
    ];
  };
}
