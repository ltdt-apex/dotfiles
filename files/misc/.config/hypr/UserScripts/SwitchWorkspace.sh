#!/bin/bash

input=$1
action=${2:-switch}  # default to 'switch' if not provided

# Get the current workspace info
workspace_info=$(hyprctl activeworkspace -j)
current_workspace_id=$(echo "$workspace_info" | jq -r '.id')

# Get the monitor info and find which monitor has this workspace as active
monitor_info=$(hyprctl monitors -j)
current_monitor_id=$(echo "$monitor_info" | jq -r ".[] | select(.activeWorkspace.id==$current_workspace_id) | .id")

if [[ -z "$current_monitor_id" ]]; then
    notify-send "Could not determine current monitor"
    exit 1
fi

# Determine the target workspace
if [[ "$input" =~ ^[+-][0-9]+$ ]]; then
    workspace=$((current_workspace_id + input))
    if [[ "$current_monitor_id" == "1" ]]; then
        workspace=$((current_workspace_id + input))
        if (( workspace < 1 )); then workspace=5; fi
        if (( workspace > 5 )); then workspace=1; fi
    elif [[ "$current_monitor_id" == "0" ]]; then
        if (( workspace < 6 )); then workspace=9; fi
        if (( workspace > 9 )); then workspace=6; fi
    fi
else
    # Absolute mapping logic
    if [[ "$current_monitor_id" == "1" ]]; then
        workspace="$input"
    elif [[ "$current_monitor_id" == "0" ]]; then
        workspace=$((input + 5))
    fi
fi

# Perform the requested action
case "$action" in
    switch)
        hyprctl dispatch workspace "$workspace"
        ;;
    move)
        hyprctl dispatch movetoworkspace "$workspace"
        ;;
    silent|silently)
        hyprctl dispatch movetoworkspacesilent "$workspace"
        ;;
    *)
        notify-send "Unknown action: $action"
        exit 1
        ;;
esac