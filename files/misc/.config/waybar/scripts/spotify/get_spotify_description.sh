#!/bin/bash

player=spotify
spotify_icon=
stop_icon=

while true; do

	player_status=$(playerctl --player=$player status 2>/dev/null)

	display="<span color='#1db954'>$spotify_icon</span>"

	if [ "$player_status" = "Paused" ]; then
		display+=" $stop_icon"
	fi

	if [ "$player_status" = "Playing" ] || [ "$player_status" = "Paused" ]; then
		display+=" $(playerctl --player=$player metadata artist) - $(playerctl --player=$player metadata title)"
	fi

	echo $display

	sleep 1

done