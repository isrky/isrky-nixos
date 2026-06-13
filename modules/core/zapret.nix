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

    blacklist = [
      "ts.net"
      "tailscale.com"
      "100.64.0.0/10"
      "127.0.0.0/8"
      "10.0.0.0/8"
      "172.16.0.0/12"
      "192.168.0.0/16"
      "169.254.0.0/16"
    ];
  };
}
