{ pkgs, username, ... }:
{
  hardware.nvidia-container-toolkit.enable = true;

  # Add user to libvirtd and kvm groups
  users.users.${username}.extraGroups = [
    "libvirtd"
    "kvm"
    "docker"
  ];

  # Install necessary packages
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    virtio-win
    win-spice
    adwaita-icon-theme
    distrobox
    # gvisor
  ];

  # Manage the virtualisation services
  virtualisation = {
    docker.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;
}
