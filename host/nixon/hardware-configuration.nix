{
  inputs,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "ahci"
        "usbhid"
      ];
      kernelModules = [ ];
    };
    kernelModules = [
      "amdgpu"
      "kvm-amd"
    ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/33f46b78-7bc3-4ebd-9a64-71f34c70f0d7";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/17B2-3416";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };
  swapDevices = [ ];

  hardware = {
    cpu.amd = with inputs.config.hardware; {
      updateMicrocode = lib.mkDefault enableRedistributableFirmware;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        amdvlk
      ];
    };
    amdgpu.amdvlk = {
      enable = true;
      support32Bit.enable = true;
    };
  };
}
