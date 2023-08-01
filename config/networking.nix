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
    }

    nat = {
      externalInterface = "eno1";
      enableIPv6 = true;
      enable = true;
    };
  };
}
