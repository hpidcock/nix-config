{
  inputs = {
    nixpkgs-staging.url = "github:NixOS/nixpkgs/staging";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    secrets = {
      url = "git+ssh://git@codeberg.org/hpidcock/nix-secrets.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    private = {
      url = "git+ssh://git@codeberg.org/hpidcock/nix-private.git";
    };
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-system-graphics = {
      url = "github:soupglasses/nix-system-graphics";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util.url = "github:hraban/mac-app-util?ref=link-contents";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      private,
      ...
    }@inputs:
    {

      nixosConfigurations = {
        "${private.sys.nixon.home.key}" = import ./systems/nixon { inherit self inputs; };
        "${private.sys.merkel.home.key}" = import ./systems/merkel { inherit self inputs; };
        "e52c" = import ./host/e52c { inherit self inputs; };
      };
      darwinConfigurations = {
        "${private.sys.kennedy.key}" = import ./systems/kennedy { inherit self inputs; };
      };

      systemConfigs = {
        "${private.sys.eisenhower.key}" = import ./systems/eisenhower { inherit self inputs; };
        "${private.sys.churchill.key}" = import ./systems/churchill { inherit self inputs; };
      };

      homeConfigurations = {
        "${private.sys.eisenhower.home.key}" = import ./home/eisenhower { inherit self inputs; };
        "${private.sys.tito.home.key}" = import ./home/tito { inherit self inputs; };
        "${private.sys.nixon.home.key}" = import ./home/nixon { inherit self inputs; };
        "${private.sys.kennedy.home.key}" = import ./home/kennedy { inherit self inputs; };
        "${private.sys.holt.home.key}" = import ./home/holt { inherit self inputs; };
        "${private.sys.merkel.home.key}" = import ./home/merkel { inherit self inputs; };
        "${private.sys.churchill.home.key}" = import ./home/churchill { inherit self inputs; };
      };

      devShells = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ] (system: {
        juju = import ./shell/juju { inherit self inputs system; };
        rp2040 = import ./shell/rp2040 { inherit self inputs system; };
      });

      "e52c-img" = import ./systems/e52c/image.nix {
        inherit self inputs;
      };

    };
}
