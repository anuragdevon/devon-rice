#!/bin/bash
# devon-rice install.sh
# Creates symlinks from ~/.config/ to this repo's configs.
# Run this after cloning to wire everything up.

set -e

REPO="$(cd "$(dirname "$0")" && pwd)/configs"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d_%H%M%S)"

echo "devon-rice installer"
echo "===================="
echo "Repo configs: $REPO"
echo ""

# Ask about backups
read -r -p "Back up existing configs before linking? [Y/n] " BACKUP
BACKUP="${BACKUP:-Y}"

do_link() {
    local src="$1"
    local dst="$2"

    # Already a correct symlink — skip
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        echo "  [skip] $dst (already linked)"
        return
    fi

    # Backup if requested and the file exists
    if [[ "$BACKUP" =~ ^[Yy]$ ]] && [ -e "$dst" ] && [ ! -L "$dst" ]; then
        mkdir -p "$BACKUP_DIR/$(dirname "${dst#$HOME/}")"
        cp -r "$dst" "$BACKUP_DIR/${dst#$HOME/}"
        echo "  [bak]  $dst -> $BACKUP_DIR"
    fi

    ln -sf "$src" "$dst"
    echo "  [link] $dst -> $src"
}

mkdir -p \
    "$HOME/.config/hypr" \
    "$HOME/.config/waybar" \
    "$HOME/.config/rofi" \
    "$HOME/.config/ghostty" \
    "$HOME/.config/swaync" \
    "$HOME/.config/wlogout/icons" \
    "$HOME/.config/hyprpaper" \
    "$HOME/.config/cava" \
    "$HOME/.config/colors" \
    "$HOME/.config/starship" \
    "$HOME/.config/yazi"

echo ""
echo "Linking hypr..."
do_link "$REPO/hypr/hyprland.conf"    "$HOME/.config/hypr/hyprland.conf"
do_link "$REPO/hypr/hyprlock.conf"    "$HOME/.config/hypr/hyprlock.conf"
do_link "$REPO/hypr/set-wallpaper.sh" "$HOME/.config/hypr/set-wallpaper.sh"
chmod +x "$REPO/hypr/set-wallpaper.sh"

echo "Linking waybar..."
do_link "$REPO/waybar/config.jsonc" "$HOME/.config/waybar/config.jsonc"
do_link "$REPO/waybar/style.css"    "$HOME/.config/waybar/style.css"

echo "Linking rofi..."
do_link "$REPO/rofi/config.rasi" "$HOME/.config/rofi/config.rasi"

echo "Linking ghostty..."
do_link "$REPO/ghostty/config" "$HOME/.config/ghostty/config"

echo "Linking swaync..."
do_link "$REPO/swaync/config.json" "$HOME/.config/swaync/config.json"
do_link "$REPO/swaync/style.css"   "$HOME/.config/swaync/style.css"

echo "Linking wlogout..."
do_link "$REPO/wlogout/layout"    "$HOME/.config/wlogout/layout"
do_link "$REPO/wlogout/style.css" "$HOME/.config/wlogout/style.css"
# Copy icons (not symlinked — wlogout reads them via relative ./icons/ path)
if [ -d "$REPO/wlogout/icons" ]; then
    cp -rn "$REPO/wlogout/icons/." "$HOME/.config/wlogout/icons/" 2>/dev/null || true
    echo "  [copy] wlogout icons"
fi

echo "Linking hyprpaper..."
do_link "$REPO/hyprpaper/hyprpaper.conf" "$HOME/.config/hyprpaper/hyprpaper.conf"

echo "Linking cava..."
do_link "$REPO/cava/config" "$HOME/.config/cava/config"

echo "Linking colors..."
do_link "$REPO/colors/colors.css"  "$HOME/.config/colors/colors.css"
do_link "$REPO/colors/colors.rasi" "$HOME/.config/colors/colors.rasi"

echo "Linking starship..."
do_link "$REPO/starship/starship.toml" "$HOME/.config/starship/starship.toml"

echo "Linking yazi..."
do_link "$REPO/yazi/keymap.toml" "$HOME/.config/yazi/keymap.toml"

echo ""
echo "Done! All symlinks created."
echo ""
echo "NOTE: Update hyprpaper.conf and set-wallpaper.sh with your actual username/wallpaper paths."
echo "NOTE: Reload Hyprland: hyprctl reload"
if [[ "$BACKUP" =~ ^[Yy]$ ]] && [ -d "$BACKUP_DIR" ]; then
    echo "NOTE: Original configs backed up to $BACKUP_DIR"
fi
