#!/bin/bash

ffmpeg -f x11grab -video_size 3520x1080 -y -i $DISPLAY -i /home/berenguer/.myscripts/lock.png \
       -filter_complex "boxblur=10:1,overlay=(1920-overlay_w)/2:(1080-overlay_h)/2" \
       -vframes 1 /home/berenguer/.myscripts/lock_image.png
i3lock -i /home/berenguer/.myscripts/lock_image.png -ue 
