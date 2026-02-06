{
  config,
  lib,
  pkgs,
  ...
}:
{
  system.build.installBootLoader = lib.mkForce (
    pkgs.writeShellScript "patch-bootloader.sh" ''
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -d /boot -c "$@"
      mkdir /boot/nx
      cp /boot/extlinux/extlinux.conf /boot/extlinux/extlinux.conf.tmp
      sed -i -e 's/boot\/nixos/boot\/nx/g' /boot/extlinux/extlinux.conf.tmp
      for ent in /boot/nixos/*; do
        name=$(basename $ent)
        nname=$(echo $name | awk -F- '{print $1 "-" $NF}')
        nent=/boot/nx/$nname
        cp -Rp $ent $nent
        sed -i -e "s|nixos/$name|nx/$nname|g" /boot/extlinux/extlinux.conf.tmp
      done
      mv /boot/extlinux/extlinux.conf.tmp /boot/extlinux/extlinux.conf
    ''
  );
}
