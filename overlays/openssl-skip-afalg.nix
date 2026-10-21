# The AF_ALG engine test needs to bind AF_ALG sockets, which fails with ENOENT
# on hosts with the crypto.af_alg_restrict=1 sysctl.
final: prev: {
  openssl = prev.openssl.overrideAttrs (old: {
    preCheck = (old.preCheck or "") + ''
      export TESTS=-test_afalg
    '';
  });
}
