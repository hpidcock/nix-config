# OpenShell

NVIDIA [OpenShell](https://github.com/NVIDIA/OpenShell) CLI and gateway, built
from a pinned upstream release, plus a Home Manager module for the local
gateway. Nothing is enabled unless a home configuration opts in.

Layout:

- `pkgs/openshell/default.nix` builds either binary from the same source.
  `callPackage ./pkgs/openshell { }` gives the CLI; `{ gateway = true; }`
  gives the gateway. `Cargo.lock` is a copy of upstream's for the pinned tag.
- `home/modules/openshell.nix` provides `programs.openshell` and
  `services.openshell`.
- `pkgs/openshell/tests.nix` are evaluation-only module tests.

## Bumping the version

Update `version` and `hash` in `default.nix`, then replace `Cargo.lock` with
the one from the new tag (for example from
`https://github.com/NVIDIA/OpenShell/raw/v<version>/Cargo.lock`).

## Home Manager

Add the packages to the home's overlay and import the module:

```nix
# overlay
openshell = pkgs-unstable.callPackage ../../pkgs/openshell { };
openshell-gateway = pkgs-unstable.callPackage ../../pkgs/openshell { gateway = true; };

# home.nix
imports = [ ../modules/openshell.nix ];
programs.openshell.enable = true;
```

The CLI is available on Linux and Apple Silicon Darwin.

### Linux gateway

```nix
{
  services.openshell = {
    enable = true;
    computeDriver = "podman";
    managePodmanSocket = false; # host already provides podman.socket
  };
}
```

Enabling the gateway also installs the CLI. It creates an
`openshell-gateway.service` user unit and, by default, a rootless Podman API
socket and service. Set `managePodmanSocket = false` if the host already
provides `podman.socket` (churchill does: Ubuntu ships a user
`podman.socket`, and the gateway's `Wants=` activates it). For Docker, set
`computeDriver = "docker"` and provide a running Docker engine accessible to
the user.

Podman still requires host subordinate UID/GID ranges, working `uidmap`
helpers, cgroups v2 and rootless networking. Home Manager does not configure
these system permissions. Only enable one configuration for `podman.socket`.

The gateway defaults to `https://127.0.0.1:17670` with client-certificate
authentication. Its certificates and database live under
`$XDG_STATE_HOME/openshell`; certificate generation preserves complete existing
bundles. A partial certificate bundle causes startup to fail rather than
silently deleting credentials.

The service reads generated TOML directly from the Nix store because OpenShell
rejects symlinked configuration files. Override non-secret gateway options via
`services.openshell.settings`; use `services.openshell.port` to change the
listener and registered CLI endpoint together. Do not put secrets in settings.
Keep the generated gateway name, TLS paths and authentication configuration
unless you also arrange matching credentials and CLI registration.

After applying Home Manager:

```sh
systemctl --user start openshell-gateway.service
systemctl --user status openshell-gateway.service
openshell gateway select openshell
openshell -g openshell status
```

The module registers the local `openshell` endpoint but does not change your
active gateway. Certificates are created on first service startup. To inspect
startup failures:

```sh
journalctl --user -u openshell-gateway --no-pager -n 50
```

Keeping the service running after logout requires host administrator setup:

```sh
sudo loginctl enable-linger USERNAME
```

No Darwin launchd service or MicroVM runtime is configured by this module.
Container images are downloaded at runtime, not included in the Nix packages.

## Validation

From the repository root, evaluate the module tests without building the
OpenShell binaries:

```sh
nix eval --impure --json --expr '
  import ./pkgs/openshell/tests.nix {
    flake = builtins.getFlake ("path:" + toString ./.);
  }
'
```
