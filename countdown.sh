#!/bin/bash

_echo_countdown() {
    if [ "$1" -gt "$2" ]; then
    	echo -ne "$(date -j -f '%s' $(($1 - $2 )) '+%M:%S')\r";
    else 
        echo -ne "-$(date -j -f '%s' $(( $2 - $1 )) '+%M:%S')\r";
    fi
}

_stop_countdown(){
    echo "Stopped at"
    date '+%H:%M:%S'
    if [ -t 0 ]; then stty sane; fi
    tput cnorm
}

_countdown_one_period() {
   one_period_reference_date=$1
   one_period_stop_date=$2
   keypress=''
   while [ "$one_period_stop_date" -gt "$now" -a "$keypress" != 'N' ]; do 
     previous_date=$now
     _echo_countdown $one_period_reference_date $now
     sleep 1 
     keypress=$(cat -v)
     now=$(date +%s)
   done
}

_show_pop_up() {
   osascript -e 'display dialog "You need to take a break."' &>/dev/null
}

_wait_when_display_is_off (){
    # Do not start the next cycle when display is off.
    while true; do
        display_state=$(ioreg -r -d 1 -n IODisplayWrangler | grep -i IOPowerManagement | sed 's/.*DevicePowerState"=\([0-9]\).*/\1/g')	
        if [ $display_state -eq 4 ]; then break; fi
        sleep 10
    done
    now=$(date +%s)
}

function countdown(){
    tput civis # Hide cursor

    # Do not echo input from stdin
    if [ -t 0 ]; then stty -echo -icanon -icrnl time 0 min 0; fi
   
    # Handle ctrl-c and ctrl-z gracefully.
    trap "_stop_countdown ; exit" SIGINT
    trap "" SIGTSTP   

    work_period=$1
    break_period=$2

    now=$(date +%s)
    while true; do
        echo -e "\033[0mStarted to work at" # Normal color
        date '+%H:%M:%S'
        stop_date=$(($now + $work_period * 60)); 
        _countdown_one_period $stop_date $stop_date

        stop_date=$(($previous_date + 1))
        start_date=$(($stop_date + $break_period * 60)); 
        echo -e "\033[1;33mTook a break at" # Green color
        date -j -f '%s' $stop_date '+%H:%M:%S'
        _countdown_one_period $stop_date $start_date

        _wait_when_display_is_off
     done
}

if [[ $# -eq 0 ]] ; then
    countdown 50 10
elif [[ $# -eq 1 ]] ; then
    countdown $1 10
else
    countdown $1 $2
fi

