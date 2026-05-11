{ ... }:
{
  services.zapret = {
    enable = true;
    params = [
      "--dpi-desync=fake"
      "--dpi-desync-ttl=3"
    ];
    configureFirewall = true;
    udpSupport = true;
    udpPorts = [
      "443"
      "50000"
      "50001"
      "50002"
    ];
  };
}
