#!/bin/bash
# Kill existing polybar instances
killall -q polybar
# Wait for processes to shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.2; done

# Auto-detect monitor: prefer primary, then first connected
if [ -z "$MONITOR" ]; then
    MONITOR=$(xrandr --query | grep " connected primary" | cut -d" " -f1)
    MONITOR=${MONITOR:-$(xrandr --query | grep " connected" | head -1 | cut -d" " -f1)}
fi

# Launch
MONITOR=$MONITOR polybar main 2>&1 | tee /tmp/polybar.log & disown
