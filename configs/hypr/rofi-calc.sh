#!/bin/bash
# Rofi calculator using python3 — no extra dependencies needed.
# Super + = to open. Type any expression, Enter to evaluate.
# Selecting the result copies it to clipboard.

expr=$(rofi -dmenu -p "  " -l 0 -theme-str 'window {width: 420px;}')
[ -z "$expr" ] && exit

result=$(python3 -c "from math import *; print($expr)" 2>/dev/null || echo "Error")

# Show result as a list item — press Enter to copy to clipboard
selected=$(echo "$result" | rofi -dmenu -p "  $expr =" -l 1 \
    -theme-str 'window {width: 420px;}' \
    -theme-str 'element-text {text-color: #a6e3a1;}')

[ -n "$selected" ] && echo -n "$selected" | wl-copy
