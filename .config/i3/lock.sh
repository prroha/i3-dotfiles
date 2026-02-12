#!/bin/bash
# Take screenshot, blur it, use as lock background
IMG=/tmp/i3lock-bg.png
import -window root "$IMG"
convert "$IMG" -blur 0x8 -fill "#1e1e2e80" -draw "rectangle 0,0,9999,9999" "$IMG"
i3lock -i "$IMG" -e --nofork
rm -f "$IMG"
