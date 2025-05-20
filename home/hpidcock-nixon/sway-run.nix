{ pkgs, ... }:
let
  runscript = pkgs.writeShellScriptBin "sway-run" ''
    export XDG_SESSION_TYPE="wayland"
    export XDG_SESSION_DESKTOP="sway"
    export XDG_CURRENT_DESKTOP="sway"

    systemd-run --user --scope --collect --quiet --unit="sway" \
        systemd-cat --identifier="sway" ${pkgs.sway}/bin/sway $@

    exec ${pkgs.sway}/bin/swaymsg exit
  '';
in
pkgs.symlinkJoin {
  name = "sway-run";
  paths = [ runscript ];
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = "wrapProgram $out/bin/sway-run --prefix PATH : $out/bin";
}
