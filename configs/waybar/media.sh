#!/bin/bash
# Waybar media module — outputs JSON with class for play/pause styling

status=$(playerctl status 2>/dev/null)

if [ "$status" = "Playing" ] || [ "$status" = "Paused" ]; then
    artist=$(playerctl metadata artist 2>/dev/null)
    title=$(playerctl metadata title 2>/dev/null)
    icon="󰎆"
    class="playing"
    [ "$status" = "Paused" ] && icon="󰏤" && class="paused"

    if [ -n "$artist" ] && [ -n "$title" ]; then
        text="$icon $artist – $title"
    elif [ -n "$title" ]; then
        text="$icon $title"
    else
        echo '{"text": "", "class": "empty"}'
        exit 0
    fi

    # Truncate long text
    if [ "${#text}" -gt 45 ]; then
        text="${text:0:45}…"
    fi

    printf '{"text": "%s", "class": "%s", "tooltip": "Click: play\\/pause  Scroll: prev\\/next"}\n' \
        "$text" "$class"
else
    echo '{"text": "", "class": "empty"}'
fi
