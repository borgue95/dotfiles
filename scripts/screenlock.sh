#!/bin/bash

# requires imagemagick and i3lock
DIR=$(dirname $(realpath $0))

# sreenshot
import -window root $DIR/tmp.png

# blur
convert $DIR/tmp.png -blur 21x10 $DIR/tmp.png

# ovelay
composite -gravity center $DIR/lock.png $DIR/tmp.png $DIR/tmp.png

# lock
i3lock -e -i $DIR/tmp.png

# cleanup
rm $DIR/tmp.png

