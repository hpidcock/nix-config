{
  lib,
  pkgs,
  config,
  nixpkgs-unstable,
  ...
}:
let
  raw = import "${nixpkgs-unstable}/nixos/lib/make-disk-image.nix" {
    inherit lib config pkgs;
    diskSize = "auto";
    format = "raw";
    memSize = 8192;
    label = "nixos";
    copyChannel = false;
    rootFSUID = "6754af3c-c678-4472-a4a8-820e733fbeb8";
  };
  uboot = pkgs.buildUBoot {
    defconfig = "rock-5c-rk3588s_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    BL31 = "${pkgs.armTrustedFirmwareRK3588}/bl31.elf";
    ROCKCHIP_TPL = pkgs.rkbin.TPL_RK3588;
    filesToInstall = [
      "u-boot.itb"
      "idbloader.img"
      "u-boot-rockchip.bin"
    ];
  };
in
{
  system.build.raw = pkgs.runCommand "image" { buildInputs = [ raw ]; } ''
    mkdir $out
    ${pkgs.parted}/bin/parted -j --script ${raw.out}/nixos.img unit s print
    rootStart=$(${pkgs.parted}/bin/parted -j --script ${raw.out}/nixos.img unit s print | ${pkgs.jq}/bin/jq -r '.disk.partitions.[] | select(.number == 1) | .start' | cut -d's' -f1)
    rootSize=$(${pkgs.parted}/bin/parted -j --script ${raw.out}/nixos.img unit s print | ${pkgs.jq}/bin/jq -r '.disk.partitions.[] | select(.number == 1) | .size' | cut -d's' -f1)
    outputSize=$((32768 + rootSize + 4096))
    rootEnd=$((32768 + rootSize - 1))
    echo "rootStart=$rootStart rootSize=$rootSize outputSize=$outputSize"
    dd if=/dev/zero of=$out/nixos.img count=$outputSize bs=512
    ${pkgs.parted}/bin/parted --script $out/nixos.img \
      mklabel gpt \
      mkpart nixos ext4 32768s ''${rootEnd}s \
      type 1 C12A7328-F81F-11D2-BA4B-00A0C93EC93B
    dd if=${raw}/nixos.img of=$out/nixos.img ibs=512 iseek=$rootStart seek=32768 count=$rootSize conv=notrunc


    dd if=${uboot.out}/idbloader.img of=$out/nixos.img seek=64 conv=notrunc
    dd if=${uboot.out}/u-boot.itb of=$out/nixos.img seek=16384 conv=notrunc
  '';
}
