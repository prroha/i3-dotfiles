#!/bin/bash
vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 | tr -d '%')
if [ "$vol" -lt 100 ]; then
    new=$((vol + 10))
    [ "$new" -gt 100 ] && new=100
    pactl set-sink-volume @DEFAULT_SINK@ ${new}%
fi
polybar-msg action brivol hook 0 &
~/.config/i3/osd-notify.sh volume &
