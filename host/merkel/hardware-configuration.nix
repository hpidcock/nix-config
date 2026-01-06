{
  lib,
  modulesPath,
  config,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "ahci"
        "nvme"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/c0f9e10a-9cdb-4406-8362-e077bb8bf01e";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/55F6-37AD";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
  };
  swapDevices = [
    { device = "/dev/disk/by-uuid/a505d1f1-3757-4ed9-924f-a37bbdc4ba5d"; }
  ];

  hardware = {
    cpu.intel = {
      updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
  };
}
