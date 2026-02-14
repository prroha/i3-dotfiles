#!/bin/bash
# Dotfiles installer — complete i3 development environment setup
# Usage: git clone <repo> ~/dotfiles && cd ~/dotfiles && ./install.sh

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

link() {
    local src="$DOTFILES/$1"
    local dst="$HOME/$1"
    if [ ! -e "$src" ]; then
        echo "  SKIP: $src not found in dotfiles"
        return
    fi
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

# ─── Create directories ───
mkdir -p ~/.local/bin
mkdir -p ~/.local/share/fonts
mkdir -p ~/.config

# ─── Install packages ───
echo "==> Installing packages..."

PACKAGES=(
    i3 polybar alacritty conky rofi picom dunst feh
    brightnessctl flameshot ImageMagick i3lock neovim
    git openssh-clients openssh-askpass
    jq zoxide python3-pip unzip curl wget
    xdg-utils xclip pavucontrol
    ripgrep fd-find make gcc fastfetch lm_sensors
    tlp tlp-rdw
    xrdb xrandr xss-lock
    pulseaudio-utils libnotify
    NetworkManager network-manager-applet nm-connection-editor
    keychain podman podman-compose
    polkit-gnome
    obs-studio
)

# Try all at once, fall back to one-by-one
if ! sudo dnf install -y "${PACKAGES[@]}"; then
    echo
    echo "  Bulk install failed, retrying individually..."
    for pkg in "${PACKAGES[@]}"; do
        sudo dnf install -y "$pkg" || echo "  WARNING: $pkg not found, skipping"
    done
fi

# ─── GPU drivers ───
echo "==> Detecting GPU..."

# AMD / Intel (mesa)
if lspci | grep -qi "amd\|radeon\|intel.*graphics"; then
    echo "  AMD/Intel GPU detected, installing mesa drivers..."
    sudo dnf install -y mesa-dri-drivers mesa-vulkan-drivers || echo "  WARNING: mesa drivers install failed"
fi

# NVIDIA
if lspci | grep -qi "nvidia"; then
    echo "  NVIDIA GPU detected, installing drivers..."
    # Enable RPM Fusion if not already
    if ! dnf repolist | grep -q rpmfusion-nonfree; then
        sudo dnf install -y \
            "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
            "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
    fi
    sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia || echo "  WARNING: NVIDIA driver install failed"

    # Check if GPU supports runtime power management (Turing/GTX 1650+ or newer)
    GPU_ID=$(lspci -nn | grep -i nvidia | grep -oP '\[10de:\K[0-9a-f]+' | head -1)
    GPU_ID_DEC=$((16#${GPU_ID:-0}))

    # Turing+ GPUs have device IDs starting from 0x1e00
    if [ "$GPU_ID_DEC" -ge 7680 ] 2>/dev/null; then
        echo "  Turing+ GPU detected, enabling runtime power management..."
        sudo dnf install -y xorg-x11-drv-nvidia-power || echo "  WARNING: nvidia-power install failed"

        if [ ! -f /etc/udev/rules.d/80-nvidia-pm.rules ]; then
            sudo tee /etc/udev/rules.d/80-nvidia-pm.rules > /dev/null <<'EOF'
# Enable runtime power management for NVIDIA GPU
ACTION=="bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", TEST=="power/control", ATTR{power/control}="auto"
ACTION=="bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", TEST=="power/control", ATTR{power/control}="auto"
EOF
            echo "  NVIDIA runtime power management configured"
        fi

        sudo systemctl enable nvidia-suspend nvidia-resume nvidia-hibernate 2>/dev/null
    else
        echo "  Older NVIDIA GPU — no runtime power management support"
        echo "  Disabling NVIDIA to save battery (integrated GPU handles everything)"
        sudo tee /etc/modprobe.d/nvidia-disable.conf > /dev/null <<'EOF'
# Disable NVIDIA GPU on older hardware to save battery
# Remove this file and reboot to re-enable NVIDIA
blacklist nouveau
blacklist nvidia
blacklist nvidia_drm
blacklist nvidia_modeset
alias nouveau off
alias nvidia off
EOF
        echo "  NVIDIA disabled. To re-enable: sudo rm /etc/modprobe.d/nvidia-disable.conf && reboot"
    fi

    echo "  NOTE: Reboot required for changes to take effect"
    echo "  Newer GPUs: use 'gpu <command>' to run apps on NVIDIA"
fi

# ─── Python tools ───
echo "==> Installing Python tools..."
python3 -m pip install --user autotiling i3-workspace-names-daemon || echo "  WARNING: pip install failed"

# ─── Yazi (not in default repos) ───
if ! command -v yazi &>/dev/null; then
    echo "==> Installing yazi from GitHub..."
    curl -fL https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip -o /tmp/yazi.zip
    unzip -o /tmp/yazi.zip -d /tmp && cp /tmp/yazi-x86_64-unknown-linux-gnu/{yazi,ya} ~/.local/bin/
    rm -f /tmp/yazi.zip
    echo "  yazi installed"
fi

# ─── Lazygit (needed by LazyVim) ───
if ! command -v lazygit &>/dev/null; then
    echo "==> Installing lazygit from GitHub..."
    LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep -oP '"tag_name":\s*"v\K[^"]+')
    curl -fL "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" -o /tmp/lazygit.tar.gz
    tar xf /tmp/lazygit.tar.gz -C /tmp lazygit
    cp /tmp/lazygit ~/.local/bin/
    rm -f /tmp/lazygit.tar.gz /tmp/lazygit
    echo "  lazygit installed"
fi

# ─── Lazydocker ───
if ! command -v lazydocker &>/dev/null; then
    echo "==> Installing lazydocker..."
    curl -s https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
fi

# ─── JetBrains Mono Nerd Font ───
if ! fc-list | grep -qi "JetBrainsMono Nerd"; then
    echo "==> Installing JetBrains Mono Nerd Font..."
    curl -fL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz -o /tmp/JetBrainsMono.tar.xz
    tar xf /tmp/JetBrainsMono.tar.xz -C ~/.local/share/fonts/
    rm -f /tmp/JetBrainsMono.tar.xz
    fc-cache -f
    echo "  Font installed"
fi

# ─── Catppuccin GTK theme ───
if [ ! -d ~/.themes/catppuccin-mocha-blue-standard+default ]; then
    echo "==> Installing Catppuccin GTK theme..."
    mkdir -p ~/.themes
    curl -fL https://github.com/catppuccin/gtk/releases/latest/download/catppuccin-mocha-blue-standard+default.zip -o /tmp/catppuccin-gtk.zip
    unzip -o /tmp/catppuccin-gtk.zip -d ~/.themes/
    rm -f /tmp/catppuccin-gtk.zip
    echo "  GTK theme installed"
fi

# ─── Catppuccin cursors ───
if [ ! -d ~/.icons/catppuccin-mocha-blue-cursors ]; then
    echo "==> Installing Catppuccin cursors..."
    mkdir -p ~/.icons
    curl -fL https://github.com/catppuccin/cursors/releases/latest/download/catppuccin-mocha-blue-cursors.zip -o /tmp/catppuccin-cursors.zip
    unzip -o /tmp/catppuccin-cursors.zip -d ~/.icons/
    rm -f /tmp/catppuccin-cursors.zip
    echo "  Cursors installed"
fi

# ─── Default wallpaper ───
if [ ! -f ~/.config/i3/wallpaper.png ]; then
    echo "==> Setting default wallpaper (solid Catppuccin base color)..."
    mkdir -p ~/.config/i3
    convert -size 3840x2160 xc:'#1e1e2e' ~/.config/i3/wallpaper.png
    echo "  Default wallpaper created (replace with your own at ~/.config/i3/wallpaper.png)"
fi

# ─── Link config files ───
echo
echo "==> Linking config files..."

# i3
link .config/i3/config
link .config/i3/lock.sh
link .config/i3/powermenu.sh
link .config/i3/vol-up.sh
link .config/i3/workspace-icons.json
link .config/i3/monitor.sh
link .config/i3/set-dpi.sh
link .config/i3/battery-monitor.sh

# Polybar
link .config/polybar/config.ini
link .config/polybar/launch.sh
link .config/polybar/cpu-mem-bar
link .config/polybar/bri-vol-bar
link .config/polybar/battery-bar

# Terminal, launcher, compositor, notifications
link .config/alacritty/alacritty.toml
link .config/conky/i3-shortcuts.conf
link .config/rofi/config.rasi
link .config/picom/picom.conf
link .config/dunst/dunstrc

# Dev stack (docker-compose)
link devstack/docker-compose.yml

# Shell profile
link .mybashprofile

# Theme / display
link .Xresources
link .gtkrc-2.0
link .config/gtk-3.0/settings.ini
link .config/gtk-4.0/settings.ini

# Nvim — link entire directory
for dir in nvim lazynvim; do
    dst="$HOME/.config/$dir"
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        echo "  backup: $dst -> ${dst}.bak"
        mv "$dst" "${dst}.bak"
    fi
    ln -sf "$DOTFILES/.config/$dir" "$dst"
    echo "  linked: $dst"
done

# ─── Make scripts executable ───
echo
echo "==> Setting permissions..."
chmod +x ~/.config/i3/*.sh
chmod +x ~/.config/polybar/cpu-mem-bar
chmod +x ~/.config/polybar/bri-vol-bar
chmod +x ~/.config/polybar/battery-bar
chmod +x ~/.config/polybar/launch.sh

# ─── Shell setup ───
echo
echo "==> Configuring shell..."

# Source mybashprofile from bashrc
if ! grep -q 'mybashprofile' ~/.bashrc 2>/dev/null; then
    echo '' >> ~/.bashrc
    echo 'if [ -e "$HOME/.mybashprofile" ]; then' >> ~/.bashrc
    echo '    source "$HOME/.mybashprofile"' >> ~/.bashrc
    echo 'fi' >> ~/.bashrc
    echo "  added: mybashprofile source line to ~/.bashrc"
else
    echo "  exists: mybashprofile already sourced in ~/.bashrc"
fi

# ─── Apply DPI settings ───
echo
echo "==> Detecting DPI and applying Xresources..."
~/.config/i3/set-dpi.sh 2>/dev/null || echo "  WARNING: DPI detection failed (will apply on next login)"

# ─── Touchpad natural scrolling + tap to click ───
echo
echo "==> Configuring touchpad..."
if [ ! -f /etc/X11/xorg.conf.d/30-touchpad.conf ]; then
    sudo mkdir -p /etc/X11/xorg.conf.d
    sudo tee /etc/X11/xorg.conf.d/30-touchpad.conf > /dev/null <<'EOF'
Section "InputClass"
    Identifier "touchpad"
    MatchIsTouchpad "on"
    Option "NaturalScrolling" "true"
    Option "Tapping" "on"
EndSection
EOF
    echo "  touchpad configured"
else
    echo "  touchpad already configured"
fi

# ─── Timezone ───
echo
echo "==> Setting timezone..."
read -p "  Enter timezone [Asia/Kathmandu]: " TZ_INPUT
TZ_INPUT="${TZ_INPUT:-Asia/Kathmandu}"
sudo timedatectl set-timezone "$TZ_INPUT"
sudo timedatectl set-ntp true
echo "  timezone: $TZ_INPUT, NTP enabled"

# ─── TLP (battery management, 80% charge threshold) ───
echo
echo "==> Configuring TLP..."
sudo systemctl enable tlp 2>/dev/null
sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket 2>/dev/null
if [ ! -f /etc/tlp.d/80-charge-threshold.conf ]; then
    sudo mkdir -p /etc/tlp.d
    sudo tee /etc/tlp.d/80-charge-threshold.conf > /dev/null <<'EOF'
START_CHARGE_THRESH_BAT0=75
STOP_CHARGE_THRESH_BAT0=80
START_CHARGE_THRESH_BAT1=75
STOP_CHARGE_THRESH_BAT1=80
EOF
    echo "  charge threshold set to 80%"
else
    echo "  TLP charge threshold already configured"
fi

# ─── Dev stack (Postgres + Redis) ───
echo
echo "==> Setting up dev stack..."
read -p "  Enable pgvector (vector DB support) for PostgreSQL? [y/N]: " PGVECTOR
if [[ "$PGVECTOR" =~ ^[Yy]$ ]]; then
    sed -i 's|image: postgres:16-alpine|image: pgvector/pgvector:pg16|' ~/devstack/docker-compose.yml
    echo "  PostgreSQL image set to pgvector/pgvector:pg16"
else
    echo "  Using standard PostgreSQL 16"
fi

# ─── Disable PackageKit (not needed on i3, silences "command not found" errors) ───
echo
echo "==> Masking PackageKit..."
sudo systemctl mask packagekit 2>/dev/null && echo "  PackageKit masked" || echo "  already masked"

# ─── Enable Podman socket (for lazydocker) ───
echo
echo "==> Enabling Podman socket..."
systemctl --user enable --now podman.socket 2>/dev/null || echo "  WARNING: podman socket not available"

# ─── Restart i3 and services ───
echo
echo "==> Starting services..."
if pgrep -x i3 &>/dev/null; then
    i3-msg restart 2>/dev/null && echo "  i3 restarted"
fi

echo
echo "============================================"
echo "  Setup complete! Log out and log back in"
echo "  for all changes to take effect."
echo "============================================"
echo
echo "  Post-install checklist:"
echo "    - Log out and log back in (or reboot)"
echo "    - Run 'lazy' to initialize LazyVim plugins"
echo "    - Run 'nvim' to initialize Neovim plugins"
echo
