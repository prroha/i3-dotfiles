#!/bin/bash
# Dotfiles installer — symlinks configs to their expected locations
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

link() {
    local src="$DOTFILES/$1"
    local dst="$HOME/$1"
    mkdir -p "$(dirname "$dst")"
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        echo "  backup: $dst -> ${dst}.bak"
        mv "$dst" "${dst}.bak"
    fi
    ln -sf "$src" "$dst"
    echo "  linked: $dst"
}

echo "Installing dotfiles from $DOTFILES"
echo

link .config/i3/config
link .config/i3/lock.sh
link .config/i3/powermenu.sh
link .config/i3/vol-up.sh
link .config/polybar/config.ini
link .config/polybar/launch.sh
link .config/polybar/cpu-mem-bar
link .config/polybar/bri-vol-bar
link .config/polybar/battery-bar
link .config/alacritty/alacritty.toml
link .config/conky/i3-shortcuts.conf
link .config/rofi/config.rasi
link .config/picom/picom.conf
link .config/dunst/dunstrc
link .Xresources

# Nvim — link entire directory
dst="$HOME/.config/nvim"
if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "  backup: $dst -> ${dst}.bak"
    mv "$dst" "${dst}.bak"
fi
ln -sf "$DOTFILES/.config/nvim" "$dst"
echo "  linked: $dst"

echo
echo "Done! Reload i3 with Mod+Shift+r"
echo
echo "Required packages (Fedora):"
echo "  sudo dnf install i3 polybar alacritty conky rofi picom dunst feh brightnessctl flameshot ImageMagick i3lock neovim"
echo "  pip install --user autotiling"
echo "  Install JetBrains Mono: sudo dnf install jetbrains-mono-fonts-all"
