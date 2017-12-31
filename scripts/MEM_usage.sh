#!/bin/bash

total_memory=$(free -h | grep Mem: | awk '{print $2}')

# which unit is used for total memory?
unit=${total_memory:(-1)}
option=-$(echo $unit | awk '{print tolower($0)}')

left_memory=$(free -h $option | grep Mem: | awk '{print $4}')
left_memory=${left_memory:0:((${#left_memory}-1))}

echo "$left_memory""/""$total_memory"
