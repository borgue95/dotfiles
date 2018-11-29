#!/bin/bash

# requires imagemagick and i3lock
DIR=$(dirname $(realpath $0))
DIR=$HOME/.config/i3/scripts/lock
LOCK=$DIR/lock2.png
TMP=$DIR/tmp.png
TMP2=$DIR/tmp2.png

# sreenshot
#import -window root $TMP2
scrot $TMP2

# blur
$DIR/convolve_simd/build/convolve_simd $TMP2 $TMP 17
#convert $TMP -blur 21x10 $TMP

# pixelate
#convert $TMP -scale 10% -scale 1000% $TMP

# offset (for multi-display setups. put the image at the center of 1 screen
x=$((720 - $(identify -format '%w' $LOCK)/2))
y=$((450 - $(identify -format '%h' $LOCK)/2))

# ovelay
composite -geometry +$x+$y $LOCK $TMP $TMP

# lock
trap revert HUP INT TERM
xset +dpms dpms 2 2 2
i3lock -e -n -i $TMP
xset dpms 0 0 0

# cleanup
rm $TMP
rm $TMP2
