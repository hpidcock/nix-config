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
  };
}
