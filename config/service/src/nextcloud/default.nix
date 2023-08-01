{
  networking.nat = {
    internalInterfaces = ["ve-+"];
    externalInterface = "eno1";
    # Lazy IPv6 connectivity for the container
    enableIPv6 = true;
  };

  containers.nextcloud = {
    autoStart = false;                
    privateNetwork = true;           
    hostAddress = "10.10.255.254";
    localAddress = "10.10.0.1";
    hostAddress6 = "fc00::1";
    localAddress6 = "fc00::2";
    config = { config, pkgs, ... }: {

      services.nextcloud = {                     
        enable = true;                   
        package = pkgs.nextcloud27;
        hostName = "localhost";
        config.adminpassFile = "./.env";
      };

      system.stateVersion = "23.05";

      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 80 ];
      };

      # Manually configure nameserver. Using resolved inside the container seems to fail
      # currently
      environment.etc."resolv.conf".text = "nameserver 1.1.1.1";

    };
  };
}
