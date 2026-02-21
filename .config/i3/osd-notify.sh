#!/bin/bash
# OSD notification for brightness and volume changes
# Usage: osd-notify.sh brightness|volume

type="$1"

get_bar() {
    local pct=$1
    local filled=$((pct / 5))
    local empty=$((20 - filled))
    local bar=""
    for ((i = 0; i < filled; i++)); do bar+="█"; done
    for ((i = 0; i < empty; i++)); do bar+="░"; done
    echo "$bar"
}

if [ "$type" = "brightness" ]; then
    pct=$(brightnessctl -m | awk -F, '{print $4}' | tr -d '%')
    bar=$(get_bar "$pct")
    icon="display-brightness-symbolic"
    notify-send -a "osd" -h string:x-dunst-stack-tag:osd \
        -h int:value:"$pct" -i "$icon" -t 1500 \
        "Brightness: ${pct}%" "$bar"

elif [ "$type" = "volume" ]; then
    muted=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
    if [ "$muted" = "yes" ]; then
        icon="audio-volume-muted-symbolic"
        notify-send -a "osd" -h string:x-dunst-stack-tag:osd \
            -i "$icon" -t 1500 "Volume: Muted" "░░░░░░░░░░░░░░░░░░░░"
    else
        pct=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 | tr -d '%')
        bar=$(get_bar "$pct")
        if [ "$pct" -le 33 ]; then
            icon="audio-volume-low-symbolic"
        elif [ "$pct" -le 66 ]; then
            icon="audio-volume-medium-symbolic"
        else
            icon="audio-volume-high-symbolic"
        fi
        notify-send -a "osd" -h string:x-dunst-stack-tag:osd \
            -h int:value:"$pct" -i "$icon" -t 1500 \
            "Volume: ${pct}%" "$bar"
    fi
fi
