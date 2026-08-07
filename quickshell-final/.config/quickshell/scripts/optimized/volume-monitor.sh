#!/usr/bin/env bash
# Interrupt-driven Volume Monitor using PulseAudio/PipeWire events
# Replaces polling-based volume.sh (interval: 1)
# Listens to PulseAudio server changes instead of polling pactl
#
# Usage: ./volume-monitor.sh &
# Output: Writes JSON to /tmp/quickshell-volume.json
# Signal: Emits DBus signal when volume state changes

set -euo pipefail

OUTPUT_FILE="${XDG_RUNTIME_DIR:-/tmp}/quickshell-volume.json"

get_volume_info() {
    local mute_status volume_percent icon css_class tooltip_text

    # Get default sink info
    mute_status=$(pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null | awk '{print $2}')
    volume_percent=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | grep -oP '\d+%' | head -1 | tr -d '%')

    # Handle cases where pactl fails
    mute_status=${mute_status:-"no"}
    volume_percent=${volume_percent:-0}

    # Determine icon and CSS class based on volume level (matching Waybar's 5-block gauge)
    if [[ "$mute_status" == "yes" ]]; then
        icon="󰖁"
        css_class="volume-mute"
        tooltip_text="Volume: Muted"
    elif [[ "$volume_percent" -eq 0 ]]; then
        icon="󰖁"
        css_class="volume-mute"
        tooltip_text="Volume: 0%"
    elif [[ "$volume_percent" -lt 25 ]]; then
        icon="󰕿"
        css_class="volume-low"
        tooltip_text="Volume: ${volume_percent}%"
    elif [[ "$volume_percent" -lt 50 ]]; then
        icon="󰖀"
        css_class="volume-med-low"
        tooltip_text="Volume: ${volume_percent}%"
    elif [[ "$volume_percent" -lt 75 ]]; then
        icon="󰕾"
        css_class="volume-med"
        tooltip_text="Volume: ${volume_percent}%"
    elif [[ "$volume_percent" -lt 100 ]]; then
        icon="󰕾"
        css_class="volume-high"
        tooltip_text="Volume: ${volume_percent}%"
    else
        icon="󰕾"
        css_class="volume-max"
        tooltip_text="Volume: ${volume_percent}% (Max)"
    fi

    # Output JSON for Quickshell
    printf '{"text": "%s %s%%", "tooltip": "%s", "class": "%s"}\n' \
        "$icon" "$volume_percent" "$tooltip_text" "$css_class"
}

# Initial output
get_volume_info > "$OUTPUT_FILE"

# Subscribe to PulseAudio server changes (interrupt-driven, event-based)
# pactl subscribe outputs events whenever volume/mute state changes
pactl subscribe 2>/dev/null | \
while read -r line; do
    # Filter for sink-related events (volume changes, mute toggles)
    if echo "$line" | grep -qE "(sink|Sink|#|change)"; then
        # Small delay to ensure the state has fully updated
        sleep 0.1

        # Update the output file
        get_volume_info > "$OUTPUT_FILE"

        # Notify Quickshell via DBus signal
        dbus-send --session --dest="im.shadowarch.Quickshell.Volume" \
                  --type=signal /im/shadowarch/Quickshell/Volume \
                  im.shadowarch.Quickshell.Volume.Updated 2>/dev/null || true
    fi
done
