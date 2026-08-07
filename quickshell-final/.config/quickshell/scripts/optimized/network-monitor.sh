#!/usr/bin/env bash
# Interrupt-driven Network Monitor using NetworkManager DBus signals
# Replaces polling-based network.sh (interval: 3)
# Listens to NetworkManager PropertyChanges instead of polling nmcli
#
# Usage: ./network-monitor.sh &
# Output: Writes JSON to /tmp/quickshell-network.json
# Signal: Emits DBus signal when network state changes

set -euo pipefail

OUTPUT_FILE="${XDG_RUNTIME_DIR:-/tmp}/quickshell-network.json"

get_network_info() {
    local primary_conn device_type state ssid icon css_class tooltip_text signal_strength

    # Get primary active connection type
    primary_conn=$(nmcli -g GENERAL.STATE,GENERAL.DEVICE,GENERAL.TYPE connection show --active 2>/dev/null | head -3)

    if [[ -z "$primary_conn" ]]; then
        # No active connection
        echo '{"text": "󰖪", "tooltip": "No network connection", "class": "wifi-off"}'
        return 0
    fi

    # Check for WiFi first, then Ethernet
    if nmcli device status 2>/dev/null | grep -q "wifi.*connected"; then
        device_type="wifi"
        ssid=$(nmcli -g general.ssid connection show --active 2>/dev/null | head -1)
        state=$(nmcli -g general.state connection show --active 2>/dev/null | head -1)

        # Get signal strength
        signal_strength=$(nmcli -f ACTIVE,SIGNAL dev wifi 2>/dev/null | grep "^yes" | awk '{print $2}' | tr -d '%')
        signal_strength=${signal_strength:-0}

        # Determine icon based on signal strength (matching Waybar style)
        if [[ "$signal_strength" -ge 80 ]]; then
            icon="󰤨"
        elif [[ "$signal_strength" -ge 60 ]]; then
            icon="󰤥"
        elif [[ "$signal_strength" -ge 40 ]]; then
            icon="󰤢"
        elif [[ "$signal_strength" -ge 20 ]]; then
            icon="󰤟"
        else
            icon="󰤜"
        fi

        css_class="wifi-connected"
        tooltip_text="WiFi: ${ssid}\nSignal: ${signal_strength}%\nStatus: ${state}"

    elif nmcli device status 2>/dev/null | grep -q "ethernet.*connected"; then
        device_type="ethernet"
        icon="󰈀"
        css_class="ethernet-connected"
        tooltip_text="Ethernet: Connected"

    else
        # WiFi exists but not connected
        icon="󰖪"
        css_class="wifi-off"
        tooltip_text="WiFi: Disconnected"
    fi

    # Output JSON for Quickshell
    printf '{"text": "%s", "tooltip": "%s", "class": "%s"}\n' \
        "$icon" "$tooltip_text" "$css_class"
}

# Initial output
get_network_info > "$OUTPUT_FILE"

# Listen to DBus signals from NetworkManager (interrupt-driven)
# Monitors PropertiesChanged signals for active connections and device state
dbus-monitor --system "interface='org.freedesktop.DBus.Properties',path='/org/freedesktop/NetworkManager'" 2>/dev/null | \
while read -r line; do
    # Filter relevant signals (connection state changes, device changes)
    if echo "$line" | grep -qE "(State|PrimaryConnection|ActiveConnections|Devices)"; then
        # Small delay to ensure state has fully updated
        sleep 0.1
        
        # Signal received - update the output
        get_network_info > "$OUTPUT_FILE"

        # Notify Quickshell via DBus signal
        dbus-send --session --dest="im.shadowarch.Quickshell.Network" \
                  --type=signal /im/shadowarch/Quickshell/Network \
                  im.shadowarch.Quickshell.Network.Updated 2>/dev/null || true
    fi
done &

NM_MONITOR_PID=$!

# Also monitor device-specific signals
dbus-monitor --system "interface='org.freedesktop.DBus.Properties',path='/org/freedesktop/NetworkManager/Devices'" 2>/dev/null | \
while read -r line; do
    if echo "$line" | grep -qE "(State|IpAddress|WirelessProperties)"; then
        sleep 0.1
        get_network_info > "$OUTPUT_FILE"

        dbus-send --session --dest="im.shadowarch.Quickshell.Network" \
                  --type=signal /im/shadowarch/Quickshell/Network \
                  im.shadowarch.Quickshell.Network.Updated 2>/dev/null || true
    fi
done

# Cleanup on exit
trap "kill $NM_MONITOR_PID 2>/dev/null" EXIT
