# i3 Dotfiles — Catppuccin Mocha

Minimal, resource-friendly i3 desktop environment for Fedora with Catppuccin Mocha theme.

## What's included

| Component | Config | Purpose |
|-----------|--------|---------|
| **i3** | `.config/i3/config` | Window manager with vim-style keys, autotiling |
| **Polybar** | `.config/polybar/` | Status bar with stacked CPU/MEM and BRI/VOL bars |
| **Alacritty** | `.config/alacritty/alacritty.toml` | Terminal (Catppuccin, JetBrains Mono 14) |
| **Conky** | `.config/conky/i3-shortcuts.conf` | Always-visible shortcuts cheatsheet |
| **Rofi** | `.config/rofi/config.rasi` | App launcher / window switcher |
| **Picom** | `.config/picom/picom.conf` | Compositor (vsync, fading, rounded corners) |
| **Dunst** | `.config/dunst/dunstrc` | Notification daemon |
| **Neovim** | `.config/nvim/` | LazyVim config with plugins |
| **Xresources** | `.Xresources` | HiDPI settings (144 DPI) |

### Helper scripts

- `i3/lock.sh` — Lock screen with blurred screenshot
- `i3/powermenu.sh` — Rofi power menu (lock/suspend/logout/reboot/shutdown)
- `i3/vol-up.sh` — Volume up capped at 100%
- `polybar/cpu-mem-bar` — Stacked CPU (overline) + MEM (underline) indicator
- `polybar/bri-vol-bar` — Stacked BRI (overline) + VOL (underline) indicator
- `polybar/battery-bar` — Vertical battery bar with charging bolt

## Install

### 1. Install packages (Fedora)

```bash
sudo dnf install i3 polybar alacritty conky rofi picom dunst feh \
    brightnessctl flameshot ImageMagick i3lock neovim jetbrains-mono-fonts-all
pip install --user autotiling
```

### 2. Clone and link

```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

The install script symlinks all configs into place (backs up existing files as `.bak`).

### 3. Reload i3

Press `Mod+Shift+r` to restart i3 and apply everything.

## Key bindings

| Key | Action |
|-----|--------|
| `Mod+Enter` | Terminal (Alacritty) |
| `Mod+d` | Rofi app launcher |
| `Mod+Shift+d` | Rofi run prompt |
| `Mod+Tab` | Window list |
| `Mod+Shift+q` | Kill window |
| `Mod+h/j/k/l` | Focus left/down/up/right |
| `Mod+Shift+h/j/k/l` | Move window left/down/up/right |
| `Mod+n/p` | Focus next/prev window |
| `Mod+1-0` | Switch workspace |
| `Mod+Shift+1-0` | Move window to workspace |
| `Mod+f` | Fullscreen |
| `Mod+b` | Split horizontal |
| `Mod+v` | Split vertical |
| `Mod+s/w/e` | Stacking/tabbed/toggle split |
| `Mod+Shift+Space` | Toggle floating |
| `Mod+Space` | Focus mode toggle |
| `Mod+Shift+-` | Move to scratchpad |
| `Mod+-` | Show scratchpad |
| `Mod+r` | Resize mode |
| `Print` | Screenshot (Flameshot) |
| `Mod+Shift+e` | Power menu |
| `Mod+Shift+c` | Reload config |
| `Mod+Shift+r` | Restart i3 |

## Resource usage

Total overhead: ~83 MB RAM (polybar ~18MB, picom ~16MB, alacritty ~14MB, conky ~10MB, dunst ~8MB, rofi ~6MB, autotiling ~11MB).

## Notes

- HiDPI configured for 144 DPI — adjust `.Xresources` and polybar `dpi` for different screens
- Natural scrolling needs a separate Xorg config (not included — requires sudo):
  ```bash
  sudo tee /etc/X11/xorg.conf.d/30-touchpad.conf <<'EOF'
  Section "InputClass"
      Identifier "touchpad"
      MatchIsTouchpad "on"
      Option "NaturalScrolling" "true"
      Option "Tapping" "on"
  EndSection
  EOF
  ```
- Wallpaper: place your image at `~/.config/i3/wallpaper.png` (feh is configured to load it)
