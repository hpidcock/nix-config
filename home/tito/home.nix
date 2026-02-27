{
  pkgs,
  ...
}:
{
  imports = [
    ../modules/base.nix
    ../modules/desktop.nix
  ];

  home.homeDirectory = "/Users/hpidcock";

  home.packages = [
    pkgs.zsh
    pkgs.git
    pkgs.gh
    pkgs.podman
    pkgs.librewolf
  ];

  programs.git = {
    settings.url = {
      "ssh://git@github.com/" = {
        insteadOf = "https://github.com/";
      };
    };
    extraConfig.safe.directory = "/etc/nixos";
  };

  home.stateVersion = "24.11";
}
