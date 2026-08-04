#!/bin/bash

# 1. Use your ACTUAL absolute path
SAVE_DIR="/home/shadow/Pictures/Screenshots"
mkdir -p "$SAVE_DIR"

# 2. Generate filename
FILENAME="Screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"
FILEPATH="$SAVE_DIR/$FILENAME"

# 3. Get the selected area from slurp
GEOMETRY=$(slurp)

# 4. If user cancels slurp (presses Esc or Right Click), exit silently
if [ -z "$GEOMETRY" ]; then
    exit 0
fi

# 5. Take the screenshot using grim
grim -g "$GEOMETRY" "$FILEPATH"

# 6. Verify the file was actually created before copying
if [ -f "$FILEPATH" ]; then
    # Copy to clipboard
    wl-copy < "$FILEPATH"
    
    # Send notification via SwayNC
    notify-send -i "$FILEPATH" "Screenshot Saved" "$FILENAME"
else
    notify-send "Screenshot Failed" "Grim failed to save the image."
fi
