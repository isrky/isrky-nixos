{ pkgs, ... }:
{
  programs = {
    dconf.enable = true;
    zsh.enable = true;
    wireshark.enable = true;

    gnupg.agent = {
      enable = true;
      settings = {
        default-cache-ttl = 43200;
        max-cache-ttl = 43200;
      };
      # GCR prompt with "save in password manager" -> gnome-keyring
      pinentryPackage = pkgs.pinentry-gnome3;
    };

    appimage.enable = true;

    nix-ld.enable = true;
    nix-ld.libraries = with pkgs; [ ];
  };

  services.udev.packages = with pkgs; [
    openocd
  ];
}
