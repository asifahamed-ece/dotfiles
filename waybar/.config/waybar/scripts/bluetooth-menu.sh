#!/usr/bin/env bash
# Bluetooth connect menu, triggered directly from Waybar's bluetooth
# module — same pattern as network-menu.sh, so no blueman-manager needed.
#
# Wire it up in waybar config:
#   "custom/bluetooth": {
#       "on-click": "~/.config/waybar/scripts/bluetooth-menu.sh",
#       "on-click-right": "blueman-manager"
#   }

ROFI_THEME="$HOME/.config/rofi/bluetooth-menu.rasi"
menu_theme_args=()
[ -f "$ROFI_THEME" ] && menu_theme_args=(-theme "$ROFI_THEME")

# U+2028 (LINE SEPARATOR) — same trick as network-menu.sh: forces a visual
# line break inside one pango-markup entry (device name on top, status +
# full MAC smaller underneath) without splitting it into a separate rofi
# entry, since rofi only splits stdin on real \n.
LS=$'\u2028'

powered=$(bluetoothctl show 2>/dev/null | grep -oP 'Powered:\s*\K(yes|no)')

if [ "$powered" != "yes" ]; then
    chosen=$(printf "%s\n" "󰂯 Enable Bluetooth" | rofi -dmenu -i -p "Bluetooth" -l 1 "${menu_theme_args[@]}")
    [ "$chosen" = "󰂯 Enable Bluetooth" ] && bluetoothctl power on && notify-send -t 2000 "Bluetooth" "Powered on"
    exit 0
fi

scan_entry="󰑐 Scan for new devices (4s)"
toggle_entry="󰂲 Disable Bluetooth"

# --- Latency fix ---
# The old version blocked on a 4s scan every single time the menu opened.
# Now the menu opens INSTANTLY showing paired + already-visible devices
# (bluetoothctl devices is just a local cache lookup, no radio activity),
# and scanning for brand-new devices is an explicit opt-in row instead of
# a mandatory wait.
build_menu() {
    paired=$(bluetoothctl devices Paired 2>/dev/null | cut -d' ' -f2)
    connected=$(bluetoothctl devices Connected 2>/dev/null | cut -d' ' -f2)

    bluetoothctl devices 2>/dev/null | while IFS= read -r line; do
        [ -z "$line" ] && continue
        mac=$(echo "$line" | awk '{print $2}')
        name=$(echo "$line" | cut -d' ' -f3-)
        name_esc=$(printf '%s' "$name" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')

        if echo "$connected" | grep -qxF "$mac"; then
            status="Connected"
        elif echo "$paired" | grep -qxF "$mac"; then
            status="Paired"
        else
            status="New"
        fi

        printf "<b>%s</b>%s<span size=\"small\" alpha=\"70%%\">  %s  ·  %s</span>\n" "$name_esc" "$LS" "$status" "$mac"
    done
}

device_lines=$(build_menu)
device_count=$(printf "%s\n" "$device_lines" | grep -c .)
list_lines=$(( device_count + 2 ))  # +2 for scan row + toggle row
[ "$list_lines" -gt 8 ] && list_lines=8

chosen=$(printf "%s\n%s\n%s\n" "$scan_entry" "$toggle_entry" "$device_lines" \
    | sed '/^$/d' \
    | rofi -dmenu -i -p "Bluetooth" -l "$list_lines" -markup-rows "${menu_theme_args[@]}")

[ -z "$chosen" ] && exit 0

if [ "$chosen" = "$toggle_entry" ]; then
    bluetoothctl power off
    notify-send -t 2000 "Bluetooth" "Powered off"
    exit 0
fi

if [ "$chosen" = "$scan_entry" ]; then
    notify-send -t 2000 "Bluetooth" "Scanning for devices..." 2>/dev/null
    bluetoothctl --timeout 4 scan on > /dev/null 2>&1
    exec "$0"   # reopen the menu with the freshly discovered devices
fi

# The chosen entry is the exact multi-line markup string. The device name
# is everything before the U+2028 break; the MAC is the last field on the
# smaller status line after it, with pango tags stripped back out.
title_line="${chosen%%"$LS"*}"
detail_line="${chosen#*"$LS"}"
name=$(printf '%s' "$title_line" | sed -E 's/<[^>]+>//g; s/&amp;/\&/g; s/&lt;/</g; s/&gt;/>/g')
detail_plain=$(printf '%s' "$detail_line" | sed -E 's/<[^>]+>//g')
mac=$(printf '%s' "$detail_plain" | grep -oE '([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}')
status=$(printf '%s' "$detail_plain" | grep -oE 'Connected|Paired|New')

if [ -z "$mac" ]; then
    notify-send "Bluetooth" "Could not parse device."
    exit 1
fi

if [ "$status" = "Connected" ]; then
    bluetoothctl disconnect "$mac" > /dev/null 2>&1
    notify-send "Bluetooth" "Disconnected from \"$name\""
else
    if [ "$status" = "New" ]; then
        bluetoothctl pair "$mac" > /dev/null 2>&1
        bluetoothctl trust "$mac" > /dev/null 2>&1
    fi
    if bluetoothctl connect "$mac" 2>&1 | grep -qi "successful"; then
        notify-send "Bluetooth Connected" "Connected to \"$name\""
    else
        notify-send -u critical "Bluetooth" "Failed to connect to \"$name\""
    fi
fi
