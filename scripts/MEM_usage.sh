#!/bin/bash

total_memory=$(free -h | grep Mem: | awk '{print $2}')

# TODO if unit (total memory) != unit (free memory), print free memory unit
# which unit is used for total memory?
unit=${total_memory:(-1)}
option=-$(echo $unit | awk '{print tolower($0)}')

used_memory=$(free -h $option | grep Mem: | awk '{print $3}')
used_memory=${used_memory:0:((${#used_memory}-1))}

echo "$used_memory""/""$total_memory"
