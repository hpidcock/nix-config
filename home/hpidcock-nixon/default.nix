{ inputs, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = "x86_64-linux";
    config = {
      allowUnfree = true;
    };
  };
in
inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = import inputs.nixpkgs {
    system = "x86_64-linux";
    config = {
      allowUnfree = true;
    };

    overlays = [
      (self: super: {
        zed-editor = pkgs-unstable.zed-editor;
      })
    ];
  };
  modules = [ ./home.nix ];
  extraSpecialArgs = {
    inherit inputs;
  };
}
