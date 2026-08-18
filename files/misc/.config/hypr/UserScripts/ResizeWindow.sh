#!/bin/bash

direction=$1

# Get the JSON output from hyprctl
window_info=$(hyprctl activewindow -j)

app_monitor_id=$(echo "$window_info" | jq -r '.monitor')
floating=$(echo "$window_info" | jq -r '.floating')
size=$(echo "$window_info" | jq -r '.size')
app_width=$(echo "$size" | jq -r '.[0]')
app_height=$(echo "$size" | jq -r '.[1]')
echo "app_monitor_id: $app_monitor_id"
echo "floating: $floating"
echo "size: $size"
echo "app_width: $app_width"
echo "app_height: $app_height"

monitor_info=$(hyprctl monitors -j)
monitor_info=$(echo "$monitor_info" | jq --argjson id "$app_monitor_id" '.[] | select(.id==$id)')
monitor_width=$(echo "$monitor_info" | jq -r '.width' | bc)
monitor_height=$(echo "$monitor_info" | jq -r '.height' | bc)
width_ratio=$(echo "scale=2; $app_width/$monitor_width*100" | bc)
height_ratio=$(echo "scale=2; $app_height/$monitor_height*100" | bc)
echo "monitor_width: $monitor_width"
echo "monitor_height: $monitor_height"
echo "width_ratio: $width_ratio"
echo "height_ratio: $height_ratio"


if [[ "$floating" == "true" ]]; then
    # Move the floating window based on direction
    case $direction in
        "resize")
            width=40
            height=40

            if [[ $(echo "scale=2; $width_ratio < 40" | bc) -eq 1 ]] && [[ $(echo "scale=2; $height_ratio < 40" | bc) -eq 1 ]]; then
                echo "40% 40%"
                width=40
                height=40
            elif [[ $(echo "scale=2; $width_ratio < 50" | bc) -eq 1 ]] && [[ $(echo "scale=2; $height_ratio < 65" | bc) -eq 1 ]]; then
                echo "50% 65%"
                width=50
                height=65
            elif [[ $(echo "scale=2; $width_ratio < 70" | bc) -eq 1 ]] && [[ $(echo "scale=2; $height_ratio < 85" | bc) -eq 1 ]]; then
                echo "70% 85%"
                width=70
                height=85
            elif [[ $(echo "scale=2; $width_ratio < 96" | bc) -eq 1 ]] && [[ $(echo "scale=2; $height_ratio < 91" | bc) -eq 1 ]]; then
                echo "97% 92%"
                width=97
                height=92
            else
                echo "40% 40%"
                width=40
                height=40
            fi

            echo "adjusting to ${width}% ${height}% ..."
            hyprctl dispatch resizeactive exact ${width}% ${height}%
            echo "centering ..."
            hyprctl dispatch centerwindow
            ;;
        "resizeup")
            hyprctl dispatch resizeactive 0 -20
            ;;
        "resizedown")
            hyprctl dispatch resizeactive 0 20
            ;;
        "resizeleft")
            hyprctl dispatch resizeactive -20 0
            ;;
        "resizeright")
            hyprctl dispatch resizeactive 20 0
            ;;
        "up")
            hyprctl dispatch moveactive 0 -50
            ;;
        "down")
            hyprctl dispatch moveactive 0 50
            ;;
        "left")
            hyprctl dispatch moveactive -50 0
            ;;
        "right")
            hyprctl dispatch moveactive 50 0
            ;;
        *)
            echo "Invalid direction: $direction"
            exit 1
            ;;
    esac
else
    # Move the tiled window based on direction
    case $direction in
        "resizeup")
            hyprctl dispatch resizeactive 0 -50
            ;;
        "resizedown")
            hyprctl dispatch resizeactive 0 50
            ;;
        "resizeleft")
            hyprctl dispatch resizeactive -50 0
            ;;
        "resizeright")
            hyprctl dispatch resizeactive 50 0
            ;;
        "up")
            hyprctl dispatch movewindow u
            ;;
        "down")
            hyprctl dispatch movewindow d
            ;;
        "left")
            hyprctl dispatch movewindow l
            ;;
        "right")
            hyprctl dispatch movewindow r
            ;;
        *)
            echo "Invalid direction: $direction"
            exit 1
            ;;
    esac
fi