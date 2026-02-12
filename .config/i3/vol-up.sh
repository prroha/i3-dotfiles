#!/bin/bash
pactl set-sink-volume @DEFAULT_SINK@ +10%
vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 | tr -d '%')
[ "$vol" -gt 100 ] && pactl set-sink-volume @DEFAULT_SINK@ 100%
