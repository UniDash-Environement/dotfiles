{ pkgs, username, ... }:
{
  imports = [
    ../default.nix
  ];

  home = {
    username = "${username.user1}";
    homeDirectory = "/home/${username.user1}";

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
