#!/bin/bash

action=$1
script_dir=$(dirname "$0")
countdown_timer_file="$script_dir/selected_time.txt"
state_file="$script_dir/state.txt"
shift_file="$script_dir/shift.txt"
time_file="$script_dir/timer.txt"
config="$script_dir/timer.rasi"

if [ "$action" = "select" ]; then
    # if the file doesn't exist, create it
    if [ ! -f "$time_file" ]; then
        touch "$time_file"
        echo "30:00" > "$time_file"
    fi

    # sort -b "$time_file" -o "$time_file"

    # select time from rofi menu
    time=$(
        cat "$time_file" | rofi -dmenu \
            -config "$config"
    )

    # if there is an error or time is empty, exit
    if [ $? -ne 0 ] || [ -z "$time" ]; then
        exit
    fi

    # if the time is not in the correct format, exit
    # the format must be mmm:ss (>99mins), mm:ss or m:ss with valid minutes and seconds
    if [[ ! $time =~ ^[0-9]{1,3}:[0-5][0-9]$ ]]; then
        echo "Time is not in correct format"
        exit
    fi

    # if format is m:ss, change to mm:ss format
    if [[ ${#time} -eq 4 ]]; then
        time="0$time"
    fi

    echo $time

    # Check if the file ends with a newline
    if [ -n "$(tail -c 1 "$time_file")" ]; then
        echo -e "\n" >> "$time_file"
    fi

    # add new time to the file
    if ! grep -q "$time" "$time_file"; then
        echo "add new time"
        echo "$time" >> "$time_file"
    else
        echo "time already exists"
    fi

    # sort time
    sed 's/^\([0-9]\{2\}:[0-9]\{2\}\)$/0\1/' "$time_file" | sort -t: -k1,1n -k2,2n | sed 's/^0//' > temp.txt && mv temp.txt "$time_file"

    if [ ! -f "$countdown_timer_file" ]; then
        touch "$countdown_timer_file"
    fi

    if [ ! -f "$state_file" ]; then
        touch "$state_file"
    fi

    echo "$time" > "$countdown_timer_file"
    echo "reset" > "$state_file"
    echo 0 > "$shift_file"

fi

if [ "$action" = "add" ]; then
    if [ ! -f "$shift_file" ]; then
        touch "$shift_file"
    fi

    shift_time=$(($(cat "$shift_file")))

    # IFS=: read -r mins secs <<< "$shift_time"
    # new_mins=$((10#$mins + 1))
    # new_secs=$secs
    # new_time=$(printf "%02d:%02d" $new_mins $new_secs)
    ((shift_time++))

    echo "$shift_time" > "$shift_file"
fi

if [ "$action" = "minus" ]; then
    if [ ! -f "$shift_file" ]; then
        touch "$shift_file"
    fi


    shift_time=$(($(cat "$shift_file")))
    # IFS=: read -r mins secs <<< "$shift_time"
    # new_mins=$((10#$mins - 1))
    # new_secs=$secs
    # if [ $new_mins -lt 0 ]; then
    #     new_mins=0
    #     new_secs=0
    # fi
    # new_time=$(printf "%02d:%02d" $new_mins $new_secs)
    ((shift_time--))

    echo "$shift_time" > "$shift_file"
fi

if [ "$action" = "play-pause" ]; then
    echo "play-pause" > "$state_file"
fi

if [ "$action" = "reset" ]; then
    echo "reset" > "$state_file"
    echo 0 > "$shift_file"
fi