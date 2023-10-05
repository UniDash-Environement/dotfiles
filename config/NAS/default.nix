{ hostname }:
{ pkgs, config, ... }:
{
  imports = [
    (import ./service { hostname = hostname; })
  ];

  users.users.gabriel = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
  
  users.users.evnoxay = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
}
