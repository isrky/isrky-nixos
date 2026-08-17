{
  config,
  lib,
  pkgs,
  ...
}:
let
  # keyboards that borrow wasd for arrows. `sudo keyd monitor` prints the ids.
  ids = [
    "25a7:fa70" # redragon k530, compx 2.4g dongle
    "046d:b377" # logitech pebble keys 2 k380s, bluetooth
  ];

  # keyd listen emits +<layer>/-<layer> on every layer change. mirror the nav
  # layer onto the caps leds, and onto waybar for boards without a caps light.
  keyd-led = pkgs.writeShellScript "keyd-led" ''
    IDS="${lib.concatStringsSep " " ids}"
    STATE=/run/keyd-nav/state

    set_leds() {
        for l in /sys/class/leds/*::capslock; do
            d=$(readlink -f "$l/device" 2> /dev/null) || continue
            id="$(cat "$d/id/vendor" 2> /dev/null):$(cat "$d/id/product" 2> /dev/null)"
            case " $IDS " in
                *" $id "*) printf '%s' "$1" > "$l/brightness" 2> /dev/null || true ;;
            esac
        done
    }

    publish() {
        if [ "$1" = 1 ]; then
            printf '1' > "$STATE"
        else
            : > "$STATE"
        fi
        pkill -RTMIN+8 waybar || true
    }

    # keyd binds its ipc socket a moment after the unit starts; wait for it
    # instead of dying and leaning on Restart=always.
    while [ ! -S /var/run/keyd.socket ]; do
        sleep 0.2
    done

    state=0
    publish "$state"
    set_leds "$state"

    keyd listen | while read -r ev; do
        case "$ev" in
            +nav)
                state=1
                publish "$state"
                ;;
            -nav)
                state=0
                publish "$state"
                ;;
        esac

        # re-assert on every layer event, not just +nav/-nav: keyd mirrors the
        # compositor's led writes onto the grabbed device and would clear ours.
        set_leds "$state"
    done
  '';
in
{
  # the k530 has no arrow cluster and the k380s' arrows are cramped, so
  # capslock toggles a layer where wasd are arrows. led on = arrows.
  services.keyd = {
    enable = true;

    keyboards.arrows = {
      inherit ids;

      settings = {
        main.capslock = "toggle(nav)";

        nav = {
          w = "up";
          a = "left";
          s = "down";
          d = "right";
        };

        # escape hatch: bare capslock is the layer toggle, so alt+capslock is
        # what actually locks caps.
        alt.capslock = "capslock";
      };
    };
  };

  # runs as root: /sys/class/leds/*/brightness needs write access, so no
  # ProtectSystem/ProtectKernelTunables here (both remount /sys read-only).
  systemd.services.keyd-led = {
    description = "Mirror the keyd nav layer onto the keyboard LEDs and waybar";

    bindsTo = [ "keyd.service" ];
    after = [ "keyd.service" ];
    wantedBy = [ "multi-user.target" ];

    path = [
      config.services.keyd.package
      pkgs.procps
    ];

    serviceConfig = {
      ExecStart = keyd-led;
      Restart = "always";
      RestartSec = 2;

      # world-readable /run/keyd-nav so waybar can read the state file
      RuntimeDirectory = "keyd-nav";

      ProtectHome = true;
      NoNewPrivileges = true;
    };
  };
}
