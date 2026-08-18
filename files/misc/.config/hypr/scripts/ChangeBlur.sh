#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Script for changing blurs on the fly

notif="$HOME/.config/swaync/images/bell.png"

STATE=$(hyprctl -j getoption decoration:blur:passes | jq ".int")

case $STATE in
	4)
		hyprctl keyword decoration:blur:size 2
		hyprctl keyword decoration:blur:passes 1
		notify-send -e -u low -i "$notif" "Less blur"
		;;
	1)
		hyprctl keyword decoration:blur:size 5
		hyprctl keyword decoration:blur:passes 2
		notify-send -e -u low -i "$notif" "Normal blur"
		;;
	2)
		hyprctl keyword decoration:blur:size 7
		hyprctl keyword decoration:blur:passes 3
		notify-send -e -u low -i "$notif" "More blur"
		;;
	*)
		hyprctl keyword decoration:blur:size 10
		hyprctl keyword decoration:blur:passes 4
		notify-send -e -u low -i "$notif" "Max blur"
		;;
esac
