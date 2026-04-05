#!/bin/bash
# Toggle default audio sink between HDMI monitor and Bluetooth.

HDMI="alsa_output.pci-0000_03_00.1.hdmi-stereo"
BT="bluez_output.23:38:1F:31:A4:67"

current=$(pactl get-default-sink)

if [ "$current" = "$HDMI" ]; then
    pactl set-default-sink "$BT"
    notify-send -i audio-headphones "Audio → Bluetooth" "Switched to Bluetooth headphones"
else
    pactl set-default-sink "$HDMI"
    notify-send -i audio-card "Audio → Monitor" "Switched to HDMI monitor"
fi
