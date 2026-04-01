{
  pkgs,
  ...
}:
let
  host = pkgs;
  target = pkgs.pkgsStatic;
in
target.mkShellNoCC {
  name = "juju-dev";

  stdenv = target.stdenv;

  propagatedBuildInputs = with target; [
    sqlite
    gcc
  ];

  packages =
    (with target; [
      musl
      gcc
      binutils
      go
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
    export GOFLAGS
    export CGO_LDFLAGS
    export GOFLAGS='"-ldflags=-extldflags=-static -linkmode=external"'
    export CGO_LDFLAGS="-L${target.musl}/lib"
    PTREE=$(pstree -p $PPID)
    if echo $PTREE | grep -o "direnv export"; then
      exit 0
    fi
    if [ -t 1 ]; then
       exec zsh
    fi
  '';
}
