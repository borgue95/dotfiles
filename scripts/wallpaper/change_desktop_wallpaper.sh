#!/bin/bash

# script real location
BASE_DIR=$(dirname $(realpath $0))  # scripts/
BASE_DIR=$HOME/.config/i3/scripts/wallpaper

# get colors
if [ -z "$1" ]
then
    echo "Usage: $0 [image|make_dark|make_bright|make_normal|make_contrast]"
    exit 1
else
    if [ "$1" == "make_dark" ];
    then
        dark_color=$(cat $BASE_DIR/points.txt | head -n 2 | tail -n 1)
        semi_dark_color=$(cat $BASE_DIR/points.txt | head -n 5 | tail -n 1)
        light_color=$(cat $BASE_DIR/points.txt | head -n 8 | tail -n 1)
        wallpaper=$(cat $BASE_DIR/last_wallpaper)
    elif [ "$1" == "make_bright" ];
    then
        dark_color=$(cat $BASE_DIR/points.txt | head -n 4 | tail -n 1)
        semi_dark_color=$(cat $BASE_DIR/points.txt | head -n 7 | tail -n 1)
        light_color=$(cat $BASE_DIR/points.txt | head -n 10 | tail -n 1)
        wallpaper=$(cat $BASE_DIR/last_wallpaper)
    elif [ "$1" == "make_normal" ];
    then
        dark_color=$(cat $BASE_DIR/points.txt | head -n 3 | tail -n 1)
        semi_dark_color=$(cat $BASE_DIR/points.txt | head -n 6 | tail -n 1)
        light_color=$(cat $BASE_DIR/points.txt | head -n 9 | tail -n 1)
        wallpaper=$(cat $BASE_DIR/last_wallpaper)
    elif [ "$1" == "make_contrast" ];
    then
        dark_color=$(cat $BASE_DIR/points.txt | head -n 1 | tail -n 1)
        semi_dark_color=$(cat $BASE_DIR/points.txt | head -n 5 | tail -n 1)
        light_color=$(cat $BASE_DIR/points.txt | head -n 10 | tail -n 1)
        wallpaper=$(cat $BASE_DIR/last_wallpaper)
    else
        $BASE_DIR/image_kmeans/main "$1" 10
        #mv out.png $BASE_DIR/out.png
        #mv points.txt $BASE_DIR/points.txt
        mv $BASE_DIR/image_kmeans/points.txt $BASE_DIR/points.txt
        dark_color=$(cat $BASE_DIR/points.txt | head -n 3 | tail -n 1)
        semi_dark_color=$(cat $BASE_DIR/points.txt | head -n 6 | tail -n 1)
        light_color=$(cat $BASE_DIR/points.txt | head -n 9 | tail -n 1)
        wallpaper=$1
    fi
fi

# this refers to the git directory structure because all is done via symlinks
config_file="$BASE_DIR/../i3/config"
i3blocks_config_file="$BASE_DIR/../i3/config_files/i3blocks.conf"
tmp_file="$BASE_DIR/tmp"

if [ -e $config_file ] && [ -e $i3blocks_config_file ];
then

    sed -e s/^.*'set $bg-color'.*$/"set \$bg-color $dark_color"/ \
        -e s/^.*'set $inactive-bg-color'.*$/"set \$inactive-bg-color $dark_color"/ \
        -e s/^.*'set $text-color'.*$/"set \$text-color $light_color"/ \
        -e s/^.*'set $inactive-text-color'.*$/"set \$inactive-text-color $semi_dark_color"/ \
        $config_file > $tmp_file
    mv $tmp_file $config_file

    sed -e s/"^color=....... #touch.*$"/"color=$light_color #touch"/g $i3blocks_config_file > $tmp_file
    mv $tmp_file $i3blocks_config_file
fi

# change background
feh --bg-fill "$wallpaper" --bg-fill "$wallpaper"
echo "$wallpaper" > $BASE_DIR/last_wallpaper

# output is 'config' file. refresh i3
i3-msg restart
