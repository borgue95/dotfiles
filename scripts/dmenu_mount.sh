#!/bin/bash

# Requirements:
# have a sudo gui password prompt 
# OR
# have sudo without password for mount and umount

# get mountable partitions greater than 400MB
#partitions=$(lsblk -lp | 
             #grep -e "part $" |
             #numfmt --field=4 --from=iec | 
             #awk '$4 > 400 * 1024*1024 {print $1 " (" $4 ")"}' | 
             #sort -n -r -k2 -t'(' | 
             #awk -F'[()]' '{print $1 $2}' | 
             #numfmt --field=2 --to=si --format "(%0.1f)" --padding=1)

partitions=$(lsblk -lp | grep -E "part $" | sort -h -k4 -r | awk '{print $1 " (" $4 ")"}')
selected=$(echo "$partitions" | dmenu -i -p "Select your device" -fn 'Office Code Pro:pixelsize=16' -b) 
if [ "$selected" = "" ]; then exit 1; fi

# pick the device
selected=$(echo $selected | awk '{print $1}')

# try to mount them
sudo -A mount $selected && exit 0

mounting_point=$(find /mnt -type d -maxdepth 1 -mindepth 1 2> /dev/null | dmenu -i -p "Type in mount point." -fn 'Office Code Pro:pixelsize=16' -b)
if [ "$mounting_point" = "" ]; then exit 1; fi

if [ ! -d "$mounting_point" ]; then
    create_dir=$(printf "No\\nYes" | dmenu -i -p "$mounting_point does not exist. Create it?" -fn 'Office Code Pro:pixelsize=16' -b)
    if [ "$create_dir" = "Yes" ]; then
        sudo -A mkdir -p "$mounting_point"
    fi
fi

sudo -A mount "$selected" "$mounting_point" -o uid=$(id -u) -o gid=$(id -g) && notify-send "$selected mounted to $mounting_point"

# umount only the partitions mounted with this script
echo "$mounting_point" > ~/.$(basename $selected)

