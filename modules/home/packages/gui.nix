{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ## Multimedia
    amberol # music player
    audacity
    gimp
    media-downloader
    obs-studio
    pavucontrol
    video-trimmer
    vlc

    ## Office
    libreoffice
    gnome-calculator

    ## Utility
    dconf-editor
    gnome-boxes
    gnome-disk-utility
    popsicle
    mission-center # GUI resources monitor
    zenity

    ## Level editor
    godot
    ldtk
    tiled

    ## Mapping / GIS
    josm

    ## Communication
    localsend
    pear-desktop
    telegram-desktop

    ## Reverse engineering / hex editors
    ghex
    imhex
    wxhexeditor
  ];
}
