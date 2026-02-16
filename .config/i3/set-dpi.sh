#!/bin/bash
# Auto-detect DPI based on screen resolution and set Xresources + cursor size
# 1080p → 96 DPI, 1440p/2K → 144 DPI, 4K → 192 DPI

RES_HEIGHT=$(xrandr | grep '\*' | head -1 | awk '{print $1}' | cut -d'x' -f2)

if [ "$RES_HEIGHT" -ge 2160 ] 2>/dev/null; then
    DPI=192
    CURSOR=48
    GDK_SCALE=1
elif [ "$RES_HEIGHT" -ge 1440 ] 2>/dev/null; then
    DPI=144
    CURSOR=32
    GDK_SCALE=1.2
else
    DPI=96
    CURSOR=24
    GDK_SCALE=1
fi

# Write GTK/Qt scaling env vars for the session
# Sourced by .xprofile before i3 starts, and by resume-hook after wake
export GDK_DPI_SCALE=$GDK_SCALE
export QT_SCALE_FACTOR=$GDK_SCALE

# Set X server DPI so polybar (dpi=0) and GTK/browser apps pick it up
xrandr --dpi "$DPI" 2>/dev/null

# Apply to Xresources
xrdb -merge <<EOF
Xft.dpi: $DPI
Xft.autohint: 0
Xft.lcdfilter: lcddefault
Xft.hintstyle: hintfull
Xft.hinting: 1
Xft.antialias: 1
Xft.rgba: rgb
Xcursor.theme: catppuccin-mocha-blue-cursors
Xcursor.size: $CURSOR
EOF

echo "$DPI"
