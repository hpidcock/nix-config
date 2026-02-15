{ pkgs, config, ... }:
{
  networking.nat = {
    enable = true;
    internalInterfaces = [ "ve-+" ];
    externalInterface = "enp86s0";
    enableIPv6 = true;
  };

  containers.homeassistant = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.11";

    config =
      { config, pkgs, ... }:
      {
        services.home-assistant = {
          enable = true;
          extraComponents = [
            "met"
            "esphome"
          ];
          config = {
            default_config = { };
            http = {
              server_host = "0.0.0.0";
              trusted_proxies = [ "192.168.100.10" ];
              use_x_forwarded_for = true;
            };
          };
        };
        networking.firewall.allowedTCPPorts = [ 8123 ];
        system.stateVersion = "25.11";
      };
  };

  services.traefik = {
    enable = true;

    staticConfigOptions = {
      entryPoints = {
        web = {
          address = ":80";
          http.redirections.entryPoint = {
            to = "websecure";
            scheme = "https";
          };
        };
        websecure = {
          address = ":443";
          http.tls.certResolver = "cloudflare";
        };
      };

      certificatesResolvers.cloudflare = {
        acme = {
          email = "domains@hdp.id.au";
          storage = "/var/lib/traefik/acme.json";
          dnsChallenge = {
            provider = "cloudflare";
          };
        };
      };
    };

    dynamicConfigOptions = {
      http = {
        routers.homeassistant = {
          rule = "Host(`ha-test.3.14.run`)";
          entryPoints = [ "websecure" ];
          service = "homeassistant";
          tls.certResolver = "cloudflare";
        };
        services.homeassistant = {
          loadBalancer.servers = [
            {
              url = "http://192.168.100.11:8123";
            }
          ];
        };
      };
    };
  };

  # Cloudflare API token for DNS challenge
  systemd.services.traefik.serviceConfig = {
    EnvironmentFile = config.age.secrets.cloudflare.path;
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

}
