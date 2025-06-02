{
  system-manager,
  pkgs,
  ...
}:
let
  system = "x86_64-linux";
in
{
  config = {
    nixpkgs.hostPlatform = system;
    system-manager.allowAnyDistro = true;
    system-graphics.enable = true;
    environment.systemPackages = [
      pkgs.vim
      system-manager.packages.${system}.default
    ];
  };
}
