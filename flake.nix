{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
  };
  outputs =
    { self, ... }@inputs:
    {

      nixosConfigurations = {
        "nixon" = import ./host/nixon { inherit self inputs; };
      };

      homeConfigurations = {
        "hpidcock@nixon" = import ./home/hpidcock-nixon { inherit self inputs; };
        "hpidcock@magic-mac" = import ./home/hpidcock-magic-mac { inherit self inputs; };
      };

    };
}
