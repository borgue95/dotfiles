#!/bin/bash

# init monitor position
xrandr --output DVI-D-0 --mode 1920x1080 --pos 0x0      --rotate normal \
       --output VGA-0   --mode 1600x900  --pos 1920x136 --rotate normal \
       --output DVI-D-1 --off \
       --output HDMI-0 --off

# restart and reload xrandr config (need to execute xrandr before i3 starts...)
i3-msg restart

# init wallpapers
bash ~/.myscripts/wallpaper.sh &
#feh --bg-scale /home/berenguer/Imatges/fons_escriptori/bg1/1_janapanfilova.jpg \
#    --bg-scale /home/berenguer/Imatges/fons_escriptori/bg1/6_bjornscribben-cloversdropswater.jpg

# startup apps
google-chrome &
dropbox start &
spotify &

sleep 3
i3-msg restart

discord-canary &
#sleep 2

# miscelanious
# disable motherboard speaker
xset b off
# lock Num Lock
xdotool key Num_Lock
# move mouse to the center of primary screen
xdotool mousemove --screen 0 960 540
