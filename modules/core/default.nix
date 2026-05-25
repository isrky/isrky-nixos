{ ... }:
{
  imports = [
    ./nixpkgs.nix
    ./bootloader.nix
    ./hardware.nix
    ./xserver.nix
    ./network.nix
    ./bluetooth.nix
    ./fonts.nix
    ./nh.nix
    ./pipewire.nix
    ./program.nix
    ./security.nix
    ./services.nix
    ./zapret.nix
    ./sunshine.nix
    ./code-server.nix
    ./steam.nix
    ./system.nix
    ./nfc.nix
    ./flatpak.nix
    ./user.nix
    ./wayland.nix
    ./virtualization.nix
    ./tailscale.nix
    # ./qmk.nix
    ./dnscrypt-proxy.nix
    ./piper.nix
  ];
}
