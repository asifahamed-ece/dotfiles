#!/bin/bash
# Lenovo LOQ Power Mode Selector (Right-Anchored Dropdown)

# --x 40 means "40 pixels from the right edge of the screen"
# Removed --height so it auto-sizes to the 3 items (no scrolling!)
CHOICE=$(echo -e "😈 Soul Ripper\n⚙️ AutoPilot\n🤫 Silent" | wofi --dmenu \
  --style ~/.config/wofi/power-profile.css \
  --prompt "  LOQ Mode" \
  --width 220 \
  --lines 3 \
  --location top-right \
  --x 980 \
  --y 28 \
  --no-actions \
  --insensitive)

case "$CHOICE" in
  "😈 Soul Ripper")
    powerprofilesctl set performance
    notify-send "LOQ Mode" "😈 Soul Ripper Activated" -i battery-full-charging
    ;;
  "⚙️ AutoPilot")
    powerprofilesctl set balanced
    notify-send "LOQ Mode" "⚙️ AutoPilot Activated" -i battery-good
    ;;
  "🤫 Silent")
    powerprofilesctl set power-saver
    notify-send "LOQ Mode" "🤫 Silent Mode Activated" -i battery-low
    ;;
esac
