{ hostname }:
{ pkgs, config, ... }:
{
  imports = [
    (import ./service { hostname = hostname; })
    ./virtualisation
  ];

  users.users.gabriel = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "docker"
      "networkmanager"
      "libvirtd"
      "wheel"
    ];
  };
  
  users.users.evnoxay = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "docker"
      "networkmanager"
      "libvirtd"
      "wheel"
    ];
  };
}
