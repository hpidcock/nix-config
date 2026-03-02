{ lib, ... }:
{
  options.varying = {
    fontSize = lib.mkOption {
      type = lib.types.int;
      default = 18;
    };

    uiFontSize = lib.mkOption {
      type = lib.types.int;
      default = 18;
    };

    fontFamily = lib.mkOption {
      type = lib.types.str;
      default = "BlexMono Nerd Font";
    };

    terminalOpacity = lib.mkOption {
      type = lib.types.float;
      default = 0.85;
    };

    waybarFontSize = lib.mkOption {
      type = lib.types.int;
      default = 12;
    };

    waybarHeight = lib.mkOption {
      type = lib.types.int;
      default = 18;
    };

    cursorSize = lib.mkOption {
      type = lib.types.int;
      default = 32;
    };

    scale = lib.mkOption {
      type = lib.types.float;
      default = 1.0;
    };

    hasBattery = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
}
