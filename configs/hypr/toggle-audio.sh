#!/bin/bash
# Audio sink switcher — shows all available sinks in a rofi picker.

get_label() {
    local sink="$1"
    case "$sink" in
        *hdmi*)                          echo "󰍹  HDMI Monitor" ;;
        *usb*bestechnic*|*Bassheads*)    echo "  Bassheads ANC (USB)" ;;
        *bluez*|*bluetooth*)             echo "  Bluetooth" ;;
        *analog*stereo*)                 echo "  Laptop / Wired" ;;
        *)                               echo "  $sink" ;;
    esac
}

# Build list: "Label|sink_name"
entries=""
while IFS= read -r line; do
    sink=$(echo "$line" | awk '{print $2}')
    label=$(get_label "$sink")
    current=$(pactl get-default-sink)
    [ "$sink" = "$current" ] && label="$label  ✓"
    entries+="$label\n"
    sinks+=("$sink")
done < <(pactl list sinks short)

# Show rofi picker
chosen=$(printf "%b" "$entries" | rofi -dmenu -p "󰕾  Audio Output" -i)
[ -z "$chosen" ] && exit 0

# Match chosen label back to sink
index=0
while IFS= read -r line; do
    sink=$(echo "$line" | awk '{print $2}')
    label=$(get_label "$sink")
    if [[ "$chosen" == "$label"* ]]; then
        pactl set-default-sink "$sink"
        # Move all existing streams to new sink
        pactl list sink-inputs short | awk '{print $1}' | \
            xargs -I{} pactl move-sink-input {} "$sink" 2>/dev/null
        notify-send "󰕾 Audio Output" "Switched to $label" --icon=audio-card
        exit 0
    fi
    ((index++))
done < <(pactl list sinks short)
