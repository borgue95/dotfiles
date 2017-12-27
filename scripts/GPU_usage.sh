#!/bin/bash

memory=$(nvidia-smi | head -n 9 | tail -n 1 | awk '{print $9}' | grep -o [0-9]..)
memory=$memory"MB"
usage=$(nvidia-smi | head -n 9 | tail -n 1 | awk '{print $13}')
usage=${usage::(-1)}
temp=$(nvidia-smi | head -n 9 | tail -n 1 | awk '{print $3}' | grep -o [0-9].)
temp=$temp'\xc2\xb0'C

if [ "$(echo "$usage > 75 && $usage < 95" | bc -l)" -eq 1 ]; then
    output="<span foreground=\"#FFFC00\"><b>$usage%</b></span>"
    echo -n $output
    echo -e " $memory, $temp"
elif [ "$(echo "$usage >= 95" | bc -l)" -eq 1 ]; then
    output="<span background=\"#FF0000\"><b> $usage% </b></span>"
    echo -n $output
    echo -e " $memory, $temp"
else
	echo -e "$usage% $memory $temp"
fi