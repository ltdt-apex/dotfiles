#!/bin/bash

# Get all window addresses
window_addresses=$(hyprctl clients -j | jq -r '.[].address')

if [ -z "$window_addresses" ]; then
    notify-send "No windows found"
    exit 1
fi

for addr in $window_addresses; do
    hyprctl dispatch setprop "address:$addr" alphaoverride 1
    hyprctl dispatch setprop "address:$addr" alpha 1.0
    hyprctl dispatch setprop "address:$addr" alphainactiveoverride 1
    hyprctl dispatch setprop "address:$addr" alphainactive 1.0
done

notify-send "opacity changed" 