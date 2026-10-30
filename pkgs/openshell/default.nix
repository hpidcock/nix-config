# NVIDIA OpenShell CLI and gateway, built from a pinned upstream release.
#
#   openshell = pkgs.callPackage ../../pkgs/openshell { };
#   openshell-gateway = pkgs.callPackage ../../pkgs/openshell { gateway = true; };
#
# Both derivations share the same source and version so the CLI and gateway
# stay in lockstep (the gateway embeds the image tag at compile time).
{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  perl,
  pkg-config,
  protobuf,
  z3,
  cacert,
  gitMinimal,
  openssh,
  coreutils,
  versionCheckHook,
  gateway ? false,
}:
let
  version = "0.1.6";
  pname = if gateway then "openshell-gateway" else "openshell";
  cargoPackage = if gateway then "openshell-gateway" else "openshell-cli";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "OpenShell";
    tag = "v${version}";
    hash = "sha256-/XVZdlCLTmWSwGUVbZtkJxej5LfFa3hJR+gNlInOajA=";
  };

  # Copy of the upstream Cargo.lock for this tag, so evaluation needs no
  # import-from-derivation. Update it together with `version` and `hash`.
  cargoLock.lockFile = ./Cargo.lock;

  cargoBuildFlags = [
    "--package"
    cargoPackage
    "--bin"
    pname
  ];
  cargoTestFlags = [
    "--package"
    cargoPackage
  ];

  nativeBuildInputs = [
    cmake
    perl
    pkg-config
    protobuf
    rustPlatform.bindgenHook
  ];
  buildInputs = [ z3 ];
  nativeCheckInputs = [
    cacert
    gitMinimal
    openssh
  ];

  postPatch = ''
    # Fill in the package version; upstream stamps it in CI.
    substituteInPlace Cargo.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'

    # Preflight fixtures clear PATH, so sleep needs an absolute store path.
    substituteInPlace crates/openshell-gateway/tests/config_preflight.rs \
      --replace-fail '/bin/sleep' '${coreutils}/bin/sleep'
  '';

  env = {
    # Container image tag baked in at compile time; must match the version.
    OPENSHELL_IMAGE_TAG = version;
    PROTOC = "${protobuf}/bin/protoc";
  };

  doCheck = !stdenv.hostPlatform.isDarwin;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description =
      if gateway then
        "OpenShell gateway for managing sandboxed AI agents"
      else
        "OpenShell CLI for managing sandboxed AI agents";
    homepage = "https://docs.nvidia.com/openshell/index.html";
    changelog = "https://github.com/NVIDIA/OpenShell/releases/tag/v${version}";
    license = lib.licenses.asl20;
    mainProgram = pname;
    platforms = if gateway then lib.platforms.linux ++ [ "aarch64-darwin" ] else lib.platforms.unix;
  };
}
