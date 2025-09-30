{
  pkgs,
  pkgs-23-11,
  pkgs-unstable,
  lib,
  ...
}:
let
  packages = with pkgs; [
    zsh
    pkgs-unstable.go
    yq-go
    jq
    gnumake
    gccStdenv
    gcc
    pkg-config
    bzip2
    shellcheck
    expect
    azure-cli
    shfmt
    graphviz
    python312
    #snapcraft
    #rockcraft
    #charmcraft
    pkgs-23-11.mongodb-4_4
  ];
  libs = with pkgs; [
    sqlite
    libxcrypt
  ];
  devPackages = map (lib.getOutput "dev") libs;
  libPackages = map (lib.getOutput "lib") libs;
in
pkgs.runCommand "jdev"
  {
    buildInputs = packages;
    nativeBuildInputs = [ pkgs.makeWrapper ];
  }
  ''
    for path in ${
      builtins.concatStringsSep " " (
        builtins.foldl' (
          paths: pkg:
          paths
          ++ (map (directory: "'${pkg}/${directory}/pkgconfig'") [
            "lib"
            "share"
          ])
        ) [ ] devPackages
      )
    }; do
      addToSearchPath JDEV_PKG_CONFIG_PATH "$path"
    done

    mkdir -p $out/bin/
    ln -s ${pkgs.zsh}/bin/zsh $out/bin/jdev
    wrapProgram $out/bin/jdev \
      --prefix PATH : ${pkgs.lib.makeBinPath packages} \
      --suffix PKG_CONFIG_PATH : "$JDEV_PKG_CONFIG_PATH" \
      --suffix CGO_CFLAGS " " "${
        builtins.concatStringsSep " " (map (pkg: "-I${pkg}/include") devPackages)
      }" \
      --suffix CGO_LDFLAGS " " "${
        builtins.concatStringsSep " " (map (pkg: "-L${pkg}/lib") libPackages)
      }"

  ''
