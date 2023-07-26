{ pkgs, ... }:
{
  home.file.nvim_configs = {
    source = ./src;
    target = ".config/nvim";
    recursive = true;
  };
}