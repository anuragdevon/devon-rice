---
title: My Arch Linux + Hyprland Rice — A Complete Setup Guide (With Dotfiles)
published: false
description: A step-by-step guide to building a sleek, minimal Hyprland rice on Arch Linux with Catppuccin Mocha, i3-style keybindings, and a full dotfiles repo you can clone and replicate in minutes.
tags: linux, archlinux, hyprland, dotfiles
cover_image: [ADD YOUR DESKTOP SCREENSHOT HERE]
---

> Everything in this post is tracked in my dotfiles repo: **[anuragdevon/devon-rice](https://github.com/anuragdevon/devon-rice)**. Clone it, run one script, done.

---

## What You're Building

<!-- ADD: Full desktop screenshot here -->

A complete Hyprland desktop with:

- **Catppuccin Mocha** color scheme throughout — every component shares the same color palette
- **i3-style keybindings** — if you're migrating from i3, your muscle memory works immediately
- **Dual monitor support** — laptop screen (1.5x HiDPI) + external monitor (1.0x) configured correctly
- **A full productivity stack** — launcher, status bar, notifications, lock screen, file manager, calculator, bluetooth — all wired up

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
| File manager | Yazi |
| Browser | Brave |
| Launcher | Rofi (spotlight style) |
| Status bar | Waybar |
| Notifications | Swaync |
| Lock screen | Hyprlock |
| Logout menu | Wlogout |
| Wallpaper | Hyprpaper |
| Audio visualizer | Cava |
| Calculator | rofi-calc (python3 script) |
| Bluetooth | Bluetoothctl |
| Login manager | SDDM (catppuccin-mocha-blue) |
| Font | FiraCode Nerd Font |
| Color scheme | Catppuccin Mocha |
| AUR helper | yay |

---

## Quick Start (Clone and Go)

If you just want to replicate this without reading everything:

```bash
# 1. Install dependencies
yay -S hyprland ghostty waybar rofi-wayland swaync wlogout hyprlock hyprpaper \
       cava starship zsh-autosuggestions zsh-syntax-highlighting \
       ttf-firacode-nerd papirus-icon-theme noto-fonts-emoji \
       gnome-keyring libsecret neovim yazi wl-clipboard \
       bluez bluez-utils sddm

# 2. Clone dotfiles
git clone https://github.com/anuragdevon/devon-rice ~/devon-rice

# 3. Wire up symlinks (backs up your existing configs first)
cd ~/devon-rice && bash install.sh

# 4. Update wallpaper paths with your username
nvim configs/hyprpaper/hyprpaper.conf
nvim configs/hypr/set-wallpaper.sh

# 5. Reload
hyprctl reload
```

The `install.sh` creates symlinks from `~/.config/` into the repo. So any config edit — whether you open it via neovim or directly in the file — is instantly reflected in the repo, ready to push.

---

## Step-by-Step Walkthrough

### 1. Base System

Start with a fresh Arch install. I use `archinstall` for the base, then build up from there. Make sure you have `yay` as your AUR helper:

```bash
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
```

### 2. Hyprland + Core Tools

```bash
yay -S hyprland ghostty waybar rofi-wayland swaync wlogout \
       hyprlock hyprpaper cava wl-clipboard nm-applet
```

### 3. Fonts and Icons

```bash
yay -S ttf-firacode-nerd papirus-icon-theme noto-fonts-emoji
fc-cache -fv
```

### 4. Shell Setup

```bash
yay -S zsh starship zsh-autosuggestions zsh-syntax-highlighting
chsh -s /usr/bin/zsh
```

Add to `~/.zshrc`:

```bash
# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE

# Plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
eval "$(starship init zsh)"
```

---

## Monitor Configuration

The trickiest part of any Hyprland setup on a laptop + external monitor is scaling. Here's what works:

```ini
# Laptop screen — 15", needs 1.5x for comfortable text
monitor = eDP-1, 1920x1080@60, 0x0, 1.5

# External monitor — 21", no scaling needed
# Position at 1280x0 because: 1920 ÷ 1.5 = 1280 logical pixels
monitor = HDMI-A-1, 1920x1080@60, 1280x0, 1.0
```

**Important:** Add this to prevent blurry XWayland apps on the external monitor:

```ini
xwayland {
    force_zero_scaling = true
}

env = GDK_SCALE, 1
env = XDG_SESSION_TYPE, wayland
```

<!-- ADD: Screenshot of dual monitor setup -->

---

## Keybindings (i3-Style)

I came from i3wm, so I mapped everything to match. The full bindings are in `hyprland.conf` but here are the ones you'll use constantly:

| Bind | Action |
|------|--------|
| `Super + Enter` | Open terminal (Ghostty) |
| `Super + Q` | Close window |
| `Super + D` | App launcher (Rofi) |
| `Super + E` | File manager (Yazi) |
| `Super + F` | Fullscreen |
| `Super + L` | Lock screen |
| `Super + B` | Bluetooth |
| `Super + N` | Notification center |
| `Super + C` | Audio visualizer (Cava) |
| `Super + =` | Calculator |
| `Super + Shift + E` | Power menu |
| `Super + Shift + R` | Reload config |
| `Super + hjkl` | Focus window (vim-style) |
| `Super + Shift + hjkl` | Move window |
| `Super + Ctrl + hjkl` | Resize window |
| `Super + 1-0` | Switch workspace |
| `Super + Shift + 1-0` | Move window to workspace |
| `Super + ,` / `Super + .` | Focus left / right monitor |

---

## Component Configs

### Waybar

<!-- ADD: Waybar screenshot -->

Minimal top bar. Catppuccin colors, hover effects, no extra fluff:

```jsonc
{
    "layer": "top",
    "position": "top",
    "modules-left": ["hyprland/workspaces", "hyprland/window"],
    "modules-center": ["clock"],
    "modules-right": ["pulseaudio", "network", "battery", "cpu", "memory", "tray"]
}
```

The style imports from `~/.config/colors/colors.css` — a shared color file used by every component so they all stay in sync.

### Rofi — Spotlight Launcher

<!-- ADD: Rofi screenshot -->

Centered, transparent, spotlight-style. `Super + D` to open:

Key config snippet:
```css
window {
    background-color: rgba(30, 30, 46, 0.85);
    border: 2px solid;
    border-color: @bordercolor;
    border-radius: 20px;
    width: 520px;
    location: center;
    anchor: center;
}
```

### Calculator (No Extra Packages)

`Super + =` opens an inline rofi calculator powered by Python:

```bash
#!/bin/bash
expr=$(rofi -dmenu -p "  " -l 0 -theme-str 'window {width: 420px;}')
[ -z "$expr" ] && exit
result=$(python3 -c "from math import *; print($expr)" 2>/dev/null || echo "Error")
selected=$(echo "$result" | rofi -dmenu -p "  $expr =" -l 1 \
    -theme-str 'window {width: 420px;}' \
    -theme-str 'element-text {text-color: #a6e3a1;}')
[ -n "$selected" ] && echo -n "$selected" | wl-copy
```

Supports `sqrt(144)`, `sin(pi/2)`, `15% * 200` — full Python math. Result is copied to clipboard on select.

<!-- ADD: Calculator screenshot -->

### Hyprlock — Lock Screen

<!-- ADD: Lock screen screenshot -->

Blurred wallpaper, live clock, date, password field. The config is at `configs/hypr/hyprlock.conf`. Key section:

```ini
background {
    path = /home/anurag/wallpapers/1.jpg
    blur_passes = 4
    blur_size = 8
    brightness = 0.5
}

label {
    text = cmd[update:1000] echo "<b>$(date +"%H:%M")</b>"
    font_size = 72
    font_family = FiraCode Nerd Font Bold
}
```

### Swaync — Notification Center

<!-- ADD: Swaync screenshot -->

`Super + N` toggles it. Has quick toggle buttons for WiFi, Bluetooth, mic mute, volume mute, plus media controls and backlight slider built in.

### Wlogout — Power Menu

<!-- ADD: Wlogout screenshot -->

`Super + Shift + E`. Icon-based buttons with a glow animation on hover. Clean fullscreen overlay.

### Cava — Audio Visualizer

<!-- ADD: Cava screenshot -->

`Super + C` opens it in a floating Ghostty window. Catppuccin gradient colors, 18 bars, 60fps:

```ini
[color]
gradient = 1
gradient_count = 8
gradient_color_1 = '#1e1e2e'
gradient_color_8 = '#89b4fa'
```

---

## Wallpaper

> **Gotcha:** Hyprpaper does not expand `~/`. Always use full absolute paths.

```ini
# configs/hyprpaper/hyprpaper.conf
preload = /home/YOUR_USERNAME/wallpapers/1.jpg
wallpaper = eDP-1,/home/YOUR_USERNAME/wallpapers/1.jpg
wallpaper = HDMI-A-1,/home/YOUR_USERNAME/wallpapers/1.jpg
```

Because hyprpaper sometimes needs a moment to connect to the Wayland socket on login, I use a startup script with a small delay instead of relying on the config alone:

```bash
# configs/hypr/set-wallpaper.sh
sleep 3
hyprctl hyprpaper preload "/home/YOUR_USERNAME/wallpapers/1.jpg"
hyprctl hyprpaper wallpaper "eDP-1,/home/YOUR_USERNAME/wallpapers/1.jpg"
hyprctl hyprpaper wallpaper "HDMI-A-1,/home/YOUR_USERNAME/wallpapers/1.jpg"
```

---

## Color Scheme

Everything uses a shared color file. Rofi reads `colors.rasi`, waybar/wlogout/swaync read `colors.css`. Change one file, everything updates.

```css
/* configs/colors/colors.css */
@define-color background  #1e1e2e;
@define-color foreground  #cdd6f4;
@define-color pink        #f38ba8;
@define-color blue        #89b4fa;
@define-color green       #a6e3a1;
@define-color yellow      #f9e2af;
@define-color orange      #fab387;
@define-color purple      #cba6f7;
@define-color red         #f38ba8;
@define-color select      #89b4fa;
```

---

## SDDM Login Screen

<!-- ADD: SDDM login screen screenshot -->

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

Brave uses the system keyring to store credentials. On Hyprland this needs gnome-keyring:

```bash
yay -S gnome-keyring libsecret
```

Add to `hyprland.conf` autostart:
```ini
exec-once = gnome-keyring-daemon --start --components=secrets,pkcs11
```

---

## How the Dotfiles Repo Works

The `install.sh` script creates symlinks — it doesn't copy files. This means:

```
~/.config/hypr/hyprland.conf  →  ~/devon-rice/configs/hypr/hyprland.conf
~/.config/waybar/style.css    →  ~/devon-rice/configs/waybar/style.css
```

Edit a config from anywhere — via `nvim ~/.config/hypr/hyprland.conf` or directly in the repo — it's the same file. Every change is instantly in the repo. Just commit and push when you're happy.

---

## Things I Learned the Hard Way

**1. hyprpaper ignores `~/`** — Use `/home/username/` always. Spent way too long on this.

**2. rofi-wayland doesn't support plugins** — `rofi-calc` plugin needs a non-Wayland rofi build. The Python script workaround works better anyway.

**3. Blur on external monitor** — Setting `force_zero_scaling = true` in xwayland block fixed blurry XWayland apps on my 1.0x external monitor.

**4. Waybar dies when terminal closes** — It needs to be launched via `exec-once` in hyprland.conf, not from a terminal. Took a logout to figure out.

**5. zsh plugins error in bash** — Don't `source ~/.zshrc` while in a bash shell. Switch to `zsh` first.

---

## What's Next

- Screenshot tool (grimblast or hyprshot)
- Idle daemon (hypridle) for auto-lock
- Push the dotfiles to GitHub and add a screenshot to this article

Drop a comment if you run into issues replicating this — happy to help debug!

---

*Repo: [github.com/anuragdevon/devon-rice](https://github.com/anuragdevon/devon-rice)*
