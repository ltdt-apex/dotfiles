#!/bin/bash

start_player="spotify-launcher"
player=spotify
player_regex="^([Ss]potify)$" 
action=$1

if [ "$action" = "open-play-pause" ]; then
    player_status=$(playerctl --player=$player status 2>/dev/null)
    if [ "$player_status" = "No players found" ] || [ -z "$player_status" ]; then
        $start_player
    else
        playerctl --player=$player play-pause
    fi
fi

if [ "$action" = "prev" ]; then
        playerctl --player=$player previous
fi

if [ "$action" = "next" ]; then
    playerctl --player=$player next
fi

if [ "$action" = "kill" ]; then
    killall $player
fi

if [ "$action" = "focus" ]; then
    hyprctl dispatch focuswindow class:"$player_regex"
fi

