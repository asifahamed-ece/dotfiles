#!/bin/bash
# volume-adjust.sh — bump volume by a signed step, clamped to 0-100%.
# pactl's "set-sink-volume +N%/-N%" has no upper limit (PulseAudio/PipeWire
# allow soft-volume boost past 100%, which just distorts audio), so this
# reads the current level, does the math itself, and clamps before setting.

step="$1"   # e.g. 5 or -5

current=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+(?=%)' | head -1)
[ -z "$current" ] && current=0

new=$(( current + step ))
(( new > 100 )) && new=100
(( new < 0 )) && new=0

pactl set-sink-volume @DEFAULT_SINK@ "${new}%"
