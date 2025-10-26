{
  pkgs,
  ...
}:
pkgs.mkShellNoCC {
  name = "juju-dev";

  packages = with pkgs; [
    go
    pkgsStatic.sqlite
    pkgsStatic.musl
    pkgsStatic.gcc
    pkgsStatic.binutils
    bash.out
    expect.out
    gh.out
    gnumake.out
    jq.out
    shellcheck.out
    shfmt.out
    yq-go.out
    zsh.out
  ];

  shellHook = ''
    export GOFLAGS
    export GOFLAGS='-ldflags=-linkmode=external -ldflags=-extldflags=-static'
    exec ${pkgs.zsh}/bin/zsh $@
  '';
}
