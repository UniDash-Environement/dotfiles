{ pkgs, ... }:
{
  boot = {
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

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };
  
  environment = {
    shells = with pkgs; [ fish ];
    systemPackages = with pkgs; [
      virt-manager
      pciutils
    ];
  };
}
