{ pkgs, ... }:
{
  programs = {
    dconf.enable = true;
    zsh.enable = true;
    wireshark.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      settings = {
        default-cache-ttl = 43200;
        max-cache-ttl = 43200;
      };
      # pinentryFlavor = "";
    };

    appimage.enable = true;

    nix-ld.enable = true;
    nix-ld.libraries = with pkgs; [ ];
  };

  services.udev.packages = with pkgs; [
    openocd
  ];
}
