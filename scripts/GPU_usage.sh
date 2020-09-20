#!/bin/bash

memory=$(nvidia-smi | head -n 9 | tail -n 1 | awk '{print $9}')
memory=${memory:0:((${#memory} - 3))}
memory=$memory"M"
#usage=$(nvidia-smi | head -n 9 | tail -n 1 | awk '{print $13}')
#usage=${usage::(-1)}
usage=$(nvidia-settings -q GPUUtilization | awk '{print $4}')
usage=${usage/=/ }
usage=${usage/,/ }
usage=$(echo $usage | awk '{print $2}')
usage=$(printf "%3s" $usage)
temp=$(nvidia-smi | head -n 9 | tail -n 1 | awk '{print $3}' | grep -o [0-9].)
temp=$temp'°'C

if [ "$(echo "$usage > 75 && $usage < 95" | bc -l)" -eq 1 ]; then # 75 - 95
    printf "<span foreground=\"#FFFC00\"><b>%3s%%</b></span>" $usage
    printf " @ %s, %s\n" $memory $temp
elif [ "$(echo "$usage >= 95" | bc -l)" -eq 1 ]; then # > 95
    printf "<span background=\"#FF0000\" foreground=\"#FFFFFF\"><b>%3s%%</b></span>" $usage
    printf " @ %s, %s\n" $memory $temp
else # < 75
    printf "%3s%% @ %s, %s\n" $usage $memory $temp
fi
