#!/bin/bash
# Save clipboard image as a file (Windows-style paste)
dir="${1:-$HOME/Downloads}"
mkdir -p "$dir"
ts=$(date +%Y%m%d_%H%M%S)
types=$(wl-paste -l 2>/dev/null)

if echo "$types" | grep -q 'image/png'; then
    wl-paste -t image/png > "$dir/clip_$ts.png"
    notify-send "📋 Clipboard saved" "clip_$ts.png → $dir"
elif echo "$types" | grep -q 'image/jpeg'; then
    wl-paste -t image/jpeg > "$dir/clip_$ts.jpg"
    notify-send "📋 Clipboard saved" "clip_$ts.jpg → $dir"
elif echo "$types" | grep -q 'image/'; then
    wl-paste > "$dir/clip_$ts.png"
    notify-send "📋 Clipboard saved" "clip_$ts.png → $dir"
else
    notify-send "📋 Clipboard" "No image on clipboard"
fi
