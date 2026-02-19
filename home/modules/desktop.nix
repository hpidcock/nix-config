{ pkgs, ... }:
{
  imports = [
    ../../desktop/alacritty.nix
    ../../desktop/zed.nix
  ];

  fonts.fontconfig = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };
}
