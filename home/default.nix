{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./fish
    ./neofetch
    ./btop
    ./nvim
    ./tmux

    ./extra_files.nix
    ./git.nix
    ./profile.nix
  ];

  programs = {
    home-manager.enable = true;

    bat = {
      enable = true;
      config.theme = "base16";
    };

    dircolors.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    lazygit.enable = true;
  };
}
