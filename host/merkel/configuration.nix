{ lib, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_6_18;
    loader = {
      # Use the systemd-boot EFI boot loader.
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  time.timeZone = "Australia/Brisbane";
  i18n.defaultLocale = "en_AU.UTF-8";

  networking = {
    useDHCP = lib.mkDefault true;
    hostName = "merkel";
    networkmanager.enable = true;
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
      };
    };
    openssh.enable = true;
    tailscale.enable = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    uutils-coreutils-noprefix
  ];
  virtualisation.podman.enable = true;

  users.users.hpidcock = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
    packages = with pkgs; [ home-manager ];
    openssh.authorizedKeys.keys = [
      (lib.readFile ../../resources/ssh.pub)
    ];
    shell = pkgs.zsh;
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  # DO NOT CHANGE.
  system.stateVersion = "25.11";
  nixpkgs.config.allowUnfree = true;
}
