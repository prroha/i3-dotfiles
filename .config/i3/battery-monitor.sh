#!/bin/bash
# Battery monitor: warn at 15%, auto-suspend at 7%

WARN_LEVEL=15
SUSPEND_LEVEL=7
WARNED=false

while true; do
    BAT=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || cat /sys/class/power_supply/BAT1/capacity 2>/dev/null)
    STATUS=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null || cat /sys/class/power_supply/BAT1/status 2>/dev/null)

    if [ -z "$BAT" ] || [ "$STATUS" = "Charging" ] || [ "$STATUS" = "Full" ]; then
        WARNED=false
        sleep 300
        continue
    fi

    if [ "$BAT" -le "$SUSPEND_LEVEL" ]; then
        notify-send -u critical "Battery Critical" "Battery at ${BAT}%. Suspending in 10 seconds..."
        sleep 10
        systemctl suspend
    elif [ "$BAT" -le "$WARN_LEVEL" ] && [ "$WARNED" = false ]; then
        notify-send -u critical "Battery Low" "Battery at ${BAT}%. Plug in your charger."
        WARNED=true
    fi

    sleep 60
done
