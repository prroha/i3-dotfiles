#!/bin/bash
# Restart picom with the appropriate config when power source changes
# Triggered by udev rule on AC plug/unplug

# Find the logged-in user on the display
USER=$(who | awk '/\(:0\)/ {print $1; exit}')
[ -z "$USER" ] && exit 0

HOME_DIR=$(getent passwd "$USER" | cut -d: -f6)
[ -z "$HOME_DIR" ] && exit 0

export DISPLAY=:0
export XAUTHORITY="$HOME_DIR/.Xauthority"

STATUS=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null || cat /sys/class/power_supply/BAT1/status 2>/dev/null)

su "$USER" -c "killall -q -w picom"

if [ "$STATUS" = "Discharging" ]; then
    su "$USER" -c "picom --config $HOME_DIR/.config/picom/picom-battery.conf -b"
else
    su "$USER" -c "picom --config $HOME_DIR/.config/picom/picom.conf -b"
fi
