{ inputs, ... }:
{
  imports = [ inputs.open-design.homeManagerModules.default ];

  services.open-design = {
    enable = true;
    autoStart = true;
    webFrontend.enable = true;
  };
}
