{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rofi
    rofimoji
  ];

  xdg.configFile."rofi/theme.rasi".source = ./theme.rasi;
  xdg.configFile."rofi/config.rasi".source = ./config.rasi;

  xdg.configFile."rofi/powermenu-theme.rasi".source = ./powermenu-theme.rasi;
}
