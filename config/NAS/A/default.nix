{ ... }:
{
  imports = [
    ./wireguard
  ];
  
  networking = {
    interfaces.eno1.ipv4.addresses = [{
      address = "45.88.180.19";
      prefixLength = 24;
    }];
    defaultGateway = "45.88.180.254";
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
  };
  
  boot.loader.grub = {
    efiSupport = false;
    devices = [ "/dev/sda1" ];
  };
}
