{ hostname }:
{ pkgs, config, ... }:
{
  imports = [
    (import ./service { hostname = hostname; })
  ];

  boot = {
    loader = {
      grub = {
        enable = true;
        efiSupport = false;
        devices = [ "/dev/sda1" ];
      };
    };
  };

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
