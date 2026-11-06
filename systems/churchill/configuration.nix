{
  pkgs,
  ...
}:
let
  system = "x86_64-linux";
in
{
  config = {
    nixpkgs.hostPlatform = system;
    nixpkgs.config.allowUnfree = true;
    system-manager.allowAnyDistro = true;
    system-graphics.enable = true;
    environment.systemPackages = [
      pkgs.vim
      pkgs.home-manager
    ];

    # Keep running with the lid closed while on AC power.
    environment.etc."systemd/logind.conf.d/10-lid.conf".text = ''
      [Login]
      HandleLidSwitchExternalPower=ignore
    '';
  };
}
