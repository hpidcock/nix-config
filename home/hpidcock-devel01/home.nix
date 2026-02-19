{
  pkgs,
  ...
}:
{
  imports = [
    ../modules/base.nix
    ../modules/development.nix
  ];

  services.gpg-agent = {
    enable = false;
  };

  home.packages = [
    pkgs.esphome
  ];

  programs.git = {
    package = pkgs.gitFull;
    settings.url = {
      "ssh://git@github.com/" = {
        insteadOf = "https://github.com/";
      };
    };
  };

  home.stateVersion = "25.05";
}
