{ pkgs, username, inputs, ... }:
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
    waydroid-helper
    inputs.nur.legacyPackages.${pkgs.system}.repos.ataraxiasjel.waydroid-script
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
    waydroid.enable = true;
    # Newer kernel versions needs
    waydroid.package = pkgs.waydroid-nftables;
  };
  services.spice-vdagentd.enable = true;

  systemd = {
    packages = [ pkgs.waydroid-helper ];
    services.waydroid-mount.wantedBy = [ "multi-user.target" ];
  };
}
