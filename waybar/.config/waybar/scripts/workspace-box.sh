#!/usr/bin/env bash
# Single-box workspace indicator for waybar.
# Instead of one button per workspace, this prints ONLY the active
# workspace's number as JSON. Waybar polls this on an interval (see config).

id=$(hyprctl activeworkspace -j 2>/dev/null | grep -oP '"id":\s*\K[0-9]+')

if [ -z "$id" ]; then
    id="?"
fi

echo "{\"text\":\"$id\",\"tooltip\":\"Workspace $id\",\"class\":\"ws-$id\"}"
