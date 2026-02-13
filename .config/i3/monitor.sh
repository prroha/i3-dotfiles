#!/bin/bash
# Auto-detect and configure external monitor
# Usage: monitor.sh [left|right|above|mirror|off]

# Auto-detect internal display (eDP-*, LVDS-*)
INTERNAL=$(xrandr | grep -oP '^(eDP|LVDS)-?\d+(?= connected)' | head -1)
INTERNAL="${INTERNAL:-eDP-1}"
EXTERNAL=""

# Find connected external monitor (anything connected that isn't internal)
while read -r output; do
    if [ "$output" != "$INTERNAL" ]; then
        EXTERNAL="$output"
        break
    fi
done < <(xrandr | grep ' connected' | awk '{print $1}')

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
