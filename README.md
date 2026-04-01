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
| File manager | Yazi |
| Browser | Brave |
| Launcher | Rofi (spotlight style) |
| Status bar | Waybar |
| Notifications | Swaync |
| Logout menu | Wlogout |
| Lock screen | Hyprlock |
| Login manager | SDDM (catppuccin-mocha-blue) |
| Wallpaper | Hyprpaper |
| Visualizer | Cava |
| Color scheme | Catppuccin Mocha |
| Font | FiraCode Nerd Font |
| AUR helper | yay |

---

## Quick Install

```bash
# 1. Clone
git clone https://github.com/anuragdevon/devon-rice ~/devon-rice

# 2. Install dependencies
yay -S hyprland ghostty waybar rofi-wayland swaync wlogout hyprlock hyprpaper \
       cava starship zsh-autosuggestions zsh-syntax-highlighting \
       ttf-firacode-nerd papirus-icon-theme noto-fonts-emoji \
       gnome-keyring libsecret neovim yazi wl-clipboard \
       bluez bluez-utils bluetuith

# 3. Run the installer (creates symlinks, optionally backs up existing configs)
cd ~/devon-rice
bash install.sh

# 4. Edit paths in two files for your username
nvim configs/hyprpaper/hyprpaper.conf   # change /home/anurag/ to your username
nvim configs/hypr/set-wallpaper.sh      # same

# 5. Reload or re-login
hyprctl reload
```

---

## Keybindings (i3-style)

| Bind | Action |
|------|--------|
| `Super + Enter` | Open terminal (ghostty) |
| `Super + Q` | Close window |
| `Super + D` | App launcher (rofi) |
| `Super + E` | File manager (yazi) |
| `Super + F` | Fullscreen toggle |
| `Super + L` | Lock screen (hyprlock) |
| `Super + N` | Notification center (swaync) |
| `Super + C` | Audio visualizer (cava) |
| `Super + =` | Calculator (rofi-calc) |
| `Super + B` | Bluetooth manager (bluetuith) |
| `Super + S` | Scratchpad toggle |
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

---

## Monitor Setup

Configured for a dual-monitor setup:

```ini
monitor = eDP-1,  1920x1080@60, 0x0,    1.5   # 15" built-in laptop screen
monitor = HDMI-A-1, 1920x1080@60, 1280x0, 1.0   # 21" external monitor
```

Single-monitor users: remove the `HDMI-A-1` line and the monitor focus/move binds.

---

## Wallpaper Note

Hyprpaper does **not** expand `~/`. Always use full paths in `configs/hyprpaper/hyprpaper.conf` and `configs/hypr/set-wallpaper.sh`:

```ini
# hyprpaper.conf
preload = /home/YOUR_USERNAME/wallpapers/1.jpg
wallpaper = eDP-1,/home/YOUR_USERNAME/wallpapers/1.jpg
wallpaper = HDMI-A-1,/home/YOUR_USERNAME/wallpapers/1.jpg
```

Put your wallpapers in `~/wallpapers/`.

---

## Color Scheme

Catppuccin Mocha. Shared color definitions live in `configs/colors/` — both `.rasi` (for rofi) and `.css` (for waybar, wlogout, swaync) import from here.

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

---

## How Symlinks Work

`install.sh` creates symlinks from `~/.config/<app>/` pointing into this repo. This means editing a file anywhere (in the repo or via `nvim ~/.config/hypr/hyprland.conf`) edits the same file — changes are always reflected in the repo immediately, ready to commit and push.

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
│   │   ├── hyprland.conf       # Main WM config
│   │   ├── hyprlock.conf       # Lock screen config
│   │   └── set-wallpaper.sh    # Wallpaper init script
│   ├── waybar/
│   │   ├── config.jsonc        # Bar layout
│   │   └── style.css           # Bar styling
│   ├── rofi/
│   │   └── config.rasi         # Launcher (spotlight style)
│   ├── ghostty/
│   │   └── config              # Terminal config
│   ├── swaync/
│   │   ├── config.json         # Notification center
│   │   └── style.css
│   ├── wlogout/
│   │   ├── layout              # Power menu layout
│   │   ├── style.css           # Power menu style
│   │   └── icons/              # Button icons
│   ├── hyprpaper/
│   │   └── hyprpaper.conf      # Wallpaper config
│   ├── cava/
│   │   └── config              # Audio visualizer
│   ├── colors/
│   │   ├── colors.css          # Shared colors (CSS)
│   │   └── colors.rasi         # Shared colors (Rofi)
│   ├── starship/
│   │   └── starship.toml       # Prompt config
│   └── yazi/
│       └── keymap.toml         # File manager keymaps
├── install.sh                  # Symlink installer
└── README.md
```

---

## Credits

Visual inspiration from [ViegPhunt/Dotfiles](https://github.com/ViegPhunt/Dotfiles). Previous i3 rice at [anuragdevon/archrice](https://github.com/anuragdevon/archrice).
