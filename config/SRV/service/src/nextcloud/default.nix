{ hostname }:
{
  networking = {
    nat = {
      internalInterfaces = ["ve-+"];
    };
    firewall.allowedTCPPorts = [
      80
      443
    ];

    extraHosts =
    ''
      10.110.0.1 nextcloud.local
      10.210.255.254 UniDash-SRV-A.nextcloud.local
      10.210.255.253 UniDash-SRV-B.nextcloud.local
      10.210.255.252 UniDash-SRV-C.nextcloud.local
    '';
  };

  services.nginx = {
    proxyTimeout = "3s";
    upstreams = {
      nextcloud.servers = {
        "UniDash-SRV-A.nextcloud.local max_fails=3 fail_timeout=300s" = {};
        "UniDash-SRV-B.nextcloud.local max_fails=3 fail_timeout=300s" = {};
        "UniDash-SRV-C.nextcloud.local max_fails=3 fail_timeout=300s" = {};
      };
    };

    virtualHosts = {
      "${hostname}.nextcloud.local" = {
        enableACME = false;
        forceSSL = false;

        locations."/".proxyPass = "http://nextcloud.local/";
      };

      "nextcloud.heurepika.com" = {
        enableACME = true;
        forceSSL = true;

        extraConfig = ''
          proxy_read_timeout 300;
          proxy_connect_timeout 2;
          proxy_send_timeout 300;
        '';

        locations."/".proxyPass = "http://nextcloud";
      };
    };
  };

  containers.nextcloud = {
    autoStart = false; 
    privateNetwork = true;           
    hostAddress = "10.110.255.254";
    localAddress = "10.110.0.1";
    hostAddress6 = "fc00::1";
    localAddress6 = "fc00::2";
    config = { config, pkgs, ... }: {
      services.nextcloud = {                     
        enable = true;
        package = pkgs.nextcloud27;
        hostName = "nextcloud.local";
        config = {
          adminuser = "Gabriel";
          adminpassFile = "${pkgs.writeText "adminpass" (builtins.readFile ./adminpass)}";
        };
      };

      system.stateVersion = "23.05";

      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 80 ];
      };

      environment.etc."resolv.conf".text = "nameserver 1.1.1.1";
    };
  };
}
