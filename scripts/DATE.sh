#!/bin/bash

echo -n $(date +%a\ %d-%m-%Y\ %H:%M:%S)
echo " "

case $BLOCK_BUTTON in
    1) notify-send "$(cal)" ;;
    3) notify-send "$(cal -3)" ;;
    #*) echo "hi" ;;
esac

