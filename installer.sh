#!/bin/bash

# Create symlinks for the files that programs need, suchs as vim config or i3 config
# The other config files, that are called inside the above files, are placed to the
# main dot folder which is $HOME/.mydotfiles

# prevent error snowballing
set -e -o errexit

# MISC
sudo apt-get install -y git scrot imagemagick xset xdotool arandr rofi amixer playerctl autoreconf
mkdir -p $(xdg-user-dir PICTURES)/screen_shots

# where to put my dot files
DOT_DIR=$HOME/.mydotfiles
mkdir -p $DOT_DIR
mkdir -p $DOT_DIR/vim
mkdir -p $DOT_DIR/i3
mkdir -p $DOT_DIR/scripts

# VIM
sudo apt-get install -y vim
cp $(pwd)/vim/vimrc $DOT_DIR/vim/vimrc
ln -s $DOT_DIR/vim/vimrc $HOME/.vimrc

# VIM plugins
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

# i3-gaps
mkdir -p $HOME/apps/src
git clone https://www.github.com/Airblader/i3 $HOME/apps/src/i3-gaps
cd i3-gaps
autoreconf --force --install
rm -rf build/
mkdir -p build && cd build/
../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
make
sudo make install
cd

# i3
sudo apt-get install -y i3 i3blocks i3lock
cp $(pwd)/i3/config $DOT_DIR/i3/config
ln -s $DOT_DIR/i3/config $HOME/.config/i3/config
cp $(pwd)/i3/compton.conf $DOT_DIR/i3/compton.conf
cp $(pwd)/i3/i3blocks.conf $DOT_DIR/i3/i3blocks.conf
cp $(pwd)/i3/rofi.conf $DOT_DIR/i3/rofi.conf
cp $(pwd)/i3/i3_init.sh $DOT_DIR/i3/i3_init.sh

# scripts for i3blocks and other things
cp $(pwd)/scripts/getmyip.sh $DOT_DIR/scripts/getmyip.sh
cp $(pwd)/scripts/screenshot_selection.sh $DOT_DIR/scripts/screenshot_selection.sh
cp $(pwd)/scripts/screenshot_full.sh $DOT_DIR/scripts/screenshot_full.sh
cp $(pwd)/scripts/CPU_usage.sh $DOT_DIR/scripts/CPU_usage.sh
cp $(pwd)/scripts/GPU_usage.sh $DOT_DIR/scripts/GPU_usage.sh
cp $(pwd)/scripts/screenlock.sh $DOT_DIR/scripts/screenlock.sh

# TODO change desktop background
# TODO multimonitor support for i3lock