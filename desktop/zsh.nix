{
  pkgs,
  lib,
  ...
}: {
  programs.zsh = {
    enable = true;
    initContent = lib.mkBefore ''
      zvm_config() {
        ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLOCK
        ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_UNDERLINE
      }
      function modver() {
        TZ=UTC git --no-pager show --quiet --abbrev=12 \
        --date='format-local:%Y%m%d%H%M%S' \
        --format="%cd-%h"
      }
      alias modver=modver
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [ ];
      theme = "agnoster";
    };
    plugins = [
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];
  };
}
