{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
  };
  outputs = { self, ... }@inputs: {

    nixosConfigurations = {
      "nixon" = import ./host/nixon { inherit self inputs; };
    };

    homeConfigurations = {
      "hpidcock@nixon" = import ./home/hpidcock-nixon { inherit self inputs; };
    };

  };
}
