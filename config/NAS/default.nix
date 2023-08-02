{ hostname }:
{
  imports = [
    (import ./service { hostname = hostname; })
  ];
}
