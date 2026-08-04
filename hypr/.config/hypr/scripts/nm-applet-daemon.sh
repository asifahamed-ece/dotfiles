#!/usr/bin/env bash
# Autostarted by hyprland.lua via hl.exec_once("~/.config/hypr/scripts/nm-applet-daemon.sh")
#
# nm-applet can fail silently (no tray icon, no error) if it launches before
# a system tray actually exists to dock into. Waybar's tray module needs a
# moment to come up first, so we wait for it rather than racing it.

# Wait up to ~10s for waybar (and therefore its tray) to be ready
for i in {1..20}; do
    if pgrep -x waybar >/dev/null; then
        break
    fi
    sleep 0.5
done

# Don't spawn a second instance if one's already running
if pgrep -x nm-applet >/dev/null; then
    exit 0
fi

exec nm-applet --indicator
