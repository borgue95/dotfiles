#!/bin/bash

# TEMP
if [ $(lscpu | grep Architecture: | awk '{print $2}') != "x86_64" ];
then
    temp1=$(/opt/vc/bin/vcgencmd measure_temp)
    temp1=${temp1:5:4}
    temp1=$temp1'\xc2\xb0'C  # this is the degree symbol
else
    temp1=$(sensors | grep "CPUTIN:" | awk '{print $2}')
    if [ "$temp1" = "" ]; then
        temp1=$(sensors | grep "^Package" | awk '{print $4}')
    fi
    temp1=${temp1:1}
fi

# FREQUENCY
if [ $(lscpu | grep Architecture: | awk '{print $2}') != "x86_64" ];
then
    freq=$(echo "scale=2; $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq) / 1000.0" | bc);
else
    freq=$(lscpu | head -n 15 | tail -n 1 | awk '{print $3}')
fi

# ceiling: 3.99 == 4.00
#freq=$(echo "scale=2; if ($freq/1-$freq != 0) $freq/1+1 else $freq" | bc)
#freq=$(echo "scale=2;$freq/1000.0" | bc)

# amb awk i prou
freq=$(echo $freq | awk '{printf("%d",$0 += $0 < 0 ? 0: 0.0)}')
freq=$(echo $freq | awk '{printf("%.2f", $0/1000.0)}')
freq=$freq"GHz"

# LOAD
prev=$(cat /proc/stat | grep "cpu ")
sleep 0.5
curr=$(cat /proc/stat | grep "cpu ")

prev_user=$(echo $prev | awk '{print $2}')
prev_nice=$(echo $prev | awk '{print $3}')
prev_sys=$(echo $prev | awk '{print $4}')
prev_idle=$(echo $prev | awk '{print $5}')
prev_iowait=$(echo $prev | awk '{print $6}')
prev_irq=$(echo $prev | awk '{print $7}')
prev_softirq=$(echo $prev | awk '{print $8}')
prev_steal=$(echo $prev | awk '{print $9}')
prev_guest=$(echo $prev | awk '{print $10}')
prev_guest_nice=$(echo $prev | awk '{print $11}')

curr_user=$(echo $curr | awk '{print $2}')
curr_nice=$(echo $curr | awk '{print $3}')
curr_sys=$(echo $curr | awk '{print $4}')
curr_idle=$(echo $curr | awk '{print $5}')
curr_iowait=$(echo $curr | awk '{print $6}')
curr_irq=$(echo $curr | awk '{print $7}')
curr_softirq=$(echo $curr | awk '{print $8}')
curr_steal=$(echo $curr | awk '{print $9}')
curr_guest=$(echo $curr | awk '{print $10}')
curr_guest_nice=$(echo $curr | awk '{print $11}')

PrevIdle=$(($prev_idle + $prev_iowait))
CurrIdle=$(($curr_idle + $curr_iowait))

PrevNonIdle=$(($prev_user + $prev_nice + $prev_sys + $prev_irq + $prev_softirq + $prev_steal))
CurrNonIdle=$(($curr_user + $curr_nice + $curr_sys + $curr_irq + $curr_softirq + $curr_steal))

PrevTotal=$(($PrevIdle + $PrevNonIdle))
CurrTotal=$(($CurrIdle + $CurrNonIdle))

total_load=$(($CurrTotal - $PrevTotal))
idle_load=$(($CurrIdle - $PrevIdle))

cpu_usage=$(echo "scale=6; ($total_load - $idle_load) / $total_load * 100.0" | bc)
cpu_usage=$(echo "scale=1; $cpu_usage / 1.0" | bc | awk '{printf("%.1f", $0)}')
cpu_usage="$cpu_usage"

if [ "$(echo "scale=2;$cpu_usage > 75.0 && $cpu_usage < 95.0" | bc -l)" -eq 1 ]; then # 75-95
    output="<span foreground=\"#FFFC00\"><b>$cpu_usage%</b></span>"
    echo -n $output
    echo -e " @ $freq, $temp1"
elif [ "$(echo "scale=2;$cpu_usage >= 95.0" | bc -l)" -eq 1 ]; then # > 95
    output="<span background=\"#FF0000\" foreground=\"#FFFFFF\"><b> $cpu_usage% </b></span>"
    echo -n $output
    echo -e " @ $freq, $temp1"
else # < 75
    echo -e "$cpu_usage""% @ $freq, $temp1"
fi
