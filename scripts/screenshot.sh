#!/bin/bash

data=$(date +%Y%m%d_%H%M%S)
filename=$data.png
path=$(xdg-user-dir PICTURES)/screen_shots
route=$path/$filename
f0=$path/$data.png

scrot -u "$f0"
