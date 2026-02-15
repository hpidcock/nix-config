{ pkgs, config, ... }:
{
  containers.homeassistant = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.11";
    macvlans = [ "enp86s0" ];
    config =
      { lib, ... }:
      {
        networking = {
          useDHCP = lib.mkForce true;
          useNetworkd = lib.mkForce true;
          useHostResolvConf = lib.mkForce false;
          interfaces.mv-enp86s0 = {
            useDHCP = true;
            macAddress = "c3:d2:ad:46:02:01";
          };
          firewall = {
            enable = true;
            interfaces.ve-homeassistant = {
              allowedTCPPorts = [ 8123 ];
            };
            interfaces.mv-enp86s0 = {
              allowedUDPPortRanges = [
                {
                  from = 0;
                  to = 65535;
                }
              ];
              allowedTCPPortRanges = [
                {
                  from = 0;
                  to = 65535;
                }
              ];
            };
          };
        };
        services.resolved.enable = true;
        services.home-assistant = {
          enable = true;
          extraComponents = [
            "met"
            "esphome"
          ];
          config = {
            default_config = { };
            http = {
              server_host = "192.168.100.11";
              trusted_proxies = [ "192.168.100.10" ];
              use_x_forwarded_for = true;
            };
          };
        };
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
