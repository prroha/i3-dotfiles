#!/bin/bash
chosen=$(echo -e "Lock\nSuspend\nLogout\nReboot\nShutdown" | rofi -dmenu -p "Power" -theme-str 'window {width: 200px;} listview {lines: 5;}')

case "$chosen" in
    Lock) ~/.config/i3/lock.sh ;;
    Suspend) systemctl suspend ;;
    Logout) i3-msg exit ;;
    Reboot) systemctl reboot ;;
    Shutdown) systemctl poweroff ;;
esac
