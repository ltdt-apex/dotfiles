#!/bin/bash

script_dir=$(dirname "$0")
countdown_timer_file="$script_dir/selected_time.txt"
state_file="$script_dir/state.txt"
shift_file="$script_dir/shift.txt"
alarm_file="$script_dir/alarm.oga"

if [ ! -f "$countdown_timer_file" ]; then
    touch "$countdown_timer_file"
fi

if [ ! -f "$state_file" ]; then
    touch "$state_file"
fi

if [ ! -f "$shift_file" ]; then
    touch "$shift_file"
fi

echo "30:00" > "$countdown_timer_file"
echo "reset" > "$state_file"
echo "0" > "$shift_file"

convert_time_string_to_seconds() {
    time=$1

    # split time into minutes and seconds using : separator
    IFS=: read -r mins secs <<< "$time"
    # convert minutes and seconds to integers in base 10 and find total time in seconds
    time_int=$(( 10#$mins * 60 + 10#$secs ))

    echo $time_int
}

convert_seconds_to_time_string() {
    time_int=$1

    # convert total time in seconds to minutes and seconds
    mins="$(( time_int / 60 ))"
    secs="$(( time_int % 60 ))"

    if [ $mins -gt 99 ]; then
        printf "%03d:%02d" "$mins" "$secs"
    else
        printf "%02d:%02d" "$mins" "$secs"
    fi
}

find_remaining_time() {
    real_countdown_time_int=$(convert_time_string_to_seconds $countdown_time)
    real_countdown_time_int=$((real_countdown_time_int + $shift_time_int))

    if [ -z "$start_time_tick" ]; then
        elapsed_time_int=$(($cache_time_int))
    else
        elapsed_time_int=$(($(date +%s) - $start_time_tick + $cache_time_int))
    fi

    # echo "real_countdown_time_int: $real_countdown_time_int"
    # echo "countdown_time: $countdown_time"
    # echo "shift_time_int: $shift_time_int"
    # echo "elapsed_time_int: $elapsed_time_int"
    # echo "cache_time_int: $cache_time_int"

    remaining_time_int=$((real_countdown_time_int - $elapsed_time_int))

    if [ $remaining_time_int -lt 0 ]; then
        echo "00:00"
        return 1
    else
        echo "$(convert_seconds_to_time_string $remaining_time_int)"
        return 0
    fi
}

reset_countdown() {
    echo "0" > "$shift_file"

    countdown_time=$(cat "$countdown_timer_file")
    start_time_tick=""
    cache_time_int=0
    shift_time_int=0
    is_end=0
    playing=0
}

countdown_time=$(cat "$countdown_timer_file")
cache_time_int=0
shift_time_int=0
start_time_tick=""
playing=0
is_end=0

while true; do
    sleep 0.33

    read state < "$state_file"
    read shift_time < "$shift_file"
    shift_time_int=$((shift_time * 60))

    # if received signal to reset, reset the countdown timer
    if [ "$state" = "reset" ]; then
        reset_countdown
    fi

    # if received signal to play-pause, switch between play and pause
    if [ "$state" = "play-pause" ]; then
        # if previous countdown was ended, start a new countdown
        if [ $is_end == 1 ]; then
            reset_countdown
        else
            # switch between play and pause
            if [ $playing == 0 ]; then
                playing=1
            else
                playing=0
            fi
        fi

    fi

    # reset state
    echo "idle" > "$state_file"

    # not playing case
    if [ $playing == 0 ]; then

        # if countdown is paused, save time passed in cache
        if [ -n "$start_time_tick" ]; then
            cache_time_int=$(($(date +%s) - $start_time_tick + cache_time_int))
            start_time_tick=""
        fi

    fi

    # playing case
    if [ $playing == 1 ]; then

        # get starting time
        if [ -z "$start_time_tick" ]; then
            start_time_tick=$(date +%s)
        fi
    fi


    # find remaining time and check if the countdown is ended
    if [[ $is_end == 1 ]]; then
        remaining_time="00:00"
    else
        remaining_time=$(find_remaining_time)
        is_end=$?

        if [ $is_end == 1 ]; then
            playing=0
            notify-send "Timer" "Time's up!" && paplay $alarm_file
        fi
    fi

    # display text logic
    if [ $is_end == 1 ]; then
        display_icon="🔴"
    else
        if [ $playing == 1 ]; then
            display_icon="▶"
        else
            display_icon="⏸"
        fi
    fi

    display_text="$display_icon $remaining_time"

    echo "$display_text"

done