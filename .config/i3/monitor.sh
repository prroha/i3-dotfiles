#!/bin/bash
# Auto-detect and configure external monitor
# Usage: monitor.sh [left|right|above|mirror|off]

INTERNAL="eDP-1"
EXTERNAL=""

# Find connected external monitor
for output in HDMI-1 DP-1 DP-2 DP-3 DP-4; do
    if xrandr | grep "^$output connected" &>/dev/null; then
        EXTERNAL="$output"
        break
    fi
done

if [ -z "$EXTERNAL" ]; then
    # No external monitor — ensure internal is on
    xrandr --output "$INTERNAL" --auto --primary
    notify-send "Monitor" "No external display detected"
    exit 0
fi

MODE="${1:-right}"

case "$MODE" in
    right)
        xrandr --output "$INTERNAL" --auto --primary \
               --output "$EXTERNAL" --auto --right-of "$INTERNAL"
        ;;
    left)
        xrandr --output "$INTERNAL" --auto --primary \
               --output "$EXTERNAL" --auto --left-of "$INTERNAL"
        ;;
    above)
        xrandr --output "$INTERNAL" --auto --primary \
               --output "$EXTERNAL" --auto --above "$INTERNAL"
        ;;
    mirror)
        xrandr --output "$INTERNAL" --auto --primary \
               --output "$EXTERNAL" --auto --same-as "$INTERNAL"
        ;;
    off)
        xrandr --output "$EXTERNAL" --off \
               --output "$INTERNAL" --auto --primary
        ;;
    *)
        echo "Usage: monitor.sh [left|right|above|mirror|off]"
        exit 1
        ;;
esac

notify-send "Monitor" "$EXTERNAL: $MODE"
