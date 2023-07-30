{ config, pkgs, username, ... }:
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

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";

    stateVersion = "23.05";
    sessionVariables = {
      EDITOR = "ide";
    };

    packages = with pkgs; [
      screen
      btop
      neofetch
      vim
      neovim
      nano
      gcc
      glib
      tmuxPlugins.onedark-theme
      flatpak
      lazygit
    ];
  };

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
