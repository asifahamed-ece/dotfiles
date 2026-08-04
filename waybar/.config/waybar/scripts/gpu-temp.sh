#!/usr/bin/env bash
# Auto-detects NVIDIA (nvidia-smi) or AMD (sensors) GPU temperature

if command -v nvidia-smi &> /dev/null; then
    temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null)
    if [ -n "$temp" ]; then
        echo "${temp}°C"
        exit 0
    fi
fi

if command -v sensors &> /dev/null; then
    temp=$(sensors 2>/dev/null | grep -Ei "edge|junction" | head -n1 | grep -oP '\+\K[0-9]+(?=\.[0-9]°C)')
    if [ -n "$temp" ]; then
        echo "${temp}°C"
        exit 0
    fi
fi

echo "N/A"
