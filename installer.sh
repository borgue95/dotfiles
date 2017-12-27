#!/bin/bash

# Create symlinks for the files that programs need, suchs as vim config or i3 config
# The other config files, that are called inside the above files, are placed to the
# main dot folder which is $HOME/.mydotfiles

# prevent error snowballing
set -e -o errexit

# DEPENDENCIES
# xset playerctl amixer not found on Raspbery Pi
if [[ ! -e /proc/device-tree/model ]]; 
then
    sudo apt-get install xset playerctl amixer
fi

# general dependencies
sudo apt-get install git build-essential scrot imagemagick xdotool arandr rofi wget unzip

# i3-gaps dependencies
sudo apt-get install -y -qq libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf automake libxcb-xrm-dev


# MISC
mkdir -p $(xdg-user-dir PICTURES)/screen_shots
GIT_DIR=$(pwd)

# where to put my dot files
DOT_DIR=$HOME/.mydotfiles
mkdir -p $DOT_DIR
mkdir -p $DOT_DIR/vim
mkdir -p $DOT_DIR/i3
mkdir -p $DOT_DIR/scripts

# VIM
sudo apt-get install -y -q vim
cp $GIT_DIR/vim/vimrc $DOT_DIR/vim/vimrc
mv $HOME/.vimrc $HOME/.vimrc_old
ln -sf $DOT_DIR/vim/vimrc $HOME/.vimrc

# VIM plugins
echo "The file ~/.vim/bundle/Vundle.vim is going to be removed. Sure [press enter to continue]?"
read
rm -rf $HOME/.vim/bundle/Vundle.vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

# i3-gaps
mkdir -p $HOME/apps/src
echo "The folder ~/apps/src/i3-gaps is going to be removed. Sure [press enter to continue]?"
read
rm -rf $HOME/apps/src/i3-gaps
git clone https://www.github.com/Airblader/i3 $HOME/apps/src/i3-gaps
cd $HOME/apps/src/i3-gaps
autoreconf --force --install
rm -rf build/
mkdir -p build && cd build/
../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
make -j4
sudo make install
cd

# i3
sudo apt-get install -y -q i3 i3blocks i3lock
cp $GIT_DIR/i3/config $DOT_DIR/i3/config
ln -sf $DOT_DIR/i3/config $HOME/.config/i3/config
cp $GIT_DIR/i3/compton.conf $DOT_DIR/i3/compton.conf
cp $GIT_DIR/i3/i3blocks.conf $DOT_DIR/i3/i3blocks.conf
cp $GIT_DIR/i3/rofi.conf $DOT_DIR/i3/rofi.conf
cp $GIT_DIR/i3/i3_init.sh $DOT_DIR/i3/i3_init.sh

# scripts for i3blocks and other things
cp $GIT_DIR/scripts/getmyip.sh $DOT_DIR/scripts/getmyip.sh
cp $GIT_DIR/scripts/screenshot_selection.sh $DOT_DIR/scripts/screenshot_selection.sh
cp $GIT_DIR/scripts/screenshot_full.sh $DOT_DIR/scripts/screenshot_full.sh
cp $GIT_DIR/scripts/CPU_usage.sh $DOT_DIR/scripts/CPU_usage.sh
cp $GIT_DIR/scripts/GPU_usage.sh $DOT_DIR/scripts/GPU_usage.sh
cp $GIT_DIR/scripts/screenlock.sh $DOT_DIR/scripts/screenlock.sh

# font awesome
cd $DOT_DIR
wget http://fontawesome.io/assets/font-awesome-4.7.0.zip
unzip font-awesome-4.7.0.zip
cd font-awesome-4.7.0/fonts
mkdir -p $HOME/.fonts
cp fontawesome-webfont.ttf $HOME/.fonts

# font san francisco display
cd $DOT_DIR
git clone https://github.com/supermarin/YosemiteSanFranciscoFont.git
cd YosemiteSanFranciscoFont/
cp *.ttf $HOME/.fonts

i3-msg restart

# TODO change desktop background
# TODO multimonitor support for i3lock
# TODO bash prompt
# TODO font awesome
