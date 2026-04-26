# devon-rice

My personal Arch Linux + Hyprland rice. Catppuccin Mocha throughout, i3-style keybindings, dual-monitor setup.

![Setup](https://via.placeholder.com/900x500/1e1e2e/cdd6f4?text=Add+a+screenshot+here)

---

## Stack

| Role | Tool |
|------|------|
| WM | Hyprland 0.54.3 (Wayland) |
| Terminal | Ghostty |
| Shell | Zsh + Starship |
| Editor | Neovim |
| File manager | Nautilus (GTK4, Catppuccin themed) |
| Browser | Brave |
| Launcher | Rofi (spotlight style) |
| Status bar | Waybar |
| Notifications | Swaync |
| Logout menu | Wlogout |
| Lock screen | Hyprlock |
| Login manager | SDDM (catppuccin-mocha-blue) |
| Wallpaper | Hyprpaper |
| Visualizer | Cava |
| Clipboard | Cliphist + wl-clipboard |
| Color scheme | Catppuccin Mocha |
| Font | FiraCode Nerd Font |
| Icons | Papirus-Dark |
| Cursor | Bibata Modern Classic |
| AUR helper | yay |

---

## Quick Install

```bash
# 1. Clone
git clone https://github.com/anuragdevon/devon-rice ~/devon-rice

# 2. Install dependencies
yay -S hyprland ghostty waybar rofi-wayland swaync wlogout hyprlock hyprpaper \
       cava starship zsh-autosuggestions zsh-syntax-highlighting \
       ttf-firacode-nerd papirus-icon-theme bibata-cursor-theme noto-fonts-emoji \
       gnome-keyring libsecret neovim nautilus \
       catppuccin-gtk-theme-mocha kvantum qt6ct \
       cliphist wl-clipboard playerctl \
       grim slurp socat jq \
       bluez bluez-utils bluetuith

# 3. Run the installer
cd ~/devon-rice
bash install.sh

# 4. Symlink GTK4 CSS for Nautilus
ln -sf /usr/share/themes/catppuccin-mocha-blue-standard+default/gtk-4.0/gtk.css ~/.config/gtk-4.0/gtk.css
ln -sf /usr/share/themes/catppuccin-mocha-blue-standard+default/gtk-4.0/gtk-dark.css ~/.config/gtk-4.0/gtk-dark.css

# 5. Set up hyprexpo plugin
hyprpm add https://github.com/hyprwm/hyprland-plugins
hyprpm enable hyprexpo

# 6. Edit paths for your username
nvim configs/hyprpaper/hyprpaper.conf
nvim configs/hypr/set-wallpaper.sh

# 7. Reload
hyprctl reload
```

---

## Keybindings (i3-style)

| Bind | Action |
|------|--------|
| `Super + Enter` | Open terminal (ghostty) |
| `Super + Q` | Close window |
| `Super + D` | App launcher (rofi) |
| `Super + E` | File manager (nautilus) |
| `Super + F` | Fullscreen toggle |
| `Super + L` | Lock screen (hyprlock) |
| `Super + N` | Notification center (swaync) |
| `Super + C` | Audio visualizer (cava) |
| `Super + Tab` | Workspace overview (hyprexpo) |
| `Super + V` | Layout split toggle |
| `Super + Shift + V` | Clipboard history (cliphist) |
| `Super + Shift + S` | Screenshot region → clipboard |
| `Print` | Screenshot active window → clipboard |
| `Super + Print` | Screenshot full monitor → clipboard |
| `Super + Ctrl + S` | Screenshot region → save file |
| `Shift + Print` | Screenshot active window → save file |
| `Ctrl + Print` | Screenshot full monitor → save file |
| `Super + =` | Calculator (rofi-calc) |
| `Super + B` | Bluetooth (bluetoothctl) |
| `Super + Shift + A` | Audio sink picker (Rofi — all devices) |
| `Super + Shift + M` | Toggle dual monitor ↔ laptop only |
| `Super + Shift + W` | Randomize wallpaper |
| `Super + S` | Scratchpad toggle |
| `Super + Shift + -` | Move window to scratchpad |
| `Super + Shift + E` | Power menu (wlogout) |
| `Super + Shift + R` | Reload Hyprland config |
| `Super + Shift + Space` | Toggle floating |
| `Super + hjkl / arrows` | Focus window |
| `Super + Shift + hjkl` | Move window |
| `Super + Ctrl + hjkl` | Resize window |
| `Super + 1-0` | Switch workspace |
| `Super + Shift + 1-0` | Move window to workspace |
| `Super + ,` | Focus left monitor (eDP-1) |
| `Super + .` | Focus right monitor (HDMI-A-1) |
| `Super + Shift + ,` | Move window to left monitor |
| `Super + Shift + .` | Move window to right monitor |
| `Super + mouse scroll` | Cycle workspaces |
| `Super + RMB drag` | Resize window (mouse) |
| `Super + LMB drag` | Move window (mouse) |

---

## Workspace Layout

| Workspace | Label | Use |
|-----------|-------|-----|
| 1 |  Brave | Browser |
| 2 |  Code | Editor / IDE |
| 3 |  Term | Terminal |
| 4 |  Music | Spotify / audio |
| 5 | 󰃽 Edit | Video editing |
| 6 | 󰙯 Discord | Chat |
| 7 |  Games | Gaming |
| 8 |  Tools | System tools |
| 9 |  Videos | Media playback |
| 0 |  Buffer | Scratch / overflow |

---

## Monitor Setup

```ini
monitor = eDP-1,    1920x1080@60, 0x0,    1.5   # 15" built-in laptop
monitor = HDMI-A-1, 1920x1080@60, 1280x0, 1.0   # 21" external
```

Single-monitor: remove the `HDMI-A-1` line and the monitor focus/move binds.

---

## Wallpaper Note

Hyprpaper does **not** expand `~/`. Always use full paths:

```ini
preload = /home/YOUR_USERNAME/wallpapers/1.jpg
wallpaper = eDP-1,/home/YOUR_USERNAME/wallpapers/1.jpg
wallpaper = HDMI-A-1,/home/YOUR_USERNAME/wallpapers/1.jpg
```

Put wallpapers in `~/wallpapers/`.

---

## Color Scheme

Catppuccin Mocha. Shared definitions in `configs/colors/` — imported by waybar, swaync, rofi, wlogout.

| Role | Hex |
|------|-----|
| Background | `#1e1e2e` |
| Foreground | `#cdd6f4` |
| Accent (blue) | `#89b4fa` |
| Pink | `#f38ba8` |
| Green | `#a6e3a1` |
| Yellow | `#f9e2af` |
| Orange | `#fab387` |
| Purple | `#cba6f7` |
| Gray | `#313244` |
| Surface | `#181825` |

---

## How Symlinks Work

`install.sh` creates symlinks from `~/.config/<app>/` into this repo. Editing a config anywhere edits the same file — changes are always in the repo ready to commit.

```
~/.config/hypr/hyprland.conf  →  ~/devon-rice/configs/hypr/hyprland.conf
~/.config/waybar/style.css    →  ~/devon-rice/configs/waybar/style.css
...etc
```

---

## Repo Structure

```
devon-rice/
├── configs/
│   ├── hypr/
│   │   ├── hyprland.conf           # Main WM config
│   │   ├── hyprlock.conf           # Lock screen
│   │   ├── hypridle.conf           # Idle daemon (dim → lock → suspend)
│   │   ├── set-wallpaper.sh        # Random wallpaper picker
│   │   ├── toggle-audio.sh         # Rofi audio sink switcher
│   │   ├── toggle-monitor.sh       # Dual ↔ laptop-only toggle
│   │   ├── rofi-calc.sh            # Python calculator via Rofi
│   │   └── workspace-labels.sh     # Dynamic workspace naming (optional)
│   ├── waybar/
│   │   ├── config.jsonc            # Bar layout
│   │   ├── style.css               # Bar styling
│   │   └── media.sh                # Playerctl media script (JSON output)
│   ├── rofi/
│   │   └── config.rasi
│   ├── ghostty/
│   │   └── config
│   ├── swaync/
│   │   ├── config.json
│   │   └── style.css
│   ├── wlogout/
│   │   ├── layout
│   │   ├── style.css
│   │   └── icons/
│   ├── hyprpaper/
│   │   └── hyprpaper.conf
│   ├── cava/
│   │   └── config
│   ├── colors/
│   │   ├── colors.css              # Shared colors (CSS)
│   │   └── colors.rasi             # Shared colors (Rofi)
│   ├── starship/
│   │   └── starship.toml
│   ├── yazi/
│   │   ├── keymap.toml
│   │   ├── theme.toml              # Catppuccin Mocha theme
│   │   └── yazi.toml               # General settings + nvim opener
│   ├── gtk-3.0/
│   │   └── settings.ini            # GTK3 theme
│   ├── gtk-4.0/
│   │   └── settings.ini            # GTK4 theme (Nautilus)
│   └── fontconfig/
│       └── fonts.conf              # Noto Sans default, FiraCode mono
├── install.sh
└── README.md
```

---

## Credits

Visual inspiration from [ViegPhunt/Dotfiles](https://github.com/ViegPhunt/Dotfiles) and [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland). Previous i3 rice at [anuragdevon/archrice](https://github.com/anuragdevon/archrice).
