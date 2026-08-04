#!/usr/bin/env bash
# Clean 5-Block Battery Indicator
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

# Build the bar character by character to avoid duplicates
if [[ "$state" == "charging" || "$state" == "pending-charge" || "$state" == "fully-charged" ]]; then
    # CHARGING: [░░⚡░░] to [████] (always 7 chars total)
    class="charging"
    icon=""

    # Calculate fill level (0-4 blocks total, split around bolt)
    fill_level=$(( percent / 25 ))
    (( fill_level > 4 )) && fill_level=4

    # Position 1-2 (left of bolt), Position 4-5 (right of bolt)
    if [ $fill_level -ge 1 ]; then left1="█"; else left1="░"; fi
    if [ $fill_level -ge 2 ]; then left2="█"; else left2="░"; fi
    if [ $fill_level -ge 3 ]; then right1="█"; else right1="░"; fi
    if [ $fill_level -ge 4 ]; then right2="█"; else right2="░"; fi

    bar="[${left1}${left2}⚡${right1}${right2}]"

else
    # DISCHARGING: [░░░░░] to [█████] (always 7 chars total)
    fill_level=$(( percent / 20 ))
    (( fill_level > 5 )) && fill_level=5
    empty=$((5 - fill_level))

    filled_str=$(printf '█%.0s' $(seq 1 $fill_level 2>/dev/null))
    empty_str=$(printf '░%.0s' $(seq 1 $empty 2>/dev/null))

    bar="[${filled_str}${empty_str}]"

    # Thresholds moved: critical <=30, warning <=55, good above 55
    if [ "$percent" -le 30 ]; then
        class="critical"; icon="🔴"
    elif [ "$percent" -le 55 ]; then
        class="warning"; icon="⚠️"
    else
        class="good"; icon=""
    fi
fi

echo "{\"text\":\"${icon}${bar}\",\"tooltip\":\"Battery: $percent% ($state)\",\"class\":\"$class\",\"percentage\":$percent}"
