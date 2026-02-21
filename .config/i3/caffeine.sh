#!/bin/bash
# Inhibit screen blanking/DPMS when a fullscreen window is active
# (e.g. watching videos in a browser or media player)

while true; do
    sleep 60
    # Check if any window is fullscreen on the focused monitor
    if xprop -root _NET_ACTIVE_WINDOW 2>/dev/null | grep -q "0x"; then
        wid=$(xprop -root _NET_ACTIVE_WINDOW | awk '{print $NF}')
        if [ "$wid" != "0x0" ] && xprop -id "$wid" _NET_WM_STATE 2>/dev/null | grep -q "_NET_WM_STATE_FULLSCREEN"; then
            xdg-screensaver reset 2>/dev/null
            xset s reset 2>/dev/null
        fi
    fi
done
