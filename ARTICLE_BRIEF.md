# Article Brief: My Arch Linux + Hyprland Rice

> Feed this entire file to an AI article writer to produce a dev.to post.
> Screenshots to be added manually after generation — placeholders are marked.

---

## AUTHOR CONTEXT

- Name: Anurag
- GitHub: anuragdevon
- Background: Came from i3wm on Arch Linux. Old rice: github.com/anuragdevon/archrice
- Visual inspiration: github.com/ViegPhunt/Dotfiles
- This rice repo: github.com/anuragdevon/devon-rice
- The article should feel personal, practical, and opinionated — not a dry tutorial

---

## ARTICLE GOAL

A dev.to post that:
1. Shows off the final setup visually (screenshots placeholders included)
2. Explains every component and why it was chosen
3. Gives a complete step-by-step so anyone on Arch can replicate it
4. Shares real gotchas hit during setup — not just the happy path
5. Points to the dotfiles repo so readers can clone and go

Target audience: Arch Linux users, people migrating from i3wm, anyone wanting a polished Wayland rice.

---

## HARDWARE

- Machine: HP Laptop 15s-gr0xxx
- CPU: AMD Ryzen 3 3250U (4 cores @ 2.60 GHz)
- GPU: AMD Radeon Vega 3 (integrated — keep blur passes at max 3)
- RAM: 13.59 GiB
- Storage: / → 32 GiB (ext4), /home → 201 GiB (ext4)
- Monitors:
  - eDP-1: 15" built-in laptop screen, 1920x1080@60Hz
  - HDMI-A-1: 21" external SAC monitor, 1920x1080@60Hz
- OS: Arch Linux x86_64, Kernel 6.19.9-arch1-1
- WM: Hyprland 0.54.3 (Wayland)

---

## FULL STACK

| Role              | Tool                          |
|-------------------|-------------------------------|
| Window manager    | Hyprland                      |
| Terminal          | Ghostty                       |
| Shell             | Zsh + Starship                |
| Editor            | Neovim                        |
| File manager      | Yazi (in Ghostty)             |
| Browser           | Brave                         |
| Launcher          | Rofi (spotlight style)        |
| Status bar        | Waybar                        |
| Notifications     | Swaync                        |
| Lock screen       | Hyprlock                      |
| Logout menu       | Wlogout                       |
| Wallpaper         | Hyprpaper                     |
| Audio visualizer  | Cava                          |
| Calculator        | Custom rofi + python3 script  |
| Bluetooth         | Bluetoothctl (in Ghostty)     |
| Audio toggle      | Custom toggle-audio.sh script |
| Login manager     | SDDM (catppuccin-mocha-blue)  |
| Font              | FiraCode Nerd Font            |
| Icons             | Papirus-Dark                  |
| Color scheme      | Catppuccin Mocha              |
| AUR helper        | yay                           |

---

## COLOR SCHEME

Catppuccin Mocha throughout. A single shared color file (`~/.config/colors/`) is imported by every component — rofi, waybar, wlogout, swaync — so they all stay in sync.

```css
/* ~/.config/colors/colors.css */
@define-color background  #1e1e2e;
@define-color foreground  #cdd6f4;
@define-color pink        #f38ba8;
@define-color blue        #89b4fa;   /* primary accent */
@define-color green       #a6e3a1;
@define-color yellow      #f9e2af;
@define-color orange      #fab387;
@define-color purple      #cba6f7;
@define-color red         #f38ba8;
@define-color select      #89b4fa;
```

Same colors in `.rasi` format for Rofi.

---

## INSTALLATION (QUICK START)

```bash
# 1. Install all dependencies
yay -S hyprland ghostty waybar rofi-wayland swaync wlogout hyprlock hyprpaper \
       cava starship zsh-autosuggestions zsh-syntax-highlighting \
       ttf-firacode-nerd papirus-icon-theme noto-fonts-emoji \
       gnome-keyring libsecret neovim yazi wl-clipboard \
       bluez bluez-utils sddm sddm-theme-catppuccin

# 2. Clone the dotfiles
git clone https://github.com/anuragdevon/devon-rice ~/devon-rice

# 3. Run the installer — backs up existing configs, creates symlinks
cd ~/devon-rice && bash install.sh

# 4. Update wallpaper paths (hyprpaper doesn't expand ~/)
nvim configs/hyprpaper/hyprpaper.conf   # replace /home/anurag/ with your username
nvim configs/hypr/set-wallpaper.sh      # same

# 5. Update audio toggle with your Bluetooth MAC
nvim configs/hypr/toggle-audio.sh      # replace BT MAC address

# 6. Enable bluetooth and SDDM
sudo systemctl enable --now bluetooth
sudo systemctl enable sddm

# 7. Reload
hyprctl reload
```

---

## HOW SYMLINKS WORK

`install.sh` creates symlinks, not copies:

```
~/.config/hypr/hyprland.conf     →  ~/devon-rice/configs/hypr/hyprland.conf
~/.config/waybar/style.css       →  ~/devon-rice/configs/waybar/style.css
~/.config/rofi/config.rasi       →  ~/devon-rice/configs/rofi/config.rasi
... (all configs)
```

This means editing a file from anywhere (terminal, neovim, file manager) edits the repo file directly. Just `git add && git commit && git push` whenever you want to save a snapshot.

---

## MONITOR CONFIGURATION (IMPORTANT)

```ini
# hyprland.conf
monitor = eDP-1,    1920x1080@60, 0x0,    1.5   # 15" laptop screen — HiDPI
monitor = HDMI-A-1, 1920x1080@60, 1280x0, 1.0   # 21" external monitor

# Why 1280x0 for the external?
# Laptop logical width = 1920 ÷ 1.5 = 1280px
# So external monitor starts right where laptop ends

xwayland {
    force_zero_scaling = true   # prevents blurry XWayland apps on external monitor
}

env = GDK_SCALE, 1
env = XDG_SESSION_TYPE, wayland
```

Single monitor users: remove the HDMI-A-1 line and the monitor focus/move binds.

---

## KEYBINDINGS (COMPLETE)

All i3-style. Migrating from i3? Your fingers already know these.

```ini
$mainMod = SUPER

# Core
Super + Enter          → Open terminal (Ghostty)
Super + Q              → Close window
Super + D              → App launcher (Rofi)
Super + E              → File manager (Yazi in Ghostty)
Super + F              → Fullscreen toggle
Super + Shift + Space  → Toggle floating

# Navigation (vim-style)
Super + h/j/k/l        → Focus window
Super + arrows         → Focus window (alternative)
Super + Shift + hjkl   → Move window
Super + Ctrl  + hjkl   → Resize window

# Workspaces
Super + 1-0            → Switch workspace
Super + Shift + 1-0    → Move window to workspace
Super + scroll         → Cycle workspaces

# Multi-monitor
Super + ,              → Focus laptop screen (eDP-1)
Super + .              → Focus external monitor (HDMI-A-1)
Super + Shift + ,      → Move window to laptop screen
Super + Shift + .      → Move window to external monitor

# Apps / tools
Super + L              → Lock screen (Hyprlock)
Super + B              → Bluetooth (bluetoothctl in Ghostty)
Super + N              → Notification center (Swaync)
Super + C              → Audio visualizer (Cava)
Super + =              → Calculator (Rofi + Python)
Super + S              → Scratchpad toggle
Super + Shift + A      → Toggle audio (HDMI ↔ Bluetooth)
Super + Shift + B      → Open Brave
Super + Shift + E      → Power menu (Wlogout)
Super + Shift + R      → Reload Hyprland config

# Media keys (fn keys work natively)
XF86AudioRaiseVolume   → Volume +5%
XF86AudioLowerVolume   → Volume -5%
XF86AudioMute          → Mute toggle
XF86AudioMicMute       → Mic mute toggle
XF86MonBrightnessUp    → Brightness +5%
XF86MonBrightnessDown  → Brightness -5%
XF86AudioNext/Prev     → Next/prev track
XF86AudioPlay/Pause    → Play/pause
```

---

## COMPONENT DETAILS

### Hyprland Config Highlights

```ini
general {
    gaps_in = 5
    gaps_out = 20
    border_size = 2
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg  # gradient border
    col.inactive_border = rgba(595959aa)
    layout = dwindle
}

decoration {
    rounding = 10
    inactive_opacity = 0.9    # inactive windows slightly transparent
    blur {
        enabled = true
        size = 6
        passes = 3            # keep at 3 max on AMD Vega 3
        vibrancy = 0.1696
    }
}
```

### Ghostty Terminal

```ini
# ~/.config/ghostty/config
background-opacity = 0.85
window-padding-x = 12
window-padding-y = 12
font-family = FiraCode Nerd Font
font-size = 12
```

Blur shows through the transparent background from Hyprland's decoration.blur block.

### Rofi — Spotlight Style

Centered, transparent, 520px wide, 6 results, no scrollbar:

```css
window {
    background-color: rgba(30, 30, 46, 0.85);
    border: 2px solid;
    border-color: @bordercolor;
    border-radius: 20px;
    width: 520px;
    location: center;
    anchor: center;
    y-offset: -200;     /* sits slightly above center */
}
element.selected.normal {
    background-color: rgba(137, 180, 250, 0.2);
    border: 1px solid;
    border-color: @bordercolor;
}
```

### Calculator — No Extra Packages

rofi-wayland doesn't support plugins so rofi-calc doesn't work. Solution: a tiny bash script using Python's math library:

```bash
#!/bin/bash
# ~/.config/hypr/rofi-calc.sh
expr=$(rofi -dmenu -p "  " -l 0 -theme-str 'window {width: 420px;}')
[ -z "$expr" ] && exit

result=$(python3 -c "from math import *; print($expr)" 2>/dev/null || echo "Error")

selected=$(echo "$result" | rofi -dmenu -p "  $expr =" -l 1 \
    -theme-str 'window {width: 420px;}' \
    -theme-str 'element-text {text-color: #a6e3a1;}')

[ -n "$selected" ] && echo -n "$selected" | wl-copy
```

- Step 1: rofi prompt — type expression
- Step 2: result shown in green as a list item
- Step 3: press Enter — result copied to clipboard via wl-copy
- Supports: `sqrt(144)`, `sin(pi/2)`, `15*8`, `2**10`, full Python math

### Waybar

Top bar, transparent, Catppuccin colors:
- Left: workspaces + active window title
- Center: clock
- Right: volume, network, battery, CPU, memory, tray

Uses PipeWire's PulseAudio compatibility layer — the `pulseaudio` module in waybar works fine.

### Hyprlock — Lock Screen

```ini
background {
    path = /home/anurag/wallpapers/1.jpg
    blur_passes = 4
    blur_size = 8
    brightness = 0.5
}
# Shows: blurred wallpaper + large clock (72pt) + date + password field
# Font: FiraCode Nerd Font Bold
# Colors: Catppuccin Mocha
```

### Wlogout — Power Menu

Icon-based fullscreen overlay. Glow animation on hover (CSS keyframe animation).
Actions: lock, logout, suspend, hibernate, reboot, shutdown.

### Swaync — Notification Center

`Super + N` to toggle. Built-in quick toggles for WiFi, Bluetooth, mic, volume mute. Media controls (MPRIS). Backlight slider.

### Cava — Audio Visualizer

Floating Ghostty window (`Super + C`), 18 bars, 60fps, Catppuccin gradient colors from dark to blue. Uses PipeWire input directly.

### Bluetooth

```bash
# Super + B opens this in a floating ghostty window
bluetoothctl
> power on
> scan on
> pair XX:XX:XX
> connect XX:XX:XX
```

### Audio Toggle (HDMI ↔ Bluetooth)

```bash
#!/bin/bash
# ~/.config/hypr/toggle-audio.sh
HDMI="alsa_output.pci-0000_03_00.1.hdmi-stereo"
BT="bluez_output.XX:XX:XX:XX:XX:XX"   # your BT MAC from: pactl list sinks short

current=$(pactl get-default-sink)
if [ "$current" = "$HDMI" ]; then
    pactl set-default-sink "$BT"
    notify-send -i audio-headphones "Audio → Bluetooth" "Switched to Bluetooth headphones"
else
    pactl set-default-sink "$HDMI"
    notify-send -i audio-card "Audio → Monitor" "Switched to HDMI monitor"
fi
```

`Super + Shift + A` — swaync notification confirms the switch.

### Starship Prompt

Powerline-style segments: OS → username → directory → git branch/status → time.
Configured in `~/.config/starship/starship.toml`.

### Hyprpaper Wallpaper

**Critical gotcha: hyprpaper does not expand `~/`. Always use full absolute paths.**

Using a startup script instead of pure config for reliability:

```bash
# ~/.config/hypr/set-wallpaper.sh
sleep 3   # wait for compositor to be ready
hyprctl hyprpaper preload "/home/anurag/wallpapers/1.jpg"
hyprctl hyprpaper wallpaper "eDP-1,/home/anurag/wallpapers/1.jpg"
hyprctl hyprpaper wallpaper "HDMI-A-1,/home/anurag/wallpapers/1.jpg"
```

### SDDM Login Screen

```ini
# /etc/sddm.conf
[Theme]
Current=catppuccin-mocha-blue
```

### Brave Browser — Staying Signed In

Brave uses the system keyring. On Wayland this needs gnome-keyring:

```ini
# hyprland.conf autostart
exec-once = gnome-keyring-daemon --start --components=secrets,pkcs11
```

### Zsh History Persistence

```bash
# ~/.zshrc
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE
```

---

## REAL GOTCHAS (important — include these in the article)

1. **hyprpaper ignores `~/`** — Spent hours on this. Use `/home/username/` always. No exceptions.

2. **rofi-wayland kills rofi-calc** — The Wayland fork of rofi strips out plugin support. `rofi-calc` needs the X11 build. Solution: replaced with a 10-line Python bash script that's actually better.

3. **Blurry text on external monitor** — External monitor was blurry despite correct scaling. Fix: `force_zero_scaling = true` in the xwayland block + `GDK_SCALE=1`.

4. **External monitor positioning gap** — With laptop at 1.5x scale, its logical width is 1280px (not 1920px). External monitor must be positioned at 1280x0, not 1920x0. Hyprland uses logical pixels for positioning.

5. **Waybar dies when terminal closes** — `pkill waybar; waybar &` in terminal ties it to the shell session. Must be launched via `exec-once` in hyprland.conf. Took a full logout to figure out.

6. **Brave signs out every restart** — gnome-keyring wasn't starting. Fixed by adding it to exec-once.

7. **zsh plugins error in bash** — Running `source ~/.zshrc` in bash throws errors because zsh plugin syntax is incompatible. Always switch to zsh first: `zsh && source ~/.zshrc`.

8. **swww vs awww** — When running `yay -S swww`, yay matched `awww` (a different package) instead. Always verify what yay actually installed. Switched to hyprpaper to avoid the mess entirely.

9. **hyprlock only works inside Hyprland** — It's a screen locker, not a display manager. SDDM is what you see when you log out. Themed separately.

10. **Waybar pulseaudio module on PipeWire** — Sounds like it shouldn't work, but it does. PipeWire ships a PulseAudio compatibility layer so the waybar pulseaudio module works perfectly. No need for the pipewire module.

---

## REPO STRUCTURE

```
devon-rice/
├── configs/
│   ├── hypr/
│   │   ├── hyprland.conf       # Main WM config — monitors, keybinds, rules
│   │   ├── hyprlock.conf       # Lock screen
│   │   ├── set-wallpaper.sh    # Wallpaper init (sleep + hyprctl)
│   │   ├── rofi-calc.sh        # Calculator script
│   │   └── toggle-audio.sh     # HDMI ↔ Bluetooth audio toggle
│   ├── waybar/
│   │   ├── config.jsonc        # Bar layout and modules
│   │   └── style.css           # Bar styling
│   ├── rofi/
│   │   └── config.rasi         # Spotlight-style launcher
│   ├── ghostty/
│   │   └── config              # Terminal — opacity, padding, font
│   ├── swaync/
│   │   ├── config.json         # Notification center with quick toggles
│   │   └── style.css
│   ├── wlogout/
│   │   ├── layout              # Power menu buttons
│   │   ├── style.css           # Glow animation style
│   │   └── icons/              # Button PNGs
│   ├── hyprpaper/
│   │   └── hyprpaper.conf      # Wallpaper (absolute paths only)
│   ├── cava/
│   │   └── config              # Visualizer — 18 bars, pipewire, gradient
│   ├── colors/
│   │   ├── colors.css          # Shared Catppuccin colors for CSS components
│   │   └── colors.rasi         # Shared Catppuccin colors for Rofi
│   ├── starship/
│   │   └── starship.toml       # Prompt config
│   └── yazi/
│       └── keymap.toml         # File manager keymaps (t = open ghostty here)
├── install.sh                  # Symlink installer with backup
└── README.md
```

---

## SCREENSHOTS TO INSERT

The article writer should leave these as clearly labelled placeholders:

1. **COVER** — Full desktop overview (both monitors ideally)
2. **DESKTOP** — Clean desktop with wallpaper and waybar visible
3. **ROFI** — Spotlight launcher open (Super+D)
4. **WAYBAR** — Status bar closeup
5. **HYPRLOCK** — Lock screen with clock
6. **SWAYNC** — Notification center open (Super+N)
7. **WLOGOUT** — Power menu overlay
8. **CAVA** — Audio visualizer floating window
9. **CALCULATOR** — rofi-calc in action (Super+=)
10. **YAZI** — File manager in ghostty
11. **SDDM** — Login screen

---

## TONE GUIDANCE FOR THE ARTICLE

- Personal and opinionated, not a dry wiki page
- Explain *why* each tool was chosen, not just *what* it is
- The gotchas section should feel like "I actually went through this, here's what I learned"
- Migrating from i3wm angle is a strong hook — lean into it
- Keep code blocks clean and well-commented
- End with a CTA: star the repo, drop a comment with their setup
- Tags: `linux`, `archlinux`, `hyprland`, `dotfiles`
- Platform: dev.to
