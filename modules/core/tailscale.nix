{ username, ... }:
{
  services.tailscale = {
    enable = true;
    # "server" enables IP forwarding so this host can act as a subnet router.
    useRoutingFeatures = "server";
    extraSetFlags = [
      "--accept-dns=false"
      # Let the regular user run `tailscale serve` etc. without sudo.
      "--operator=${username}"
      # Expose the GlobalProtect-only host to the tailnet. Only works while the
      # openconnect VPN is up; tailscale SNATs forwarded traffic to the VPN
      # address by default. The route must be approved in the admin console.
      "--advertise-routes=192.168.60.20/32"
    ];
  };
}
