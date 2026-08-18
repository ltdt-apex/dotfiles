#!/bin/bash

# Get the active window address
WINDOW_ADDRESS=$(hyprctl activewindow -j | jq -r '.address')

if [ -z "$WINDOW_ADDRESS" ]; then
    notify-send "No active window found"
    exit 1
fi

# Get current opacity
CURRENT_OPACITY=$(hyprctl activewindow -j | jq -r '.opacity')

# If opacity is already 1, notify user
if [ "$CURRENT_OPACITY" = "1.000000" ]; then
    notify-send "opacity changed"
    exit 0
fi

# Set opacity to 1 using setprop
hyprctl dispatch setprop "address:$WINDOW_ADDRESS" alphaoverride 1
hyprctl dispatch setprop "address:$WINDOW_ADDRESS" alpha 1.0
hyprctl dispatch setprop "address:$WINDOW_ADDRESS" alphainactiveoverride 1
hyprctl dispatch setprop "address:$WINDOW_ADDRESS" alphainactive 1.0
notify-send "opacity changed"