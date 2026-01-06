{ inputs, system, ... }:
let
  shellFile = ./shell.nix;
in
import shellFile {
  pkgs = import inputs.nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
    };
  };
}
