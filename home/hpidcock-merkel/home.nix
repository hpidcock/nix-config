{
  pkgs,
  ...
}:
{
  imports = [
    ../modules/base.nix
  ];

  age.identityPaths = [ "/home/hpidcock/.ssh/age" ];

  services.gpg-agent = {
    enable = false;
  };

  programs.git = {
    package = pkgs.gitFull;
    settings.url = {
      "ssh://git@github.com/" = {
        insteadOf = "https://github.com/";
      };
    };
  };

  home.stateVersion = "25.11";
}
