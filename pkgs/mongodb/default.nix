{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  curl,
  openssl_1_1,
  net-snmp,
}:

let
  version = "4.4.29";

  srcs = version: {
    "x86_64-linux" = {
      url = "https://downloads.mongodb.com/linux/mongodb-linux-x86_64-enterprise-ubuntu2004-${version}.tgz";
      hash = "sha256-rc94QNvHeun7mbBCGcDRfkuFwU/+amr/JH7A71fbIHI=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mongodb";
  inherit version;

  src = fetchurl (
    (srcs version).${stdenv.hostPlatform.system}
      or (throw "unsupported system: ${stdenv.hostPlatform.system}")
  );

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  dontStrip = true;

  buildInputs = [
    curl.dev
    openssl_1_1.dev
    net-snmp.dev
    (lib.getLib stdenv.cc.cc)
  ];

  installPhase = ''
    runHook preInstall

    install -Dm 755 bin/mongod $out/bin/mongod
    install -Dm 755 bin/mongos $out/bin/mongos

    runHook postInstall
  '';

  meta = {
    platforms = lib.attrNames (srcs version);
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
