#!/bin/bash

work_period=50
break_period=10
update_period=1
simple_time_format=0
allow_notification=0
log_to_file=0

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
file_name="$DIR""/.countdown"

_echo_usage () {
    cat << EOF
usage: $0 [-snf] [-w 1-59] [-b 1-10]
    -s Show countdown using simple time format which includes minutes only.
    -n Allow OSX notification when a break period is started.
    -f Specifies whether the countdown info should be logged into a file named ".countdown".
    -w Work period in minutes. Default is 50.
    -b Break period in minutes. Default is 10.
EOF
    exit 2
}

args=$(getopt snu:w:b:f $*)
[ $? != 0 ] && _echo_usage

set -- $args
for i
do
    case "$i"
        in
    -s) simple_time_format=1; update_period=10; shift;;
    -n) allow_notification=1; shift;;
    -w)
        [[ $2 -ge 1 && $2 -le 59 ]] || _echo_usage
        work_period=$2
        shift 2;;
    -b)
        [[ $2 -ge 1 && $2 -le 10 ]] || _echo_usage
        break_period=$2
        shift 2;;
    -f) log_to_file=1; shift;;
    --)
        shift; break;;
esac
done

_echo_countdown() {
    if [ "$simple_time_format" -eq 0 ]; then
        time_format='+%M:%S'
    else
        time_format='+%M'
    fi
    if [ "$1" -gt "$2" ]; then
        echo -ne "$(date -j -f '%s' $(($1 - $2 )) $time_format)\r";
    fi
}

_stop_countdown(){
    echo "Stopped at"
    date '+%H:%M:%S'
    [ -t 0 ] && stty sane
    tput cnorm
}

_countdown_one_period() {
    period_type=$1 
    one_period_stop_date=$2
    [ $log_to_file -eq 1 ] && echo -e "$period_type\n$one_period_stop_date" > "$file_name"
 
    keypress=''
    while [ "$one_period_stop_date" -gt "$now" ]; do
        _echo_countdown $one_period_stop_date $now
        count=0
        while [ $count -lt $update_period ]; do
            previous_date=$now
            sleep 1 
            count=$((count+1))
            keypress=$(cat -v)
            now=$(date +%s)
            [ "$keypress" == 'N' ] && return 
            [ $now -ge $(($previous_date + $break_period * 60)) ] && return;
        done
    done
}

_show_notification() {
    osascript -e 'display notification "You need to take a break." with title "Countdown"'
}
_wait_when_display_is_off (){
    # Do not start the next cycle when display is off.
    while true; do
        display_state=$(ioreg -r -d 1 -n IODisplayWrangler | grep -i IOPowerManagement | sed 's/.*DevicePowerState"=\([0-9]\).*/\1/g')	
        [ $display_state -eq 4 ] && break
        sleep 10
    done
    now=$(date +%s)
}

function countdown(){
    tput civis # Hide cursor

    # Do not echo input from stdin
    [ -t 0 ] && stty -echo -icanon -icrnl time 0 min 0
   
    # Handle ctrl-c and ctrl-z gracefully.
    trap "_stop_countdown ; exit" SIGINT
    trap "" SIGTSTP   

    work_period=$1
    break_period=$2

    now=$(date +%s)
    while true; do
        echo -e "\033[0mStarted to work at" # Normal color
        date '+%H:%M:%S'
        work_stop_date=$(($now + $work_period * 60)); 
        _countdown_one_period "w" $work_stop_date

        actual_work_stop_date=$(($previous_date + 1))
        now=$(date +%s)
        break_stop_date=$(($actual_work_stop_date + $break_period * 60)); 
        [ $now -lt $break_stop_date ] && [ $allow_notification -eq 1 ] && _show_notification

        echo -e "\033[0;32mTook a break at" # Green color
        date -j -f '%s' $actual_work_stop_date '+%H:%M:%S'
        _countdown_one_period "b" $break_stop_date

        _wait_when_display_is_off
     done
}

countdown $work_period $break_period

