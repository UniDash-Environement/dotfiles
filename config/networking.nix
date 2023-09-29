{ hostname, ... }:
{
  networking = {
    hostName = "${hostname}";
    networkmanager.enable = true;
    firewall = {
      enable = true;

      allowedTCPPorts = [
        80
      ];
    };

    nat = {
      externalInterface = "eno1";
      enableIPv6 = true;
      enable = true;
    };

    interfaces.eno1.ipv4.addresses = [{
      address = "45.88.180.18";
      prefixLength = 24;
    }];
    defaultGateway = "45.88.180.254";
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
  };
}
