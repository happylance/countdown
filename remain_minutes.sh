#!/bin/bash
DIR=$( cd $(dirname $0) && pwd )
file="$DIR""/.countdown"
read_countdown() {
    if ! [ -f $file ]; then return; fi
    args=($(cat "$file"))  
    period_type=${args[0]}
    period_stop_date=${args[1]}

    now=$(date +%s)
    if [ "$period_stop_date" -gt "$now" ]; then
        if date --version &>/dev/null; then
            echo -e "$period_type""$(date -d @$(($period_stop_date - $now )) '+%M')\r";
        else
            echo -e "$period_type""$(date -j -f '%s' $(($period_stop_date - $now )) '+%M')\r";
        fi
    fi
}

read_countdown 
