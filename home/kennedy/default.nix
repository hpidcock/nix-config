{ inputs, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = "aarch64-darwin";
    config = {
      allowUnfree = true;
    };
  };
in
inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = import inputs.nixpkgs {
    system = "aarch64-darwin";
    config = {
      allowUnfree = true;
    };
    overlays = [
      (inputs.private.sys.kennedy.home.overlay {
        inherit inputs;
        inherit pkgs-unstable;
      })
      #(import ./overlays/signal.nix)
      (import ./overlays/spotify.nix)
      (self: super: {
        inetutils = null;
        zed-editor = pkgs-unstable.zed-editor;
      })
    ];
  };
  modules = [
    inputs.private.sys.kennedy.home.default
    inputs.mac-app-util.homeManagerModules.default
    inputs.secrets.homeManagerModules.default
    ./home.nix
  ];
  extraSpecialArgs = {
    inherit inputs;
  };
}
