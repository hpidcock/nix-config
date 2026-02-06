{
  lib,
  pkgs,
  modulesPath,
  config,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  boot = {
    kernelParams = [
      "root=UUID=6754af3c-c678-4472-a4a8-820e733fbeb8"
      "rootfstype=ext4"
      "console=ttyFIQ0,1500000n8"
      "splash"
      "loglevel=7"
      "rw"
      "earlycon"
      "consoleblank=0"
      "console=tty1"
      "coherent_pool=2M"
      "irqchip.gicv3_pseudo_nmi=0"
      "cgroup_enable=cpuset"
      "cgroup_memory=1"
      "cgroup_enable=memory"
      "swapaccount=1"
      "single"
    ];
    supportedFilesystems = [
      "vfat"
      "fat32"
      "exfat"
      "ext4"
    ];
    initrd = {
      includeDefaultModules = false;
      availableKernelModules = [
        "usbhid"
        "dm_mod"
        "dm_crypt"
        "input_leds"
      ];
      kernelModules = [
        "mmc_block"
        "ext4"
      ];
    };
    kernelModules = [ ];
    extraModulePackages = [ ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible = {
        enable = true;
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      label = "nixos";
      autoResize = true;
    };
  };

  hardware = {
    enableRedistributableFirmware = lib.mkForce true;
    deviceTree = {
      enable = true;
      name = "rockchip/rk3582-radxa-e52c.dtb";
    };
    firmware = [ ];
  };
}
