#!/bin/bash
wifi_state=$(nmcli radio wifi)

if [ "$wifi_state" = "disabled" ]; then
    # WiFi OFF -> Red & Off Icon (U+F06A) + Fallback "OFF"
    printf '{"text": "\xef\x81\xaa", "class": "wifi-off"}\n'
elif nmcli -t -f active,ssid dev wifi | grep -q "^yes:"; then
    # WiFi CONNECTED -> Green Icon (U+F1EB) + Fallback "ON"
    printf '{"text": "\xef\x87\xab", "class": "wifi-connected"}\n'
else
    # WiFi ON but NOT connected -> White Icon (U+F1EB) + Fallback "WIFI"
    printf '{"text": "\xef\x87\xab", "class": "wifi-on"}\n'
fi
