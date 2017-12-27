#!/bin/bash

data=$(date +%Y%m%d_%H%M%S)
filename=$data.png
path=~/Imatges/screen_shots
route=$path/$filename

# route inside " " for supporting path with spaces
import "$route"
