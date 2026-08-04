#!/bin/bash
# Vertical 5-block volume gauge, styled the same way as battery.sh
# Uses rising unicode block heights (▁▂▃▄▅▆▇█) per 20% step, bracketed like battery.

vol=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | sed 's/%//')
mute=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')

if [ -z "$vol" ]; then vol=0; fi

if [ "$mute" = "yes" ]; then
    echo '{"text":"[░░░░░]","tooltip":"Muted","class":"volume-mute"}'
    exit 0
fi

# 5 fixed slots (0-20%, 20-40%, ... 80-100%). Slots fully below the current
# volume are full-height blocks, slots fully above are empty, and the ONE
# slot currently being filled shows a proportional-height glyph — this is
# the actual "step increase" look (was previously just a flat block fill
# that read the same as the battery bar).
levels=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)
bar=""
for i in 1 2 3 4 5; do
    slot_min=$(( (i - 1) * 20 ))
    slot_max=$(( i * 20 ))
    if [ "$vol" -ge "$slot_max" ]; then
        bar+="█"
    elif [ "$vol" -le "$slot_min" ]; then
        bar+="░"
    else
        step=$(( (vol - slot_min) * 8 / 20 ))
        (( step > 7 )) && step=7
        (( step < 0 )) && step=0
        bar+="${levels[$step]}"
    fi
done
bar="[${bar}]"

if [ "$vol" -le 20 ]; then
    class="volume-low"
elif [ "$vol" -le 40 ]; then
    class="volume-med-low"
elif [ "$vol" -le 70 ]; then
    class="volume-med"
elif [ "$vol" -le 95 ]; then
    class="volume-high"
else
    class="volume-max"
fi

echo "{\"text\": \"$bar\", \"tooltip\": \"Volume: $vol%\", \"class\": \"$class\"}"
