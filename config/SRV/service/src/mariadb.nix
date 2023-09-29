{ hostname }:
{ pkgs, ... }:
{
  networking = {
    nat = {
      internalInterfaces = ["ve-+"];
    };
    firewall.allowedTCPPorts = [
      3306
      3307
      3308
    ];

    extraHosts =
    ''
      127.0.0.1 mariadb.local
      10.210.255.254 UniDash-SRV-A.mariadb.local
      10.210.255.253 UniDash-SRV-B.mariadb.local
      10.210.255.252 UniDash-SRV-C.mariadb.local
      127.0.0.1 cluster.mariadb.local
    '';
  };

  services.haproxy = {
    enable = true;
    config = ''
      global
        log mariadb.local local0 notice
        user haproxy
        group haproxy

      defaults
        log global
        retries 2
        timeout connect 3000
        timeout server 1m
        timeout client 1m
        option allbackups

      listen mariadb-container
        bind ${hostname}.mariadb.local:3307
        mode tcp
        balance roundrobin
        server Container mariadb.local:3306

      listen mariadb-cluster
        bind cluster.mariadb.local:3308
        mode tcp
        balance roundrobin
        option mysql-check
        default-server fastinter 1000
        server Mariadb-SRV-A UniDash-SRV-A.mariadb.local:3307 check
        server Mariadb-SRV-B UniDash-SRV-B.mariadb.local:3307 check
        server Mariadb-SRV-C UniDash-SRV-C.mariadb.local:3307 check

      listen container-access
        bind 10.210.255.254:3308
        mode tcp
        balance roundrobin
        server Container cluster.mariadb.local:3308
      '';
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    initialScript = ./init.sql;
    ensureUsers = [];
    ensureDatabases = [];
    initialDatabases = [];
  };
}
