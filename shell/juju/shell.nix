{
  pkgs,
  ...
}:
let
  host = pkgs;
  target = pkgs.pkgsStatic;
in
target.mkShell {
  name = "juju-dev";

  stdenv = target.stdenv;

  propagatedBuildInputs = with target; [
    sqlite
  ];

  packages =
    (with target; [
      musl
      binutils
      go
      gopls
      golangci-lint
    ])
    ++ (with host; [
      bash.out
      expect.out
      gh.out
      gnumake.out
      jq.out
      shellcheck.out
      shfmt.out
      yq-go.out
      pstree.out
      vault.out
      (writeScriptBin "mongod" (builtins.readFile ../../resources/mongod.sh))
    ]);

  shellHook = ''
    export CGO_CFLAGS
    export CGO_CFLAGS="-static"
    export CGO_LDFLAGS
    export CGO_LDFLAGS="-static -L${target.sqlite.out}/lib -L${target.musl}/lib"
    export REALGCC="${target.gcc.out}/bin/gcc"
    PTREE=$(pstree -p $PPID)
    if echo $PTREE | grep -o "direnv export"; then
      exit 0
    fi
    if [ -t 1 ]; then
       exec zsh
    fi
  '';
}
