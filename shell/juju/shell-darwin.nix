{
  pkgs,
  ...
}:
pkgs.mkShellNoCC {
  name = "juju-dev";

  packages = with pkgs; [
    go
    sqlite
    gcc
    binutils
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
    PTREE=$(pstree -p $PPID)
    if echo $PTREE | grep -o "direnv export"; then
      exit 0
    fi
    if [ -t 1 ]; then
       exec zsh
    fi
  '';
}
