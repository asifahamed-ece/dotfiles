#!/usr/bin/env bash
# Requires lm_sensors: sudo pacman -S lm_sensors && sudo sensors-detect

if ! command -v sensors &> /dev/null; then
    echo "N/A"
    exit 0
fi

temp=$(sensors 2>/dev/null | grep -E "Package id 0|Tctl|Tdie" | head -n1 | grep -oP '\+\K[0-9]+(?=\.[0-9]°C)')

if [ -z "$temp" ]; then
    echo "N/A"
else
    echo "${temp}°C"
fi
