{ pkgs, ... }:
{
  home.file.i3_configs = {
    source = ./src;
    target = ".config/i3";
    recursive = true;
  };
}
