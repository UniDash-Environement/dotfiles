{ hostname }:
{ config, pkgs, ... }:
{
  imports = [
    ./issue
    ./service/default.nix
    ./networking.nix
    ./virtualisation
  ];

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
      keep-outputs = true;
      keep-derivations = true;
      auto-optimise-store = true;
      warn-dirty = false;
    };
    optimise.automatic = true;
  };

  environment.pathsToLink = [ "/share/nix-direnv" ];
  nixpkgs = {
  config.allowUnfree = true;
    overlays = [
      (self: super: {
        nix-direnv = super.nix-direnv.override {
          enableFlakes = true;
        };
      })
    ];
  };

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "fr_FR.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  programs = {
    command-not-found.enable = false;
    dconf.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    fish.enable = true;
  };
  
  users.users.gabriel = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "docker"
      "networkmanager"
      "libvirtd"
      "wheel"
    ];
  };

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  environment = {
    shells = with pkgs; [ fish ];
    systemPackages = with pkgs; [
      modemmanager
      git
      htop
      tree
      nano
      curl
      gdu
      unzip
      virt-manager
      fish
      fishPlugins.bobthefish
      killall
      bc
      pciutils
      wget
      (pkgs.callPackage ./ide { })
    ];
  };

  system = {
    copySystemConfiguration = false;
    stateVersion = "23.05";
  };
}
