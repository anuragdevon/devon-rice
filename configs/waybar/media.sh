#!/bin/bash
# Waybar media module — shows current playerctl track

status=$(playerctl status 2>/dev/null)

if [ "$status" = "Playing" ] || [ "$status" = "Paused" ]; then
    artist=$(playerctl metadata artist 2>/dev/null)
    title=$(playerctl metadata title 2>/dev/null)
    icon="󰎆"
    [ "$status" = "Paused" ] && icon="󰏤"

    if [ -n "$artist" ] && [ -n "$title" ]; then
        echo "$icon $artist – $title"
    elif [ -n "$title" ]; then
        echo "$icon $title"
    fi
else
    echo ""
fi
