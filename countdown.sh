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
   reference_date=$1
   stop_date=$2
   keypress=''
   while [ "$stop_date" -gt "$now" -a "$keypress" != 'N' -a "$keypress" != 'Q' ]; do 
     _echo_countdown $reference_date $now
     sleep 1 
     keypress=$(cat -v)
     if [ "$keypress" = 'Q' ]; then
        _stop_countdown
        exit
     fi
     now=$(date +%s)
   done
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
     echo "Started to work at"
     date '+%H:%M:%S'
     stop_date=$(($now + $work_period * 60)); 
     _countdown_one_period $stop_date $stop_date

     echo "Took a break at"
     date '+%H:%M:%S'
     stop_date=$(($now + $break_period * 60)); 
     _countdown_one_period $now $stop_date
   done
}

if [[ $# -eq 0 ]] ; then
    countdown 50 10
elif [[ $# -eq 1 ]] ; then
    countdown $1 10
else
    countdown $1 $2
fi

