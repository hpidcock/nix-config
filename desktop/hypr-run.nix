{ pkgs, ... }:
let
  runscript = pkgs.writeShellScriptBin "hypr-run" ''
    export XDG_SESSION_TYPE="wayland"
    export XDG_SESSION_DESKTOP="hyprland"
    export XDG_CURRENT_DESKTOP="hyprland"
    systemd-run --user --scope --collect --quiet --unit="hyprland" systemd-cat\
      --identifier="hyprland" ${pkgs.hyprland}/bin/Hyprland $@
    exec ${pkgs.hyprland}/bin/Hyprland --exit
  '';
in
pkgs.symlinkJoin {
  name = "hypr-run";
  paths = [ runscript ];
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = "wrapProgram $out/bin/hypr-run --prefix PATH : $out/bin";
}
