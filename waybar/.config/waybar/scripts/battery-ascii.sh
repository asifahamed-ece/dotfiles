#!/usr/bin/env bash
# ASCII bar-gauge battery indicator for waybar (custom/battery, return-type: json)
# Requires: upower
# Thresholds: <=30% = critical (red), <=55% = warning (yellow), else good.

bat_path=$(upower -e 2>/dev/null | grep -m1 'BAT')

if [ -z "$bat_path" ]; then
    echo '{"text":"N/A","tooltip":"No battery detected","class":"unknown"}'
    exit 0
fi

info=$(upower -i "$bat_path")
percent=$(echo "$info" | grep -oP 'percentage:\s*\K[0-9]+')
state=$(echo "$info" | grep -oP 'state:\s*\K[a-zA-Z-]+')

[ -z "$percent" ] && percent=0

blocks=$(( percent / 10 ))
(( blocks > 10 )) && blocks=10
(( blocks < 0 )) && blocks=0
empty_count=$((10 - blocks))

filled=$(printf '█%.0s' $(seq 1 "$blocks" 2>/dev/null) 2>/dev/null)
empty=$(printf '░%.0s' $(seq 1 "$empty_count" 2>/dev/null) 2>/dev/null)

bar="[${filled}${empty}]"

class="good"
if [[ "$state" == "charging" || "$state" == "pending-charge" ]]; then
    class="charging"
    bar="⚡$bar"
elif [ "$percent" -le 30 ]; then
    class="critical"
    bar="🔴$bar"
elif [ "$percent" -le 55 ]; then
    class="warning"
    bar="⚠️$bar"
fi

echo "{\"text\":\"$bar $percent%\",\"tooltip\":\"Battery: $percent% ($state)\",\"class\":\"$class\",\"percentage\":$percent}"
