# Evaluation-only tests for home/modules/openshell.nix. Run from the repo root:
#
#   nix eval --impure --json --expr '
#     import ./pkgs/openshell/tests.nix {
#       flake = builtins.getFlake ("path:" + toString ./.);
#     }'
{ flake }:
let
  lib = flake.inputs.nixpkgs.lib;
  overlay = final: prev: {
    openshell = final.callPackage ./. { };
    openshell-gateway = final.callPackage ./. { gateway = true; };
  };
  makeConfig =
    system: extra:
    let
      pkgs = import flake.inputs.nixpkgs {
        inherit system;
        overlays = [ overlay ];
      };
    in
    (flake.inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ../../home/modules/openshell.nix
        {
          home.username = "openshell-test";
          home.homeDirectory =
            if system == "aarch64-darwin" then "/Users/openshell-test" else "/home/openshell-test";
          home.stateVersion = "25.11";
        }
        extra
      ];
    }).config;
  disabled = makeConfig "x86_64-linux" { };
  cli = makeConfig "aarch64-darwin" { programs.openshell.enable = true; };
  podman = makeConfig "x86_64-linux" { services.openshell.enable = true; };
  arm = makeConfig "aarch64-linux" { services.openshell.enable = true; };
  docker = makeConfig "x86_64-linux" {
    services.openshell = {
      enable = true;
      computeDriver = "docker";
      port = 18080;
      settings.openshell.gateway.log_level = "debug";
    };
  };
  externalPodman = makeConfig "x86_64-linux" {
    services.openshell = {
      enable = true;
      managePodmanSocket = false;
    };
  };
  darwinService = makeConfig "aarch64-darwin" { services.openshell.enable = true; };
  valid = config: builtins.all (a: a.assertion) config.assertions;
  tests = {
    packagesFromOverlay =
      podman.programs.openshell.package.pname == "openshell"
      && podman.services.openshell.package.pname == "openshell-gateway"
      && podman.programs.openshell.package.version == podman.services.openshell.package.version;
    disabledByDefault =
      !disabled.programs.openshell.enable
      && !disabled.services.openshell.enable
      && !(disabled.systemd.user.services ? openshell-gateway);
    darwinCliOnly =
      valid cli
      && cli.programs.openshell.package.version == "0.1.6"
      && !(cli.systemd.user.services ? openshell-gateway);
    linuxPodmanGateway =
      valid podman
      && podman.programs.openshell.enable
      && podman.services.openshell.package.version == "0.1.6"
      && podman.systemd.user.sockets.podman.Socket.SocketMode == "0600"
      && podman.systemd.user.services.openshell-gateway.Service.UMask == "0077"
      && builtins.length podman.systemd.user.services.openshell-gateway.Service.ExecStartPre == 3;
    authenticatedDefaults =
      let
        gateway = podman.services.openshell.settings.openshell.gateway;
      in
      gateway.bind_address == "127.0.0.1:17670"
      && gateway.mtls_auth.enabled
      && !gateway.disable_tls
      && !gateway.auth.allow_unauthenticated_users;
    dockerAndSettingsMerge =
      valid docker
      && docker.services.openshell.settings.openshell.version == 2
      && docker.services.openshell.settings.openshell.gateway.log_level == "debug"
      && docker.services.openshell.settings.openshell.gateway.compute_driver == "docker"
      && docker.services.openshell.settings.openshell.gateway.bind_address == "127.0.0.1:18080"
      && !(docker.systemd.user.sockets ? podman)
      && docker.systemd.user.services.openshell-gateway.Unit.Wants == [ ];
    existingPodmanSocket =
      valid externalPodman
      && !(externalPodman.systemd.user.sockets ? podman)
      && !(builtins.any (p: (p.pname or "") == "podman") externalPodman.home.packages)
      && externalPodman.systemd.user.services.openshell-gateway.Unit.Wants == [ "podman.socket" ];
    armLinuxGateway = valid arm && arm.services.openshell.package.system == "aarch64-linux";
    darwinServiceRejected = !(builtins.tryEval darwinService.services.openshell.enable).success;
  };
in
assert lib.assertMsg (builtins.all (result: result) (
  builtins.attrValues tests
)) "OpenShell Home Manager module tests failed";
tests
