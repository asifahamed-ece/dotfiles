#!/usr/bin/env bash
# Wi-Fi scan + connect menu, triggered directly from Waybar's network module.
# No tray icon / nm-applet needed — this talks to NetworkManager via nmcli.
#
# Wire it up in waybar config:
#   "network": {
#       "on-click": "~/.config/waybar/scripts/network-menu.sh",
#       "on-click-right": "nm-connection-editor"
#   }

ROFI_THEME="$HOME/.config/rofi/network-menu.rasi"
menu_theme_args=()
[ -f "$ROFI_THEME" ] && menu_theme_args=(-theme "$ROFI_THEME")

# U+2028 (LINE SEPARATOR) forces a visual line break inside a pango-markup
# cell WITHOUT being a real newline — rofi splits stdin into entries on
# real \n only, so this lets one entry render as two lines (SSID on top,
# smaller security/band/signal line underneath) instead of one long
# fixed-width row that gets ellipsized.
LS=$'\u2028'

notify-send -t 1500 "Wi-Fi" "Scanning for networks..." 2>/dev/null

# --- Latency fix ---
# The old version always passed --rescan yes, which blocks for a full active
# scan (1-3s+) EVERY time you open the menu. If NetworkManager already has a
# non-empty cached list (it refreshes this in the background continuously),
# just use that — instant. Only force a fresh active scan when the cache is
# empty (e.g. right after boot / Wi-Fi just enabled).
if [ "$(nmcli --terse --fields SSID device wifi list 2>/dev/null | grep -c .)" -gt 0 ]; then
    rescan_flag="no"
else
    rescan_flag="yes"
fi

# Includes FREQ so we can label 2.4GHz vs 5GHz. Dedup key is SSID+band (not
# just SSID) — routers commonly broadcast the SAME SSID on both bands (band
# steering), and deduping on SSID alone silently threw away the 5GHz entry.
wifi_list=$(nmcli --terse --fields "SSID,SECURITY,SIGNAL,FREQ" device wifi list --rescan "$rescan_flag" \
    | awk -F: -v LS="$LS" '
        $1 != "" {
            ssid = $1
            gsub(/&/, "\\&amp;", ssid)
            gsub(/</, "\\&lt;", ssid)
            gsub(/>/, "\\&gt;", ssid)

            freq = $4 + 0
            band = (freq >= 5000) ? "5GHz" : "2.4GHz"
            sec  = ($2 == "" ? "Open" : $2)
            key  = $1 "|" band
            if (!seen[key]++) {
                printf "<b>%s</b>%s<span size=\"small\" alpha=\"70%%\">  %s  ·  %s  ·  %s%%</span>\n", ssid, LS, sec, band, $3
            }
        }
    ')

radio_state=$(nmcli -fields WIFI g)
if [[ "$radio_state" =~ enabled ]]; then
    toggle_entry="Disable Wi-Fi"
else
    toggle_entry="Enable Wi-Fi"
fi

# Size the popup to how many networks were actually found. Each entry is
# still exactly one line in the *input stream* (the LS break is invisible
# to line counting), so this count is unaffected by the two-line rendering.
network_count=$(printf "%s\n" "$wifi_list" | grep -c .)
list_lines=$(( network_count + 1 ))  # +1 for the Enable/Disable Wi-Fi row
[ "$list_lines" -gt 8 ] && list_lines=8
[ "$list_lines" -lt 1 ] && list_lines=1

chosen=$(printf "%s\n%s\n" "$toggle_entry" "$wifi_list" \
    | rofi -dmenu -i -p "Wi-Fi" -l "$list_lines" -markup-rows "${menu_theme_args[@]}")

[ -z "$chosen" ] && exit 0

if [ "$chosen" = "Disable Wi-Fi" ]; then
    nmcli radio wifi off
    exit 0
elif [ "$chosen" = "Enable Wi-Fi" ]; then
    nmcli radio wifi on
    exit 0
fi

# The chosen entry is the exact multi-line markup string. The SSID is
# everything before the U+2028 break, with pango tags stripped back out.
title_line="${chosen%%"$LS"*}"
ssid=$(printf '%s' "$title_line" | sed -E 's/<[^>]+>//g; s/&amp;/\&/g; s/&lt;/</g; s/&gt;/>/g')

if [ -z "$ssid" ]; then
    notify-send "Wi-Fi" "Could not parse network name."
    exit 1
fi

saved=$(nmcli -g NAME connection show)

if echo "$saved" | grep -qxF "$ssid"; then
    if nmcli connection up id "$ssid" | grep -qi "successfully"; then
        notify-send "Wi-Fi Connected" "Connected to \"$ssid\""
    else
        notify-send -u critical "Wi-Fi" "Failed to connect to \"$ssid\""
    fi
else
    password=$(rofi -dmenu -p "Password for $ssid" -password -l 0 "${menu_theme_args[@]}")
    [ -z "$password" ] && exit 0

    if nmcli device wifi connect "$ssid" password "$password" | grep -qi "successfully"; then
        notify-send "Wi-Fi Connected" "Connected to \"$ssid\""
    else
        notify-send -u critical "Wi-Fi" "Failed to connect to \"$ssid\" — wrong password?"
    fi
fi
