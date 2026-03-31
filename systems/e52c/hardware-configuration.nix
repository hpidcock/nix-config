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
      "dtb=/${config.hardware.deviceTree.name}"
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
      "btrfs"
      "reiserfs"
      "vfat"
      "f2fs"
      "xfs"
      "ntfs"
      "cifs"
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
        "rockchip_rga"
        "rockchip_saradc"
        "rockchip_thermal"
        "rockchipdrm"
        "cw2015_battery"
        "gpio_charger"
        "rtc_rk808"
      ];
    };
    kernelModules = [ ];
    extraModulePackages = [ ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible = {
        enable = true;
      };
      systemd-boot.extraFiles.${config.hardware.deviceTree.name} =
        "${config.hardware.deviceTree.package}/${config.hardware.deviceTree.name}";
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
