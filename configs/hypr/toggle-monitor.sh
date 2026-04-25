#!/bin/bash
# Toggle between dual monitor (laptop + HDMI) and laptop-only mode.

HDMI="HDMI-A-1"

status=$(hyprctl monitors | grep -c "$HDMI")

if [ "$status" -gt 0 ]; then
    # HDMI active → disable it, move all windows to laptop
    hyprctl keyword monitor "$HDMI,disabled"
    notify-send "󰍹 Monitor" "Switched to laptop only" --icon=video-display
else
    # HDMI off → re-enable it
    hyprctl keyword monitor "$HDMI,1920x1080@60,1280x0,1.0"
    notify-send "󰍹 Monitor" "Dual monitor enabled" --icon=video-display
fi
