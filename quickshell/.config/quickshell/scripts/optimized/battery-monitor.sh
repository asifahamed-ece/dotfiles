#!/usr/bin/env bash
# Interrupt-driven Battery Monitor using DBus signals
# Replaces polling-based battery.sh (interval: 10)
# Listens to UPower DBus signals instead of reading /sys/class/power_supply in a loop

set -u

OUTPUT_FILE="${XDG_RUNTIME_DIR:-/tmp}/quickshell-battery.json"

# Catppuccin colors for reference
COLOR_GOOD="#a6e3a1"
COLOR_WARNING="#fab387"
COLOR_CRITICAL="#f38ba8"
COLOR_CHARGING="#f9e2af"

get_battery_info() {
    # Single read using upower (more reliable than parsing sysfs)
    local bat_path="/org/freedesktop/UPower/devices/battery_BAT0"
    
    if ! upower -i "$bat_path" &>/dev/null; then
        # No battery detected (desktop mode)
        echo '{"text": "󰚥", "tooltip": "No battery detected", "class": "no-battery"}'
        return
    fi
    
    local percentage
    local state
    local time_remaining
    
    percentage=$(upower -i "$bat_path" | grep -E "percentage:" | awk '{print $2}' | tr -d '%')
    state=$(upower -i "$bat_path" | grep -E "state:" | awk '{print $2}')
    time_remaining=$(upower -i "$bat_path" | grep -E "time to (empty|full):" | awk '{$1=$2=$3=""; print $0}' | xargs)
    
    local icon
    local css_class
    local tooltip_text
    
    # Determine icon based on percentage (matching Waybar's battery.sh)
    if [[ "$percentage" -ge 90 ]]; then
        icon="󰁹"
    elif [[ "$percentage" -ge 80 ]]; then
        icon="󰂀"
    elif [[ "$percentage" -ge 70 ]]; then
        icon="󰂁"
    elif [[ "$percentage" -ge 60 ]]; then
        icon="󰂂"
    elif [[ "$percentage" -ge 50 ]]; then
        icon="󰂃"
    elif [[ "$percentage" -ge 40 ]]; then
        icon="󰂄"
    elif [[ "$percentage" -ge 30 ]]; then
        icon="󰂅"
    elif [[ "$percentage" -ge 20 ]]; then
        icon="󰂆"
    elif [[ "$percentage" -ge 10 ]]; then
        icon="󰂇"
    else
        icon="󰂈"
    fi
    
    # Determine state and CSS class
    case "$state" in
        "charging")
            css_class="charging"
            tooltip_text="Charging: ${percentage}%\nTime to full: ${time_remaining}"
            ;;
        "fully-charged")
            css_class="plugged"
            tooltip_text="Fully charged"
            ;;
        "discharging")
            if [[ "$percentage" -le 10 ]]; then
                css_class="critical"
            elif [[ "$percentage" -le 30 ]]; then
                css_class="warning"
            else
                css_class="discharging"
            fi
            tooltip_text="Discharging: ${percentage}%\nTime remaining: ${time_remaining}"
            ;;
        *)
            css_class="good"
            tooltip_text="Battery: ${percentage}%"
            ;;
    esac
    
    # Add charging bolt icon if applicable
    if [[ "$state" == "charging" ]]; then
        icon="${icon} 󰢟"
    fi
    
    # Output JSON for Quickshell
    printf '{"text": "%s %s%%", "tooltip": "%s", "class": "%s"}\n' \
        "$icon" "$percentage" "$tooltip_text" "$css_class"
}

# Initial output
get_battery_info > "$OUTPUT_FILE"

# Listen to DBus signals from UPower (interrupt-driven, zero CPU when idle)
# This blocks until a signal is received, then triggers an update
dbus-monitor --system "interface='org.freedesktop.DBus.Properties',path='/org/freedesktop/UPower/devices/battery_BAT0'" 2>/dev/null | \
while read -r line; do
    # Signal received - update the output
    get_battery_info > "$OUTPUT_FILE"
    
    # Quickshell watches this file for changes via QMFileSystemWatcher
    # or we can emit a DBus signal to notify Quickshell directly
    dbus-send --session --dest="im.shadowarch.Quickshell.Battery" \
              --type=signal /im/shadowarch/Quickshell/Battery \
              im.shadowarch.Quickshell.Battery.Updated 2>/dev/null
done
