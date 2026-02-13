# i3 Dotfiles — Catppuccin Mocha

Minimal, resource-friendly i3 desktop environment for Fedora with Catppuccin Mocha theme.

## What's included

| Component | Config | Purpose |
|-----------|--------|---------|
| **i3** | `.config/i3/config` | Window manager with vim-style keys, autotiling, dynamic workspace icons |
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
    brightnessctl flameshot ImageMagick i3lock neovim jetbrains-mono-fonts-all \
    mpv cmus btop zathura zathura-pdf-mupdf podman podman-compose
pip install --user autotiling i3-workspace-names-daemon
# Yazi (file manager):
curl -fL https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip -o /tmp/yazi.zip
unzip /tmp/yazi.zip -d /tmp && cp /tmp/yazi-x86_64-unknown-linux-gnu/{yazi,ya} ~/.local/bin/
```

Install JetBrains Mono Nerd Font (for workspace icons):
```bash
mkdir -p ~/.local/share/fonts
curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
tar xf JetBrainsMono.tar.xz -C ~/.local/share/fonts/ && fc-cache -f
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
| `Mod+Shift+m` | External monitor on (right) |
| `Mod+Shift+n` | External monitor off |

## Workspaces

| Workspace | Contents |
|-----------|----------|
| **1** | Browsers |
| **2** | IDEs |
| **3** | Terminals |
| **4** | API / DB tools (Postman, DBeaver, MongoDB Compass) |
| **9** | Messaging (Slack, Discord, Telegram) |

## Tool cheatsheets

### yazi — file manager

Launch with `y` (shell wrapper that cds on quit).

| Key | Action |
|-----|--------|
| `h` / `l` | Parent dir / Enter dir |
| `j` / `k` | Move down / up |
| `Enter` | Open file (uses xdg-open) |
| `Space` | Select file |
| `y` | Yank (copy) selected |
| `x` | Cut selected |
| `p` | Paste |
| `d` | Trash |
| `D` | Delete permanently |
| `a` | Create file |
| `A` | Create directory |
| `r` | Rename |
| `c` | Change directory (type path) |
| `.` | Toggle hidden files |
| `/` | Search |
| `z` | Jump (fzf) |
| `q` | Quit |
| `~` | Go to home |
| `Tab` | Switch pane |

### cmus — music player

Launch with `cmus`.

| Key | Action |
|-----|--------|
| `5` | File browser (add music) |
| `a` | Add file/dir to library |
| `1` | Artist/Album view |
| `2` | Library (all tracks) |
| `3` | Playlist |
| `Enter` | Play selected |
| `c` | Pause/resume |
| `x` | Play |
| `v` | Stop |
| `b` | Next track |
| `z` | Previous track |
| `+` / `-` | Volume up / down |
| `s` | Toggle shuffle |
| `r` | Toggle repeat |
| `Right` / `Left` | Seek +5s / -5s |
| `q` | Quit |

First time: press `5`, navigate to your music folder, press `a` to add it.

### mpv — video player

Launch with `mpv <file>` or open from yazi.

| Key | Action |
|-----|--------|
| `Space` | Pause/resume |
| `Left` / `Right` | Seek -5s / +5s |
| `Up` / `Down` | Seek +60s / -60s |
| `9` / `0` | Volume down / up |
| `m` | Mute |
| `f` | Fullscreen |
| `s` | Screenshot |
| `[` / `]` | Speed -10% / +10% |
| `l` | Set A-B loop |
| `j` | Cycle subtitles |
| `q` | Quit |

### zathura — PDF viewer

Launch with `zathura <file.pdf>` or open from yazi.

| Key | Action |
|-----|--------|
| `j` / `k` | Scroll down / up |
| `h` / `l` | Scroll left / right |
| `J` / `K` | Next page / prev page |
| `gg` | First page |
| `G` | Last page |
| `5G` | Go to page 5 |
| `+` / `-` | Zoom in / out |
| `=` | Fit page |
| `a` | Fit height |
| `s` | Fit width |
| `/` | Search |
| `n` / `N` | Next / prev search result |
| `d` | Dual page mode |
| `r` | Rotate |
| `Tab` | Table of contents |
| `q` | Quit |

### btop — system monitor

Launch with `btop`.

| Key | Action |
|-----|--------|
| `h` | Help |
| `Esc` | Back / menu |
| `Up` / `Down` | Select process |
| `Enter` | Show process details |
| `t` | Tree view |
| `k` | Kill selected process |
| `f` | Filter processes |
| `/` | Search processes |
| `P` | Sort by CPU |
| `M` | Sort by memory |
| `e` | Toggle net/disk/proc panels |
| `q` | Quit |

### podman — container runtime (Docker replacement)

Same commands as Docker:

```bash
podman run -it ubuntu bash          # run container
podman ps                           # list running
podman ps -a                        # list all
podman images                       # list images
podman build -t myapp .             # build from Dockerfile
podman-compose up                   # docker-compose replacement
podman-compose up -d                # detached
podman-compose down                 # stop and remove
podman stop <id>                    # stop container
podman rm <id>                      # remove container
podman rmi <image>                  # remove image
podman logs <id>                    # view logs
podman exec -it <id> bash           # shell into container
```

## Common commands / troubleshooting

### WiFi
```bash
nmcli device wifi list                                    # list networks
nmcli device wifi connect "SSID" password "PASSWORD"      # connect
nmcli connection show                                     # saved connections
nmcli device wifi show-password                           # show current wifi password
```

### Time / timezone
```bash
timedatectl                                               # check current time & timezone
sudo timedatectl set-timezone Asia/Kathmandu              # set timezone
sudo timedatectl set-ntp true                             # enable auto time sync
```

### Display / monitor
```bash
xrandr                                                    # list displays
xrandr --output HDMI-1 --auto --right-of eDP-1           # external monitor right
xrandr --output HDMI-1 --off                              # disable external monitor
```

### Audio
```bash
pactl list sinks short                                    # list audio outputs
pactl set-sink-volume @DEFAULT_SINK@ +10%                 # volume up
pactl set-sink-volume @DEFAULT_SINK@ -10%                 # volume down
pactl set-sink-mute @DEFAULT_SINK@ toggle                 # mute toggle
```

### Packages
```bash
sudo dnf install <package>                                # install
sudo dnf remove <package>                                 # remove
sudo dnf search <keyword>                                 # search
sudo dnf update                                           # update all
```

### Podman / Docker
```bash
systemctl --user enable --now podman.socket               # enable podman socket (for lazydocker)
lzd                                                       # lazydocker TUI
```

### Useful aliases (from .mybashprofile)
```bash
dir          # yazi file manager
y            # yazi with cd-on-quit
z <partial>  # zoxide smart cd
lzd          # lazydocker
lazy         # LazyVim (nvim with LazyVim config)
astro        # AstroNvim
docker       # aliased to podman
```

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
