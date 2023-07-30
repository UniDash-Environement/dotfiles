{ hostname }:
{ config, pkgs, ... }:
{
  imports = [
    ./issue
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

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        gfxmodeEfi = "1920x1080x32";
      };
    };

    initrd.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
      "vfio_virqfd"
      "amdgpu"
    ];

    kernelParams = [
      "amd_iommu=on"
      "intel_iommu=on"
    ];

    supportedFilesystems = [ "ntfs" ];
  };

  networking = {
    hostName = "${hostname}";
    networkmanager.enable = true;
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
  
  services = {
    gvfs.enable = true;
    tumbler.enable = true;
    openssh.enable = true;
    gpm.enable = true;
    upower.enable = true;
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

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };

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
    ];
  };

  system = {
    copySystemConfiguration = false;
    stateVersion = "23.05";
  };

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };
}
