{ pkgs, ... }:
let
  bin = pkgs.writeShellScriptBin "swaylock" ''
    exec /usr/bin/swaylock "$@"
  '';
in
pkgs.symlinkJoin {
  name = "swaylock";
  paths = [ bin ];
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = "wrapProgram $out/bin/swaylock --prefix PATH : $out/bin";
}
