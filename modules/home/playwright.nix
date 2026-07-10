{ pkgs, ... }:
# Playwright on NixOS for Hono / Node.js projects.
#
# The browsers Playwright downloads via `npx playwright install` are dynamically
# linked against an FHS layout that does not exist on NixOS, so they fail to run.
# Instead we point Playwright at the browsers built by nixpkgs and tell it to skip
# the download and the host-requirement validation.
#
# IMPORTANT: the `@playwright/test` (or `playwright`) version in your project's
# package.json must match the `playwright-driver` from nixpkgs, otherwise
# Playwright looks for a browser revision that isn't in the Nix browsers path.
# Current nixpkgs playwright-driver is 1.60.0; check with:
#   nix eval nixpkgs#playwright-driver.version
# Pin the npm dep to that exact version, e.g.:
#   pnpm add -D @playwright/test@1.60.0
{
  home.packages = with pkgs; [
    playwright-driver # bundled driver + node CLI wrapper
  ];

  home.sessionVariables = {
    # Use the browsers built by nixpkgs instead of the FHS ones Playwright downloads.
    PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
    # Don't try to download browsers on `npm/pnpm install` or `playwright install`.
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
    # The Nix browsers are patched; skip Playwright's own host/dependency checks.
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
  };
}
