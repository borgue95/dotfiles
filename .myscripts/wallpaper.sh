#!/bin/bash

fotos="$HOME/Imatges/fons_escriptori/bg1"
while [[ 1 ]]
    do
        pic1=$(ls $fotos/*.jpg | shuf -n1)
        pic2=$(ls $fotos/*.jpg | shuf -n1)
        feh --bg-scale $pic1 \
            --bg-scale $pic2
        sleep 900 
    done
