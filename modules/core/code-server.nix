{ pkgs, username, ... }:
{
  services.code-server = {
    enable = true;
    user = username;
    # Default is a dedicated `code-server` group; since the service runs as the
    # real user, files it creates should carry the user's normal group.
    group = "users";
    # Bind to IPv4 explicitly; "localhost" resolves to ::1, which `tailscale
    # serve` (proxying to 127.0.0.1) cannot reach.
    host = "127.0.0.1";
    # Only reachable via `tailscale serve` (tailnet-only, HTTPS, Tailscale
    # identity), so the built-in login page is redundant.
    auth = "none";
    # The service has a minimal PATH; the extension host (Git sidebar, tasks)
    # needs these even though the integrated terminal gets them from zsh.
    extraPackages = with pkgs; [
      git
      nix
    ];
    disableTelemetry = true;
    # nix pins the version; the weekly "new release" notification is noise.
    disableUpdateCheck = true;
    disableGettingStartedOverride = true;
    extensionsDir = "/home/${username}/documents/vscode-dev/ext";
  };
}
