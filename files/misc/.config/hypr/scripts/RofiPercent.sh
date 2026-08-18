#!/bin/bash
# Rofi Percent Calculator

rofi_config="$HOME/.config/rofi/config-calc.rasi"

# Prompt user for a value
while true; do
    input=$(echo -e "$output" | rofi -dmenu -i -config "$rofi_config")

    # Exit if cancelled or empty
    if [ -z "$input" ]; then
        exit 0
    fi

    # Validate input (number)
    if ! echo "$input" | grep -Eq '^[-+]?[0-9]*\.?[0-9]+$'; then
        notify-send "Invalid input: $input"
        exit 1
    fi

    # Calculate percentages
    input=$(echo "$input" | bc -l)
    plus5=$(echo "$input * 1.05" | bc -l)
    plus10=$(echo "$input * 1.10" | bc -l)
    minus5=$(echo "$input * 0.95" | bc -l)
    minus10=$(echo "$input * 0.90" | bc -l)

    # Prepare output for rofi
    output="$input\n+10%: $plus10\n+5%: $plus5\n-5%: $minus5\n-10%: $minus10"

    if [ -n "$input" ]; then
        echo "$input" | wl-copy
    fi
done
