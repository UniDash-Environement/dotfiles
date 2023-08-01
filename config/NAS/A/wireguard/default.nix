{ pkgs, ... }: {
  networking = {
    nat = {
      enable = true;
      externalInterface = "eno1";
      internalInterfaces = [
        "wg-wan"
        "wg-lan"
        "wg-admin"
      ];
    };

    firewall = {
      allowedUDPPorts = [
        51820
        51821
        51822
      ];
    };

    wireguard.interfaces = {
      wg-wan = {
        ips = ["10.210.254.254/16"];
        listenPort = 51820;
        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.210.0.0/16 -o eno1 -j MASQUERADE
        '';
        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.210.0.0/16 -o eno1 -j MASQUERADE
        '';

        privateKeyFile = "/etc/wireguard/wan/privateKey";
        peers = [
         {
            publicKey = (builtins.readFile ../../../SRV/A/wireguard/key/wan/publickey);
            allowedIPs = ["10.210.255.254/32"];
            endpoint = ":51820";
            persistentKeepalive = 25;
          } 
          {
            publicKey = (builtins.readFile ../../../SRV/B/wireguard/key/wan/publickey);
            allowedIPs = ["10.210.255.253/32"];
            endpoint = ":51820";
            persistentKeepalive = 25;
          }
          {
            publicKey = (builtins.readFile ../../../NAS/B/wireguard/key/wan/publickey);
            allowedIPs = ["10.210.254.253/32"];
            endpoint = ":51820";
            persistentKeepalive = 25;
          }
          {
            publicKey = (builtins.readFile ../../../SRV/C/wireguard/key/wan/publickey);
            allowedIPs = ["10.210.255.252/32"];
            endpoint = ":51820";
            persistentKeepalive = 25;
          }
          {
            publicKey = (builtins.readFile ../../../NAS/C/wireguard/key/wan/publickey);
            allowedIPs = ["10.210.254.252/32"];
            endpoint = ":51820";
            persistentKeepalive = 25;
          }
        ];
      };

      wg-lan = {
        ips = ["10.220.254.254/16"];
        listenPort = 51821;
        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.220.0.0/16 -o eno1 -j MASQUERADE
        '';
        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.220.0.0/16 -o eth0 -j MASQUERADE
        '';

        privateKeyFile = "/etc/wireguard/lan/privateKey";
        peers = [
          {
            publicKey = (builtins.readFile ../../../SRV/A/wireguard/key/lan/publickey);
            allowedIPs = ["10.220.255.254/32"];
            endpoint = ":51820";
            persistentKeepalive = 25;
          }
          {
            publicKey = (builtins.readFile ../../../SRV/B/wireguard/key/lan/publickey);
            allowedIPs = ["10.220.255.253/32"];
            endpoint = ":51821";
            persistentKeepalive = 25;
          }
          {
            publicKey = (builtins.readFile ../../../NAS/B/wireguard/key/lan/publickey);
            allowedIPs = ["10.220.254.253/32"];
            endpoint = ":51821";
            persistentKeepalive = 25;
          }
          {
            publicKey = (builtins.readFile ../../../SRV/C/wireguard/key/lan/publickey);
            allowedIPs = ["10.220.255.252/32"];
            endpoint = ":51821";
            persistentKeepalive = 25;
          }
          {
            publicKey = (builtins.readFile ../../../NAS/C/wireguard/key/lan/publickey);
            allowedIPs = ["10.220.254.252/32"];
            endpoint = ":51821";
            persistentKeepalive = 25;
          }
        ];
      };

      wg-admin = {
        ips = ["10.10.254.254/16"];
        listenPort = 51822;
        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.10.0.0/16 -o eno1 -j MASQUERADE
        '';
        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.10.0.0/16 -o eth0 -j MASQUERADE
        '';
  
        privateKeyFile = "/etc/wireguard/admin/privateKey";
        peers = [
         {
            publicKey = (builtins.readFile ../../../SRV/A/wireguard/key/admin/publickey);
            allowedIPs = ["10.10.255.254/32"];
            endpoint = ":51820";
            persistentKeepalive = 25;
          } 
          {
            publicKey = (builtins.readFile ../../../SRV/B/wireguard/key/admin/publickey);
            allowedIPs = ["10.10.255.253/32"];
            endpoint = ":51822";
            persistentKeepalive = 25;
          }
          {
            publicKey = (builtins.readFile ../../../NAS/B/wireguard/key/admin/publickey);
            allowedIPs = ["10.10.254.253/32"];
            endpoint = ":51822";
            persistentKeepalive = 25;
          }
          {
            publicKey = (builtins.readFile ../../../SRV/C/wireguard/key/admin/publickey);
            allowedIPs = ["10.10.255.252/32"];
            endpoint = ":51822";
            persistentKeepalive = 25;
          }
          {
            publicKey = (builtins.readFile ../../../NAS/C/wireguard/key/admin/publickey);
            allowedIPs = ["10.10.254.252/32"];
            endpoint = ":51822";
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };
}
