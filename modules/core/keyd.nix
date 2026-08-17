{ config, pkgs, ... }:
let
  # redragon k530 over its compx 2.4g dongle. `sudo keyd monitor` prints this.
  k530 = {
    vendor = "25a7";
    product = "fa70";
  };

  # keyd listen emits +<layer>/-<layer> on every layer change. mirror the nav
  # layer onto the caps led so the mode is visible on the keyboard itself.
  keyd-led = pkgs.writeShellScript "keyd-led" ''
    caps_led() {
        for l in /sys/class/leds/*::capslock; do
            d=$(readlink -f "$l/device" 2> /dev/null) || continue
            [ "$(cat "$d/id/vendor" 2> /dev/null)" = "${k530.vendor}" ] || continue
            [ "$(cat "$d/id/product" 2> /dev/null)" = "${k530.product}" ] || continue
            printf '%s\n' "$l/brightness"
            return
        done
    }

    state=0
    keyd listen | while read -r ev; do
        case "$ev" in
            +nav) state=1 ;;
            -nav) state=0 ;;
        esac

        # re-assert on every layer event, not just +nav/-nav: keyd mirrors the
        # compositor's led writes onto the grabbed device and would clear ours.
        led=$(caps_led)
        [ -n "$led" ] && printf '%s' "$state" > "$led" 2> /dev/null || true
    done
  '';
in
{
  # the k530 has no arrow cluster and its fn+wasd is useless in games, so
  # capslock toggles a layer where wasd are arrows. led on = arrows.
  services.keyd = {
    enable = true;

    keyboards.k530 = {
      ids = [ "${k530.vendor}:${k530.product}" ];

      settings = {
        main.capslock = "toggle(nav)";

        nav = {
          w = "up";
          a = "left";
          s = "down";
          d = "right";
        };

        # escape hatches: real caps locking, and hyprland's grp:alt_caps_toggle.
        shift.capslock = "capslock";
        alt.capslock = "capslock";
      };
    };
  };

  # runs as root: /sys/class/leds/*/brightness needs write access, so no
  # ProtectSystem/ProtectKernelTunables here (both remount /sys read-only).
  systemd.services.keyd-led = {
    description = "Mirror the keyd nav layer onto the K530 capslock LED";

    bindsTo = [ "keyd.service" ];
    after = [ "keyd.service" ];
    wantedBy = [ "multi-user.target" ];

    path = [ config.services.keyd.package ];

    serviceConfig = {
      ExecStart = keyd-led;
      Restart = "always";
      RestartSec = 2;

      ProtectHome = true;
      NoNewPrivileges = true;
    };
  };
}
