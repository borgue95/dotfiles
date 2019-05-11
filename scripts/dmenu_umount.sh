#!/bin/bash
# LC_ALL=C ensures an english message
mount_points=$(cat $(LC_ALL=C find ~/ -maxdepth 1 -regex ".*sd[a-z][1-9]" 2>&1 | grep -v "denied"))

mount_point=$(echo "$mount_points" | dmenu -i -p "Type the mount point to umount." -fn 'Office Code Pro:pixelsize=16' -b)
if [ "$mount_point" = "" ]; then exit 1; fi

# get the temp file name of that mount point selected
filename=$(echo .$(basename $(lsblk -lp | grep "$mount_point" | awk '{print $1}')))

sudo -A umount $mount_point && notify-send "$mount_point unmounted" && rm $filename
