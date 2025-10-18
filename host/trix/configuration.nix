{
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:

{

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.enable = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  time.timeZone = "Australia/Brisbane";

  networking = {
    hostName = "trix";
    localHostName = "trix";
  };

  services.tailscale.enable = true;
  programs._1password = {
    enable = true;
    package = pkgs-unstable._1password-cli;
  };
  programs._1password-gui = {
    enable = true;
    package = pkgs-unstable._1password-gui;
  };

  users.users.hpidcock = {
    packages = with pkgs; [ home-manager ];
    openssh.authorizedKeys.keys = [
      (lib.readFile ../../resources/ssh.pub)
    ];
  };

  # This option defines the first version of nix-darwin you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older nix-darwin versions.
  # DO NOT CHANGE.
  system.stateVersion = 6;
  nixpkgs.config.allowUnfree = true;
}
