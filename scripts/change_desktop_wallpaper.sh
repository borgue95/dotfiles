#!/bin/bash

# script real location
BASE_DIR=$(dirname $(realpath $0))

# get colors
if [ -z $1 ]
then
    echo "Usage: $0 [image|make_dark|make_bright|make_normal|make_contrast]"
    exit 1
else
    if [ "$1" == "make_dark" ];
    then
        dark_color=$(cat points.txt | head -n 2 | tail -n 1)
        semi_dark_color=$(cat points.txt | head -n 5 | tail -n 1)
        light_color=$(cat points.txt | head -n 8 | tail -n 1)
        wallpaper=$(cat $BASE_DIR/last_wallpaper)
    elif [ "$1" == "make_bright" ];
    then
        dark_color=$(cat points.txt | head -n 4 | tail -n 1)
        semi_dark_color=$(cat points.txt | head -n 7 | tail -n 1)
        light_color=$(cat points.txt | head -n 10 | tail -n 1)
        wallpaper=$(cat $BASE_DIR/last_wallpaper)
    elif [ "$1" == "make_normal" ];
    then
        dark_color=$(cat points.txt | head -n 3 | tail -n 1)
        semi_dark_color=$(cat points.txt | head -n 6 | tail -n 1)
        light_color=$(cat points.txt | head -n 9 | tail -n 1)
        wallpaper=$(cat $BASE_DIR/last_wallpaper)
    elif [ "$1" == "make_contrast" ];
    then
        dark_color=$(cat points.txt | head -n 1 | tail -n 1)
        semi_dark_color=$(cat points.txt | head -n 5 | tail -n 1)
        light_color=$(cat points.txt | head -n 10 | tail -n 1)
        wallpaper=$(cat $BASE_DIR/last_wallpaper)
    else
        $BASE_DIR/image_kmeans/main $1 10
        dark_color=$(cat points.txt | head -n 3 | tail -n 1)
        semi_dark_color=$(cat points.txt | head -n 6 | tail -n 1)
        light_color=$(cat points.txt | head -n 9 | tail -n 1)
        wallpaper=$1
    fi
fi


local_config="$BASE_DIR/../i3/config"
config_file="$HOME/.mydotfiles/i3/config"

local_i3blocks_config="$BASE_DIR/../i3/i3blocks.conf"
config_i3blocks_file="$HOME/.mydotfiles/i3/i3blocks.conf"

sed -e s/^.*'set $bg-color'.*$/"set \$bg-color $dark_color"/ \
    -e s/^.*'set $inactive-bg-color'.*$/"set \$inactive-bg-color $dark_color"/ \
    -e s/^.*'set $text-color'.*$/"set \$text-color $light_color"/ \
    -e s/^.*'set $inactive-text-color'.*$/"set \$inactive-text-color $semi_dark_color"/ $local_config > $config_file
# i make this copy because: 
# I will call this script to change the background image. This will write to the 
# machines config, not to the git config. If i write to the git config, i will 
# need to do bash installer.sh in order to take effect. 
cp $config_file $local_config

sed -e s/"^color=....... #touch.*$"/"color=$light_color #touch"/g $local_i3blocks_config > $config_i3blocks_file
cp $config_i3blocks_file $local_i3blocks_config

# change background
feh --bg-scale "$wallpaper" --bg-scale "$wallpaper"
echo "$wallpaper" > last_wallpaper

# output is 'config' file. refresh i3
i3-msg restart
