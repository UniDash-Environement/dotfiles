{ pkgs, ... }:
{
  home.file.btop_configs = {
    source = ./src;
    target = ".config/btop";
    recursive = true;
  };
}
