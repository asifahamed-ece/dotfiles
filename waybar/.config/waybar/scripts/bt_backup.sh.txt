#!/bin/bash
# Bluetooth status for waybar's custom/bluetooth module — mirrors network.sh
# so it behaves and looks like the WiFi module (click opens a rofi menu
# instead of blueman-manager).

powered=$(bluetoothctl show 2>/dev/null | grep -oP 'Powered:\s*\K(yes|no)')

if [ "$powered" != "yes" ]; then
    # Bluetooth OFF -> red icon
    printf '{"text": "\uf5ac", "tooltip": "Bluetooth: Off\\nClick to manage", "class": "bt-off"}\n'
    exit 0
fi

connected_count=$(bluetoothctl devices Connected 2>/dev/null | wc -l)

if [ "$connected_count" -gt 0 ]; then
    connected_names=$(bluetoothctl devices Connected 2>/dev/null | cut -d' ' -f3- | tr '\n' ',' | sed 's/,$//')
    # Bluetooth CONNECTED -> filled icon + count
    printf '{"text": "\uf293 %s", "tooltip": "Connected: %s\\nClick to manage", "class": "bt-connected"}\n' \
        "$connected_count" "$connected_names"
else
    # Bluetooth ON, nothing connected -> outline icon
    printf '{"text": "\uf294", "tooltip": "Bluetooth: On, no devices connected\\nClick to manage", "class": "bt-on"}\n'
fi
