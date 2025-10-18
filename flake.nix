{
  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-23-11.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-system-graphics = {
      url = "github:soupglasses/nix-system-graphics";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util.url = "github:hraban/mac-app-util?ref=link-contents";
  };
  outputs =
    { self, ... }@inputs:
    {

      nixosConfigurations = {
        "nixon" = import ./host/nixon { inherit self inputs; };
      };
      darwinConfigurations = {
        "trix" = import ./host/trix { inherit self inputs; };
      };
      
      systemConfigs = {
        "harry" = import ./systems/harry { inherit self inputs; };
      };

      homeConfigurations = {
        "hpidcock@harry" = import ./home/hpidcock-harry { inherit self inputs; };
        "hpidcock@magic-mac" = import ./home/hpidcock-magic-mac { inherit self inputs; };
        "hpidcock@nixon" = import ./home/hpidcock-nixon { inherit self inputs; };
        "hpidcock@trix" = import ./home/hpidcock-trix { inherit self inputs; };
      };

    };
}
