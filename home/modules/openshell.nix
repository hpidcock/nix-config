# Copyright (c) 2026 Thomas Miller
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# OpenShell CLI and local gateway user service.
#
# Expects `pkgs.openshell` and `pkgs.openshell-gateway` from an overlay, e.g.
#   openshell = pkgs.callPackage ../../pkgs/openshell { };
#   openshell-gateway = pkgs.callPackage ../../pkgs/openshell { gateway = true; };
# See pkgs/openshell/README.md for usage notes.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.openshell;
  cli = config.programs.openshell;
  format = pkgs.formats.toml { };
  configFile = format.generate "openshell-gateway.toml" cfg.settings;
  gateway = lib.getExe cfg.package;
  stateDir = "${config.xdg.stateHome}/openshell";
  tlsDir = "${stateDir}/tls";
  managedPodman = cfg.computeDriver == "podman" && cfg.managePodmanSocket;
  podmanSocket = cfg.computeDriver == "podman";
in
{
  options = {
    programs.openshell = {
      enable = lib.mkEnableOption "the OpenShell CLI";
      package = lib.mkPackageOption pkgs "openshell" { };
    };

    services.openshell = {
      enable = lib.mkEnableOption "the local OpenShell gateway user service";
      package = lib.mkPackageOption pkgs "openshell-gateway" { };

      computeDriver = lib.mkOption {
        type = lib.types.enum [
          "docker"
          "podman"
        ];
        default = "podman";
        description = "Container backend used by the gateway.";
      };

      managePodmanSocket = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Manage the rootless Podman API user socket when using Podman.
          Disable this if the host already provides podman.socket.
          Host subordinate UID/GID allocations and uidmap helpers are still
          required.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 17670;
        description = "Port for the loopback gateway listener.";
      };

      settings = lib.mkOption {
        type = format.type;
        default = { };
        description = ''
          Gateway TOML settings, merged with authenticated local defaults.
          Do not include secrets: this configuration is stored in the Nix
          store. The service generates certificates in user state instead.
        '';
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cli.enable {
      home.packages = [ cli.package ];
    })

    (lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = pkgs.stdenv.hostPlatform.isLinux;
          message = "services.openshell currently supports Linux user systemd services only.";
        }
      ];

      programs.openshell.enable = true;

      services.openshell.settings.openshell = {
        version = lib.mkDefault 2;
        gateway = {
          name = lib.mkDefault "openshell";
          bind_address = lib.mkDefault "127.0.0.1:${toString cfg.port}";
          compute_driver = lib.mkDefault cfg.computeDriver;
          disable_tls = lib.mkDefault false;
          guest_tls_ca = lib.mkDefault "${tlsDir}/ca.crt";
          tls = {
            cert_path = lib.mkDefault "${tlsDir}/server/tls.crt";
            key_path = lib.mkDefault "${tlsDir}/server/tls.key";
            client_ca_path = lib.mkDefault "${tlsDir}/ca.crt";
          };
          mtls_auth = {
            enabled = lib.mkDefault true;
            operator_enabled = lib.mkDefault false;
          };
          auth.allow_unauthenticated_users = lib.mkDefault false;
        };
      };

      # Registers the local gateway with the CLI. Certgen refreshes this
      # gateway's writable mtls directory on startup.
      xdg.configFile."openshell/gateways/openshell/metadata.json".text = builtins.toJSON {
        name = "openshell";
        gateway_endpoint = "https://127.0.0.1:${toString cfg.port}";
        is_remote = false;
        gateway_port = 0;
        auth_mode = "mtls";
      };

      systemd.user.services.openshell-gateway = {
        Unit = {
          Description = "OpenShell gateway";
          After = lib.optional podmanSocket "podman.socket";
          Wants = lib.optional podmanSocket "podman.socket";
        };
        Service = {
          Type = "simple";
          Environment = [
            "XDG_CONFIG_HOME=${config.xdg.configHome}"
            "XDG_STATE_HOME=${config.xdg.stateHome}"
            "OPENSHELL_LOCAL_TLS_DIR=${tlsDir}"
            "OPENSHELL_DB_URL=sqlite:${stateDir}/gateway/openshell.db?mode=rwc"
            "PATH=${
              lib.makeBinPath [
                pkgs.coreutils
                pkgs.openssh
              ]
            }"
          ];
          ExecStartPre = [
            "${pkgs.coreutils}/bin/install -d -m 0700 ${
              lib.escapeShellArgs [
                "${stateDir}/gateway"
                tlsDir
              ]
            }"
            # OpenShell refuses symlinked TOML paths; use the store file directly.
            "${gateway} config preflight -- --config ${configFile}"
            "${gateway} generate-certs --output-dir ${lib.escapeShellArg tlsDir} --server-san host.openshell.internal"
          ];
          ExecStart = "${gateway} --config ${configFile}";
          Restart = "on-failure";
          RestartSec = 5;
          PrivateTmp = true;
          UMask = "0077";
        };
        Install.WantedBy = [ "default.target" ];
      };
    })

    (lib.mkIf (cfg.enable && managedPodman) {
      home.packages = [ pkgs.podman ];

      systemd.user.sockets.podman = {
        Unit.Description = "Podman API socket";
        Socket = {
          ListenStream = "%t/podman/podman.sock";
          SocketMode = "0600";
          DirectoryMode = "0700";
        };
        Install.WantedBy = [ "sockets.target" ];
      };

      systemd.user.services.podman = {
        Unit = {
          Description = "Podman API service";
          Requires = [ "podman.socket" ];
          After = [ "podman.socket" ];
        };
        Service = {
          Type = "exec";
          ExecStart = "${lib.getExe pkgs.podman} system service --time=0";
          KillMode = "process";
        };
      };
    })
  ];
}
