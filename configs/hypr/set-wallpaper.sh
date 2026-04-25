#!/bin/bash
# Pick a random wallpaper from ~/wallpapers/ and apply to all monitors.
# Called on startup (with sleep) and on-demand via keybind.

WALLPAPER_DIR="/home/anurag/wallpapers"

# Pick a random file
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | shuf -n 1)

[ -z "$WALLPAPER" ] && exit 1

# On startup hyprpaper needs a moment; skip sleep when called via keybind
if [ "$1" = "--startup" ]; then
    sleep 3
fi

hyprctl hyprpaper preload "$WALLPAPER"
hyprctl hyprpaper wallpaper "eDP-1,$WALLPAPER"
hyprctl hyprpaper wallpaper "HDMI-A-1,$WALLPAPER"
hyprctl hyprpaper unload all
