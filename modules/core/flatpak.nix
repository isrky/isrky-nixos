{ inputs, ... }:
{
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

  services.flatpak = {
    enable = true;
    packages = [
      "com.github.tchx84.Flatseal"
      "dev.geopjr.Collision"
      "io.github.plrigaux.sysd-manager"
      "me.iepure.devtoolbox"
      "io.github.dzheremi2.lrcmake-gtk"
      "so.libdb.dissent"
      "org.vinegarhq.Sober"
    ];
    overrides = {
      global = {
        # Force Wayland by default
        Context.sockets = [
          "wayland"
          "!x11"
          "!fallback-x11"
        ];
      };
    };
  };
}
