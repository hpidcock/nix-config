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
    pstree.out
  ];

  shellHook = ''
    export GOFLAGS
    export GOFLAGS='-ldflags=-linkmode=external -ldflags=-extldflags=-static'
    PTREE=$(pstree -p $PPID)
    if echo $PTREE | grep -o "direnv export"; then
       exec bash
    fi
    if [ -t 1 ]; then
       exec zsh
    fi
  '';
}
