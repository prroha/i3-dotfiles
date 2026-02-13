#!/bin/bash
# Auto-detect and configure external monitor
# Usage: monitor.sh [left|right|above|mirror|off]

# Auto-detect internal display (eDP-*, LVDS-*, including NVIDIA Optimus eDP-1-1)
INTERNAL=$(xrandr | grep -oP '^(eDP|LVDS)-?[\d-]+(?= connected)' | head -1)

if [ -z "$INTERNAL" ]; then
    # Desktop (no eDP/LVDS) — use the primary monitor as "internal"
    INTERNAL=$(xrandr | grep " connected primary" | cut -d" " -f1)
    INTERNAL=${INTERNAL:-$(xrandr | grep " connected" | head -1 | cut -d" " -f1)}
fi

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

# Pin workspace 5 to external monitor
if [ "$MODE" != "off" ]; then
    i3-msg "workspace number 5 output $EXTERNAL" 2>/dev/null
fi

notify-send "Monitor" "$EXTERNAL: $MODE"
