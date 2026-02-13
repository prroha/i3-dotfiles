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

mkdir -p ~/.local/bin

# ─── Install packages ───
echo "Installing required packages..."

PACKAGES=(
    i3 polybar alacritty conky rofi picom dunst feh
    brightnessctl flameshot ImageMagick i3lock neovim
    jq zoxide python3-pip
)

# All packages are in default Fedora repos — install in one go
sudo dnf install -y "${PACKAGES[@]}"

# Yazi — not in default repos, install from GitHub
if ! command -v yazi &>/dev/null; then
    echo "  Installing yazi from GitHub..."
    mkdir -p ~/.local/bin
    curl -fL https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip -o /tmp/yazi.zip
    unzip -o /tmp/yazi.zip -d /tmp && cp /tmp/yazi-x86_64-unknown-linux-gnu/{yazi,ya} ~/.local/bin/
    rm -f /tmp/yazi.zip
    echo "  yazi installed"
fi

pip install --user autotiling i3-workspace-names-daemon || echo "  WARNING: pip install failed, try: pip install --user autotiling i3-workspace-names-daemon"

# ─── Install lazydocker ───
if ! command -v lazydocker &>/dev/null; then
    echo "Installing lazydocker..."
    curl -s https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
else
    echo "  lazydocker already installed"
fi

# ─── Install JetBrains Mono Nerd Font ───
if ! fc-list | grep -qi "JetBrainsMono Nerd"; then
    echo "Installing JetBrains Mono Nerd Font..."
    mkdir -p ~/.local/share/fonts
    curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
    tar xf JetBrainsMono.tar.xz -C ~/.local/share/fonts/
    rm -f JetBrainsMono.tar.xz
    fc-cache -f
    echo "  Font installed"
else
    echo "  JetBrains Mono Nerd Font already installed"
fi

echo
echo "Linking config files..."

link .config/i3/config
link .config/i3/lock.sh
link .config/i3/powermenu.sh
link .config/i3/vol-up.sh
link .config/i3/workspace-icons.json
link .config/i3/monitor.sh
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
link .mybashprofile
link .Xresources
link .gtkrc-2.0
link .config/gtk-3.0/settings.ini
link .config/gtk-4.0/settings.ini

# Nvim — link entire directory
dst="$HOME/.config/nvim"
if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "  backup: $dst -> ${dst}.bak"
    mv "$dst" "${dst}.bak"
fi
ln -sf "$DOTFILES/.config/nvim" "$dst"
echo "  linked: $dst"

# LazyVim — link entire directory
dst="$HOME/.config/lazynvim"
if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "  backup: $dst -> ${dst}.bak"
    mv "$dst" "${dst}.bak"
fi
ln -sf "$DOTFILES/.config/lazynvim" "$dst"
echo "  linked: $dst"

# ─── Source mybashprofile from bashrc ───
if ! grep -q 'mybashprofile' ~/.bashrc 2>/dev/null; then
    echo '' >> ~/.bashrc
    echo 'if [ -e $HOME/.mybashprofile ]; then' >> ~/.bashrc
    echo '    source $HOME/.mybashprofile' >> ~/.bashrc
    echo 'fi' >> ~/.bashrc
    echo "  added: mybashprofile source line to ~/.bashrc"
else
    echo "  exists: mybashprofile already sourced in ~/.bashrc"
fi

echo
echo "Done! Reload i3 with Mod+Shift+r"
