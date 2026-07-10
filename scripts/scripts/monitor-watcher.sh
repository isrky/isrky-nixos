#!/usr/bin/env bash

# based on https://github.com/ash-17/omarchy-external-monitor/tree/d06a323e7fb39d73be3955b94305830bfdc4a74a

# keeps both monitors active and pins workspaces 6-10 to the external
# monitor (detected at runtime); 1-5 are pinned to eDP-1 statically
# in the nix config

INTERNAL="eDP-1"
EXTERNAL_WORKSPACES="6 7 8 9 10"

restart-apps() {
    # restart wallpaper
    pkill .awww-daemon-wr 2> /dev/null
    init-wallpaper &

    # restart waybar
    pkill .waybar-wrapped 2> /dev/null
    waybar &

    # restart swayosd (crashes on monitor change)
    pkill .swayosd-server 2> /dev/null
    swayosd-server &
}

handle-monitor-state() {
    # name of the first external monitor (HDMI-* or DP-*), if any
    external=$(hyprctl monitors | awk '/^Monitor (HDMI-|DP-)/ {print $2; exit}')

    if [ -n "$external" ]; then
        # bind workspaces 6-10 to the external monitor and move them over
        for ws in $EXTERNAL_WORKSPACES; do
            hyprctl keyword workspace "$ws, monitor:$external" > /dev/null
            hyprctl dispatch moveworkspacetomonitor "$ws" "$external" > /dev/null
        done
    else
        # no external monitor: make sure the laptop panel is enabled
        # (hyprland moves orphaned workspaces back automatically)
        hyprctl keyword monitor "$INTERNAL,preferred,auto,1" > /dev/null
        for ws in $EXTERNAL_WORKSPACES; do
            hyprctl keyword workspace "$ws, monitor:$INTERNAL" > /dev/null
        done
    fi
}

# --- startup check --- #
sleep 1

handle-monitor-state
restart-apps

# --- hyprland events listener --- #
socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" |
    while read -r line; do
        # react on external monitor plug/unplug or hyprland reload
        if echo "$line" | grep -qE "monitor(added|removed)>>(HDMI-|DP-)|configreloaded"; then
            sleep 0.5 # let hyprland settle the new monitor
            handle-monitor-state
            restart-apps
        fi
    done
