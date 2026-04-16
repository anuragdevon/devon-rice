---
title: My Arch Linux + Hyprland Rice — A Complete Setup Guide (With Dotfiles)
published: false
description: A step-by-step guide to building a sleek, polished Hyprland desktop on Arch Linux with Catppuccin Mocha, i3-style keybindings, floating waybar, dynamic workspaces, and a full dotfiles repo you can clone and replicate in minutes.
tags: linux, archlinux, hyprland, dotfiles
cover_image: [ADD YOUR DESKTOP SCREENSHOT HERE]
---

> Everything in this post is tracked in my dotfiles repo: **[anuragdevon/devon-rice](https://github.com/anuragdevon/devon-rice)**. Clone it, run one script, done.

---

## What You're Building

<!-- ADD: Full desktop screenshot here -->

A complete, polished Hyprland desktop with:

- **Catppuccin Mocha** color scheme throughout — every component shares the same palette
- **i3-style keybindings** — muscle memory from i3wm works immediately
- **Floating pill waybar** — workspaces centered, system stats left, clock/media right
- **Dual monitor support** — laptop (1.5x HiDPI) + external (1.0x) configured correctly
- **Full productivity stack** — launcher, clipboard history, screenshot, notifications, lock screen, file manager, bluetooth, audio toggle — all wired up

---

## My Setup

| | |
|---|---|
| **Machine** | HP Laptop 15s (AMD Ryzen 3 3250U) |
| **GPU** | AMD Radeon Vega 3 (integrated) |
| **WM** | Hyprland 0.54.3 (Wayland) |
| **Monitors** | 15" built-in (1080p @ 1.5x) + 21" HDMI (1080p @ 1.0x) |

---

## Full Stack

| Role | Tool |
|------|------|
| Window manager | Hyprland |
| Terminal | Ghostty |
| Shell | Zsh + Starship |
| Editor | Neovim |
| File manager | Nautilus (GTK4, Catppuccin themed) |
| Browser | Brave |
| Launcher | Rofi (spotlight style) |
| Status bar | Waybar (floating pill) |
| Notifications | Swaync |
| Lock screen | Hyprlock |
| Logout menu | Wlogout |
| Wallpaper | Hyprpaper |
| Audio visualizer | Cava |
| Clipboard | Cliphist + wl-clipboard |
| Screenshot | Grim + Slurp |
| Workspace overview | Hyprexpo plugin |
| Calculator | rofi-calc (Python script) |
| Bluetooth | Bluetoothctl |
| Audio toggle | toggle-audio.sh (HDMI ↔ Bluetooth) |
| Login manager | SDDM (catppuccin-mocha-blue) |
| Font | FiraCode Nerd Font |
| Icons | Papirus-Dark |
| Cursor | Bibata Modern Classic |
| Color scheme | Catppuccin Mocha |
| AUR helper | yay |

---

## Quick Start (Clone and Go)

```bash
# 1. Install dependencies
yay -S hyprland ghostty waybar rofi-wayland swaync wlogout hyprlock hyprpaper \
       cava starship zsh-autosuggestions zsh-syntax-highlighting \
       ttf-firacode-nerd papirus-icon-theme bibata-cursor-theme noto-fonts-emoji \
       gnome-keyring libsecret neovim nautilus \
       catppuccin-gtk-theme-mocha kvantum qt6ct \
       cliphist wl-clipboard playerctl \
       grim slurp socat jq \
       bluez bluez-utils sddm

# 2. Clone dotfiles
git clone https://github.com/anuragdevon/devon-rice ~/devon-rice

# 3. Wire up symlinks (backs up your existing configs first)
cd ~/devon-rice && bash install.sh

# 4. Symlink GTK4 CSS for Nautilus
ln -sf /usr/share/themes/catppuccin-mocha-blue-standard+default/gtk-4.0/gtk.css ~/.config/gtk-4.0/gtk.css
ln -sf /usr/share/themes/catppuccin-mocha-blue-standard+default/gtk-4.0/gtk-dark.css ~/.config/gtk-4.0/gtk-dark.css

# 5. Set up hyprexpo plugin
hyprpm add https://github.com/hyprwm/hyprland-plugins
hyprpm enable hyprexpo

# 6. Update wallpaper paths with your username
nvim configs/hyprpaper/hyprpaper.conf
nvim configs/hypr/set-wallpaper.sh

# 7. Reload
hyprctl reload
```

The `install.sh` creates symlinks from `~/.config/` into the repo. Any config edit is instantly reflected in the repo, ready to push.

---

## Step-by-Step Walkthrough

### 1. Base System

Start with a fresh Arch install. I use `archinstall` for the base. Get `yay` set up first:

```bash
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
```

### 2. Hyprland + Core Tools

```bash
yay -S hyprland ghostty waybar rofi-wayland swaync wlogout \
       hyprlock hyprpaper cava wl-clipboard nm-applet playerctl
```

### 3. Fonts, Icons, and Cursor

```bash
yay -S ttf-firacode-nerd papirus-icon-theme bibata-cursor-theme noto-fonts-emoji
fc-cache -fv
```

Set cursor in `hyprland.conf`:
```ini
env = XCURSOR_THEME, Bibata-Modern-Classic
env = XCURSOR_SIZE, 24
```

### 4. Shell Setup

```bash
yay -S zsh starship zsh-autosuggestions zsh-syntax-highlighting
chsh -s /usr/bin/zsh
```

Add to `~/.zshrc`:
```bash
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
eval "$(starship init zsh)"
```

---

## Monitor Configuration

```ini
# Laptop screen — 15", needs 1.5x for comfortable text
monitor = eDP-1, 1920x1080@60, 0x0, 1.5

# External — 21", no scaling. Position = 1920÷1.5 = 1280 logical px
monitor = HDMI-A-1, 1920x1080@60, 1280x0, 1.0
```

Prevent blurry XWayland apps on the external monitor:
```ini
xwayland {
    force_zero_scaling = true
}
env = GDK_SCALE, 1
env = XDG_SESSION_TYPE, wayland
```

---

## Animations

Smooth, expressive window and workspace animations using custom bezier curves inspired by Material Design 3:

```ini
bezier = emphasizedDecel, 0.05, 0.7, 0.1, 1.0
bezier = menu_decel,      0.1,  1,   0.0, 1.0

animation = windowsIn,  1, 3, emphasizedDecel, popin 80%
animation = windowsOut, 1, 2, quick,           popin 90%
animation = workspaces, 1, 7, menu_decel,      slide
```

Windows pop in with a scale animation, workspaces slide smoothly. Much more alive than the defaults.

---

## Window Polish

```ini
decoration {
    rounding = 12
    dim_inactive = true      # unfocused windows darken slightly
    dim_strength = 0.07      # makes the active window pop

    shadow {
        range = 20           # wide, soft shadow
        color = rgba(1a1a1a99)
        offset = 0 4
    }
}

general {
    snap {
        enabled = true       # windows snap to edges when resizing
        window_gap = 8
        monitor_gap = 8
    }
}
```

---

## Keybindings (i3-Style)

| Bind | Action |
|------|--------|
| `Super + Enter` | Open terminal (Ghostty) |
| `Super + Q` | Close window |
| `Super + D` | App launcher (Rofi) |
| `Super + E` | File manager (Nautilus) |
| `Super + F` | Fullscreen |
| `Super + L` | Lock screen |
| `Super + Tab` | Workspace overview (Hyprexpo) |
| `Super + B` | Bluetooth |
| `Super + N` | Notification center |
| `Super + C` | Audio visualizer (Cava) |
| `Super + =` | Calculator |
| `Super + Shift + V` | Clipboard history |
| `Super + Shift + S` | Screenshot region → clipboard |
| `Super + Shift + A` | Toggle audio (HDMI ↔ Bluetooth) |
| `Super + Shift + E` | Power menu |
| `Super + Shift + R` | Reload config |
| `Super + Shift + Space` | Toggle floating |
| `Super + hjkl` | Focus window |
| `Super + Shift + hjkl` | Move window |
| `Super + Ctrl + hjkl` | Resize window |
| `Super + RMB drag` | Resize floating window |
| `Super + LMB drag` | Move floating window |
| `Super + 1-0` | Switch workspace |
| `Super + Shift + 1-0` | Move window to workspace |
| `Super + ,` / `Super + .` | Focus left / right monitor |

---

## Workspace Layout

Each workspace has a dedicated purpose and label shown in the waybar:

| Workspace | Label | Use |
|-----------|-------|-----|
| 1 |  Brave | Browser |
| 2 |  Code | Editor / IDE |
| 3 |  Term | Terminal |
| 4 |  Music | Spotify / audio |
| 5 | 󰃽 Edit | Video editing |
| 6 | 󰙯 Chat | Discord |
| 7 |  Games | Gaming |
| 8 |  Tools | System tools |
| 9 |  Videos | Media playback |
| 0 |  Buffer | Scratch / overflow |

---

## Component Configs

### Waybar — Floating Pill Bar

<!-- ADD: Waybar screenshot -->

The bar floats above the desktop with rounded corners, a semi-transparent dark background, and three sections:

- **Left:** CPU · RAM · Battery · Active window title
- **Center:** Workspaces (pill buttons — active = blue)
- **Right:** Media · Volume · Network · Clock · Tray

```jsonc
{
    "layer": "top",
    "height": 40,
    "margin-top": 10,
    "margin-left": 14,
    "margin-right": 14,

    "modules-left":   ["cpu", "memory", "battery", "hyprland/window"],
    "modules-center": ["hyprland/workspaces"],
    "modules-right":  ["custom/media", "pulseaudio", "network", "clock", "tray"]
}
```

The CSS gives it the floating appearance:
```css
window#waybar {
    background: rgba(30, 30, 46, 0.82);
    border-radius: 14px;
    border: 1px solid rgba(137, 180, 250, 0.10);
}
```

Left and right groups get a slightly darker pill container for visual separation. All colors import from the shared `colors.css`.

### Media Module

The center-right area shows the currently playing track via `playerctl`. Click to play/pause, scroll to skip:

```bash
#!/bin/bash
status=$(playerctl status 2>/dev/null)
if [ "$status" = "Playing" ] || [ "$status" = "Paused" ]; then
    artist=$(playerctl metadata artist 2>/dev/null)
    title=$(playerctl metadata title 2>/dev/null)
    icon="󰎆"; [ "$status" = "Paused" ] && icon="󰏤"
    echo "$icon $artist – $title"
fi
```

### Rofi — Spotlight Launcher

<!-- ADD: Rofi screenshot -->

Centered, transparent, spotlight-style. `Super + D`:

```css
window {
    background-color: rgba(30, 30, 46, 0.85);
    border: 2px solid;
    border-color: @bordercolor;
    border-radius: 20px;
    width: 520px;
}
```

### Clipboard History

`Super+Shift+V` opens a Rofi picker with your full clipboard history, powered by cliphist:

```ini
# hyprland.conf autostart
exec-once = wl-paste --watch cliphist store

# keybind
bind = $mainMod SHIFT, V, exec, cliphist list | rofi -dmenu -p "Clipboard" | cliphist decode | wl-copy
```

### Screenshot

`Super+Shift+S` — drag to select a region, auto-copied to clipboard:

```ini
bind = $mainMod SHIFT, S, exec, grim -g "$(slurp)" - | wl-copy
```

### Workspace Overview (Hyprexpo)

`Super+Tab` shows all open workspaces in a 3-column grid:

```bash
# Install the plugin
hyprpm add https://github.com/hyprwm/hyprland-plugins
hyprpm enable hyprexpo
```

```ini
# hyprland.conf
bind = $mainMod, Tab, hyprexpo:expo, toggle

plugin {
    hyprexpo {
        columns = 3
        gap_size = 5
        bg_col = rgb(1e1e2e)
        workspace_method = center current
    }
}
```

### File Manager — Nautilus

<!-- ADD: Nautilus screenshot -->

GTK4, Catppuccin themed. Install and theme:

```bash
yay -S nautilus catppuccin-gtk-theme-mocha papirus-icon-theme

# Symlink GTK4 CSS
ln -sf /usr/share/themes/catppuccin-mocha-blue-standard+default/gtk-4.0/gtk.css ~/.config/gtk-4.0/gtk.css
ln -sf /usr/share/themes/catppuccin-mocha-blue-standard+default/gtk-4.0/gtk-dark.css ~/.config/gtk-4.0/gtk-dark.css
```

GTK settings (`~/.config/gtk-4.0/settings.ini`):
```ini
[Settings]
gtk-theme-name=catppuccin-mocha-blue-standard+default
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=FiraCode Nerd Font 11
gtk-application-prefer-dark-theme=1
```

Env vars in `hyprland.conf`:
```ini
env = GTK_THEME, catppuccin-mocha-blue-standard+default
```

### Yazi — Terminal File Manager

For when you want a file manager in the terminal (`ghostty -e yazi`). Catppuccin Mocha themed via `~/.config/yazi/theme.toml`. Opens files in Neovim, sorts directories first, shows file sizes inline.

### Bluetooth

`Super + B` opens a floating Ghostty window running `bluetoothctl`:

```bash
power on
scan on
pair XX:XX:XX
connect XX:XX:XX
```

### Audio Toggle (HDMI ↔ Bluetooth)

`Super + Shift + A` switches your default sink and sends a notification:

```bash
HDMI="alsa_output.pci-0000_03_00.1.hdmi-stereo"
BT="bluez_output.XX:XX:XX:XX:XX:XX"
current=$(pactl get-default-sink)

if [ "$current" = "$HDMI" ]; then
    pactl set-default-sink "$BT"
    notify-send "Audio → Bluetooth"
else
    pactl set-default-sink "$HDMI"
    notify-send "Audio → HDMI"
fi
```

### Hyprlock — Lock Screen

<!-- ADD: Lock screen screenshot -->

Blurred wallpaper, live 80px clock, date, avatar, password field:

```ini
background {
    path = /home/anurag/wallpapers/1.jpg
    blur_passes = 4
    blur_size = 8
    brightness = 0.4
}

label {
    text = cmd[update:1000] echo "<b>$(date +"%H:%M")</b>"
    font_size = 80
    font_family = FiraCode Nerd Font Bold
    position = 0, 40
    halign = center
    valign = center
}

input-field {
    size = 300, 52
    outer_color = rgb(89b4fa)
    inner_color = rgb(1e1e2e)
    rounding = 12
    position = 0, -190
    halign = center
    valign = center
}
```

### Swaync — Notification Center

<!-- ADD: Swaync screenshot -->

`Super + N` toggles it. Quick toggle buttons for WiFi, Bluetooth, mic mute, volume mute. Media controls and backlight slider built in. Styled with FiraCode Nerd Font + Catppuccin colors.

### Cava — Audio Visualizer

<!-- ADD: Cava screenshot -->

`Super + C` — floating Ghostty window, 18 bars, Catppuccin gradient:

```ini
[color]
gradient = 1
gradient_count = 8
gradient_color_1 = '#1e1e2e'
gradient_color_8 = '#89b4fa'
```

### Calculator

`Super + =` — inline Rofi calculator, no extra packages:

```bash
expr=$(rofi -dmenu -p "  " -l 0)
result=$(python3 -c "from math import *; print($expr)" 2>/dev/null || echo "Error")
echo "$result" | rofi -dmenu -p "  $expr =" -l 1 | xargs -I{} sh -c 'echo -n "{}" | wl-copy'
```

Supports `sqrt(144)`, `sin(pi/2)`, full Python math. Result copied to clipboard.

---

## Color Scheme

Shared color file imported by waybar, swaync, wlogout, rofi. One file, everything in sync:

```css
/* configs/colors/colors.css */
@define-color background #1e1e2e;
@define-color foreground #cdd6f4;
@define-color blue       #89b4fa;
@define-color pink       #f38ba8;
@define-color green      #a6e3a1;
@define-color yellow     #f9e2af;
@define-color orange     #fab387;
@define-color purple     #cba6f7;
@define-color gray       #313244;
@define-color surface    #181825;
```

---

## Wallpaper

> **Gotcha:** Hyprpaper does not expand `~/`. Always use full absolute paths.

```ini
preload = /home/YOUR_USERNAME/wallpapers/1.jpg
wallpaper = eDP-1,/home/YOUR_USERNAME/wallpapers/1.jpg
wallpaper = HDMI-A-1,/home/YOUR_USERNAME/wallpapers/1.jpg
```

Startup script with a delay (hyprpaper needs a moment to connect to Wayland socket):

```bash
sleep 3
hyprctl hyprpaper preload "/home/YOUR_USERNAME/wallpapers/1.jpg"
hyprctl hyprpaper wallpaper "eDP-1,/home/YOUR_USERNAME/wallpapers/1.jpg"
hyprctl hyprpaper wallpaper "HDMI-A-1,/home/YOUR_USERNAME/wallpapers/1.jpg"
```

---

## SDDM Login Screen

<!-- ADD: SDDM screenshot -->

```bash
yay -S sddm-theme-catppuccin
sudo nvim /etc/sddm.conf
```

```ini
[Theme]
Current=catppuccin-mocha-blue
```

---

## Browser (Brave) — Staying Signed In on Wayland

Brave uses the system keyring. On Hyprland this needs gnome-keyring:

```bash
yay -S gnome-keyring libsecret
```

```ini
# hyprland.conf
exec-once = gnome-keyring-daemon --start --components=secrets,pkcs11
```

---

## How the Dotfiles Repo Works

`install.sh` creates symlinks — not copies. Edit from anywhere, it's the same file:

```
~/.config/hypr/hyprland.conf  →  ~/devon-rice/configs/hypr/hyprland.conf
~/.config/waybar/style.css    →  ~/devon-rice/configs/waybar/style.css
~/.config/yazi/theme.toml     →  ~/devon-rice/configs/yazi/theme.toml
...etc
```

Just commit and push when you're happy with a change.

---

## Things I Learned the Hard Way

**1. hyprpaper ignores `~/`** — Use `/home/username/` always.

**2. rofi-wayland doesn't support plugins** — The Python calculator workaround is actually better.

**3. Blur on external monitor** — `force_zero_scaling = true` in the xwayland block fixes blurry XWayland apps on a 1.0x external monitor.

**4. Waybar dies when terminal closes** — Launch via `exec-once` in hyprland.conf only.

**5. Hyprexpo needs build deps** — Run `yay -S cmake cpio pkgconf` before `hyprpm update` or it'll fail silently.

**6. GTK4 apps ignore `gtk-theme-name`** — You must symlink the CSS directly into `~/.config/gtk-4.0/gtk.css`. The settings.ini alone isn't enough for GTK4.

**7. cliphist needs wl-paste running** — Add `exec-once = wl-paste --watch cliphist store` to autostart or clipboard history won't accumulate.

---

*Repo: [github.com/anuragdevon/devon-rice](https://github.com/anuragdevon/devon-rice)*
