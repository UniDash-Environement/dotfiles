{ hostname }:
{ ... }:
{
  imports = [
  ];

  services = {
    gvfs.enable = true;
    tumbler.enable = true;
    openssh.enable = true;
    gpm.enable = true;
    upower.enable = true;
    nginx.enable = true;
  };

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };
}
