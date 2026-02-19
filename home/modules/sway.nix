{ pkgs, ... }:
{
  imports = [
    ../../desktop/sway.nix
  ];

  services.gpg-agent.pinentry.package = pkgs.pinentry-rofi;

  home.packages = [
    pkgs.pinentry-rofi
  ];
}
