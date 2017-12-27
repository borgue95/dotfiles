#!/bin/bash

# Create symlinks for the files that programs need, suchs as vim config or i3 config
# The other config files, that are called inside the above files, are placed to the
# main dot folder which is $HOME/.mydotfiles

# prevent error snowballing
set -e -o errexit

# DEPENDENCIES
# playerctl not found on Raspbery Pi
if [[ ! -e /proc/device-tree/model ]]; 
then
    #sudo apt-get install playerctl
    echo ""
fi

# general dependencies
sudo apt-get install -y -qq git build-essential scrot imagemagick xdotool arandr rofi wget unzip

# i3-gaps dependencies
if [[ ! -e /proc/device-tree/model ]];
then
    sudo add-apt-repository ppa:aguignard/ppa
    sudo apt-get update
fi
sudo apt-get install -y -qq libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf automake libxcb-xrm-dev

# i3 itself
sudo apt-get install -y -qq i3 i3blocks i3lock

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
if [[ -e $HOME/.vimrc ]];
then
    mv $HOME/.vimrc $HOME/.vimrc_old
fi
ln -sf $DOT_DIR/vim/vimrc $HOME/.vimrc

# VIM plugins
if [[ ! -e ~/.vim/bundle/Vundle.vim ]];
then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
else
    echo "Vundle vim seams to be installed on ~/.vim/bundle/Vundle.vim. Skipping"
fi

# i3-gaps
mkdir -p $HOME/apps/src
if [[ ! -e $HOME/apps/src/i3-gaps ]];
then
    git clone https://www.github.com/Airblader/i3 $HOME/apps/src/i3-gaps
    cd $HOME/apps/src/i3-gaps
    autoreconf --force --install
    rm -rf build/
    mkdir -p build && cd build/
    ../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
    make -j4
    sudo make install
    cd
else
    echo "i3-gaps seams to be installed on ~/apps/src/i3-gaps. Skipping"
fi

# i3
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
if [[ ! -e $HOME/.fonts/fontawesome-webfont.ttf ]];
then
    cd $DOT_DIR
    wget http://fontawesome.io/assets/font-awesome-4.7.0.zip
    unzip font-awesome-4.7.0.zip
    cd font-awesome-4.7.0/fonts
    mkdir -p $HOME/.fonts
    cp fontawesome-webfont.ttf $HOME/.fonts
else
    echo "Font awesome seams to be installed in ~/.fonts/fontawesome-webfont.ttf. Skipping"
fi

# font san francisco display
if [[ ! -e "$HOME/.fonts/System San Francisco Display Bold.ttf" ]];
then
    cd $DOT_DIR
    git clone https://github.com/supermarin/YosemiteSanFranciscoFont.git
    cd YosemiteSanFranciscoFont/
    cp *.ttf $HOME/.fonts
else
    echo "Font San Francisco Display seams to be installed in ~/.fonts/System San Francisco Display*. Skipping"
fi

i3-msg restart

# TODO change desktop background
# TODO multimonitor support for i3lock
# TODO bash prompt
# TODO take a look at media keys
