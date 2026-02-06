{ lib, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_6_17;
    kernelPatches = [
      {
        name = "rk3588s";
        patch = null;
        structuredExtraConfig.EFI_ZBOOT = lib.mkForce lib.kernel.no;
        structuredExtraConfig.KERNEL_ZSTD = lib.mkForce lib.kernel.unset;
      }
    ];
  };

  time.timeZone = "Australia/Brisbane";
  i18n.defaultLocale = "en_AU.UTF-8";

  networking = {
    useDHCP = lib.mkDefault true;
    hostName = "e52c";
    networkmanager.enable = true;
  };

  services = {
    openssh.enable = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    uutils-coreutils-noprefix
  ];

  users.users.hpidcock = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
    packages = with pkgs; [ home-manager ];
    openssh.authorizedKeys.keys = [
      (lib.readFile ../../resources/ssh.pub)
    ];
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  # DO NOT CHANGE.
  system.stateVersion = "24.11";
}
