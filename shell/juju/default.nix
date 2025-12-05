{ inputs, system, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit system;
    config = {
      allowUnfree = true;
    };
  };
  pkgs-23-11 = import inputs.nixpkgs-23-11 {
    inherit system;
    config = {
      allowUnfree = true;
    };
  };
  shellFile = if system == "aarch64-darwin" then ./shell-darwin.nix else ./shell.nix;
in
import shellFile {
  pkgs = import inputs.nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
    };
    overlays = [
      (final: prev: {
        go = pkgs-unstable.go;
        mongodb-4_4 = pkgs-23-11.mongodb-4_4;
      })
    ];
  };
}
