#!/bin/bash

REAL_DIR=$(dirname $(realpath $0))  # i3/
echo $REAL_DIR

# init monitor position (script generated by arandr)
sh ~/.screenlayout/myscreenlayout_2displays.sh
#sh ~/.screenlayout/myscreenlayout.sh

# restart and reload xrandr config (need to execute xrandr before i3 starts...)
i3-msg restart

# init wallpapers
#bash wallpaper.sh &
feh --bg-fill "$(cat $REAL_DIR/../scripts/last_wallpaper)" \
    --bg-fill "$(cat $REAL_DIR/../scripts/last_wallpaper)"

# startup apps
bash $REAL_DIR/../scripts/getmyip.sh &
#google-chrome &
dropbox start &
pulseaudio &
#discord-canary &
#spotify &
#slack &
~/apps/src/iris-floss/iris-floss 5200 60

i3-msg restart

# miscelanious
# disable motherboard speaker
xset b off
# modify keyboard repeat (delay, rate)
xset r rate 250 50
# lock Num Lock (install xdotool)
xdotool key Num_Lock
# move mouse to the center of primary screen
xdotool mousemove --screen 0 960 540

# init wallpapers
#feh --bg-scale "$(cat ~/.config/i3/last_wallpaper)" \
#    --bg-scale "$(cat ~/.config/i3/last_wallpaper)"

# move mouse to the center of primary screen
#xdotool mousemove --screen 0 960 540
