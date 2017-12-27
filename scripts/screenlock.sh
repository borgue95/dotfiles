#!/bin/bash

# requires imagemagick and i3lock

# sreenshot
import -window root tmp.png

# blur
convert tmp.png -blur 0x4 tmp.png

# ovelay
composite -gravity center lock.png tmp.png tmp.png

# lock
i3lock -e -i tmp.png

# cleanup
rm tmp.png

