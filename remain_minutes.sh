#/bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
file="$DIR""/.countdown"
read_countdown() {
    if ! [ -f $file ]; then return; fi
    args=($(cat "$file"))  
    period_type=${args[0]}
    period_stop_date=${args[1]}

    if ! [[ 'x'$period_type == 'x'$1 ]]; then
        return;
    fi

    now=$(date +%s)
    if [ "$period_stop_date" -gt "$now" ]; then
    	echo "$(date -j -f '%s' $(($period_stop_date - $now )) '+%M')\r";
    fi
}

read_countdown $1 
