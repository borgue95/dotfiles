#!/bin/bash

# requires imagemagick and i3lock
DIR=$(dirname $(realpath $0))
DIR=$HOME/.config/i3/scripts/lock
LOCK=$DIR/lock2.png
TMP=$DIR/tmp.png

# sreenshot
import -window root $TMP

# blur
convert $TMP -blur 21x10 $TMP

# pixelate
#convert $TMP -scale 10% -scale 1000% $TMP

# offset (for multi-display setups. put the image at the center of 1 screen
x=$((960 - $(identify -format '%w' $LOCK)/2))
y=$((540 - $(identify -format '%h' $LOCK)/2))

# ovelay
composite -geometry +$x+$y $LOCK $TMP $TMP

# lock
i3lock -e -i $TMP

# cleanup
rm $TMP

