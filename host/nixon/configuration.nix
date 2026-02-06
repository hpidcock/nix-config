{ lib, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_6_16;
    loader = {
      # Use the systemd-boot EFI boot loader.
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    binfmt = {
      emulatedSystems = [
        "aarch64-linux"
      ];
    };
  };

  time.timeZone = "Australia/Brisbane";
  i18n.defaultLocale = "en_AU.UTF-8";

  networking = {
    useDHCP = lib.mkDefault true;
    hostName = "nixon";
    networkmanager.enable = true;
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      publish.enable = true;
    };
    openssh.enable = true;
    tailscale.enable = true;
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    dbus = {
      enable = true;
      implementation = "broker";
    };
    greetd = {
      enable = true;
      restart = false;
      settings.default_session.command = ''
        ${lib.makeBinPath [ pkgs.greetd.tuigreet ]}/tuigreet \
          -r --asterisks --time --cmd sway-run
      '';
    };
  };

  security = {
    pam.services.swaylock = { };
    polkit.enable = true;
  };
  environment.systemPackages = with pkgs; [
    vim
    wget
    uutils-coreutils-noprefix
  ];
  virtualisation.podman = {
    enable = true;
  };
  virtualisation.docker = {
    enable = true;
  };

  users.users.hpidcock = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "render"
      "audio"
      "podman"
      "docker"
    ];
    packages = with pkgs; [ home-manager ];
    openssh.authorizedKeys.keys = [
      (lib.readFile ../../resources/ssh.pub)
    ];
  };
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  # DO NOT CHANGE.
  system.stateVersion = "24.11";
  nixpkgs.config.allowUnfree = true;
}
