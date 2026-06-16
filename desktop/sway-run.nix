{ pkgs, ... }:
pkgs.writeShellScriptBin "sway-run" ''
  # Source the nix profile script so that PATH, XDG_DATA_DIRS, etc. are set
  # the same as in a login shell. This is needed when sway is launched from a
  # display manager that does not run the user's shell profile scripts.
  if [ -f "/nix/var/nix/profiles/default/etc/profile.d/nix.sh" ]; then
    . "/nix/var/nix/profiles/default/etc/profile.d/nix.sh"
  fi
  if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
    . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
  fi

  export XDG_SESSION_TYPE="wayland"
  export XDG_SESSION_DESKTOP="sway"
  export XDG_CURRENT_DESKTOP="sway"
  exec ${pkgs.systemd}/bin/systemd-run \
    --user --scope --collect --quiet --unit="sway" \
    ${pkgs.systemd}/bin/systemd-cat \
    --identifier="sway" \
    ${pkgs.sway}/bin/sway "$@"
''
