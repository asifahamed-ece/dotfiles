#!/bin/bash
# Smart Calendar Toggle & Positioner for Hyprland

# 1. Toggle: If it's already running, kill it and exit
if pgrep -x gsimplecal > /dev/null; then
    pkill gsimplecal
    exit 0
fi

# 2. Launch the calendar in the background
gsimplecal &

# 3. Wait a tiny fraction for the window to spawn
sleep 0.15

# 4. Get the width of your currently focused monitor
# (Requires jq. If you don't have it: sudo pacman -S jq)
MON_WIDTH=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .width')

# 5. Calculate the exact X position (Monitor Width - 320px calendar width - 20px margin)
X_POS=$((MON_WIDTH - 340))
Y_POS=42 # 24px Waybar height + 8px margin + 10px gap

# 6. Move the window to the calculated coordinates
hyprctl dispatch movewindowpixel "$X_POS $Y_POS, class:^(gsimplecal)$"
