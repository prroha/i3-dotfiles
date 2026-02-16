#!/bin/bash
# Re-apply DPI and restart affected apps after resume from sleep
# Listens for systemd's PrepareForSleep D-Bus signal

dbus-monitor --system "type='signal',interface='org.freedesktop.login1.Manager',member='PrepareForSleep'" 2>/dev/null |
while read -r line; do
    # "boolean false" means system just woke up (sleep ended)
    if echo "$line" | grep -q "boolean false"; then
        sleep 2  # let display fully settle
        ~/.config/i3/set-dpi.sh >/dev/null 2>&1
        ~/.config/polybar/launch.sh >/dev/null 2>&1  # restart polybar with new DPI
        i3-msg reload >/dev/null 2>&1                 # reload i3 for font scaling
    fi
done
