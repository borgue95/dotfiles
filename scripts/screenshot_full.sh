#!/bin/bash

data=$(date +%Y%m%d_%H%M%S)
filename=$data.png
path=~/Imatges/screen_shots
route=$path/$filename
f0=$path/$data.png
f1=$path/$data-1.png

# route inside " " for supporting path with spaces
import -window root "$route"
convert "$route" +repage -crop 1920x1080 $f0
convert "$route" +repage -crop 1600x900+1920+136 $f1
rm "$route"
