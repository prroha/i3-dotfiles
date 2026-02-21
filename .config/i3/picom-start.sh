#!/bin/bash
# Launch picom with full effects on AC, minimal on battery
STATUS=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null || cat /sys/class/power_supply/BAT1/status 2>/dev/null)

if [ "$STATUS" = "Discharging" ]; then
    picom --config ~/.config/picom/picom-battery.conf -b
else
    picom --config ~/.config/picom/picom.conf -b
fi
