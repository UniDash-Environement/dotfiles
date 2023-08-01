{ pkgs, username, ... }:
{
  imports = [
    ../default.nix
  ];

  home = {
    username = "${username.user2}";
    homeDirectory = "/home/${username.user2}";

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
}
