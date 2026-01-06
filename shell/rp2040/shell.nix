{
  pkgs,
  ...
}:
pkgs.mkShellNoCC {
  name = "rp2040-dev";

  packages = with pkgs; [
    rustup
    clang
    libz
    openssl
    pkg-config
    libiconv
    picotool.out
    bash.out
    gh.out
    pstree.out
    tio.out
  ];

  shellHook = ''
    export PATH
    export PATH="$HOME/.cargo/bin:$PATH"
    PTREE=$(pstree -p $PPID)
    if echo $PTREE | grep -o "direnv export"; then
      exit 0
    fi
    if [ -t 1 ]; then
       exec zsh
    fi
  '';
}
