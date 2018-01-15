#!/bin/bash

# Create symlinks for the files that programs need, suchs as vim config or i3 config
# The other config files, that are called inside the above files, are placed to the
# main dot folder which is $HOME/.mydotfiles

# prevent error snowballing
set -e -o errexit

# pretty terminal colors for information:
LBLU=$(tput setaf 12)  # light blue
LYEL=$(tput setaf 11)  # light yellow
LGRE=$(tput setaf 10)  # light green
RST=$(tput sgr0)

# where to put my dot files
GIT_DIR=$(dirname $(realpath $0))
DOT_DIR=$HOME/.config
mkdir -p $DOT_DIR/i3
mkdir -p $DOT_DIR/scripts
mkdir -p $DOT_DIR/ranger
mkdir -p $(xdg-user-dir PICTURES)/screen_shots

# VIM
echo $LBLU"Installing vimrc. If previous rc file is encountered, it will be saved as .vimrc_old"$RST
if [[ -e $HOME/.vimrc ]];  # if exists
then
    if [[ ! -h $HOME/.vimrc ]];  # if is not a symolic link
    then
        mv $HOME/.vimrc $HOME/.vimrc_old
    fi
fi
ln -sf $GIT_DIR/vim/vimrc $HOME/.vimrc

# VIM plugins
echo $LBLU"Installing VundleVim and some pluggins"$RST
if [[ ! -e ~/.vim/bundle/Vundle.vim ]];
then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
else
    echo $LYEL"  Vundle vim seams to be installed on ~/.vim/bundle/Vundle.vim. Skipping"$RST
fi

# i3-gaps
echo $LBLU"Installing i3-gaps"$RST
mkdir -p $HOME/apps/src
if [[ ! -e $HOME/apps/src/i3-gaps ]];
then
    # Compile i3-gaps
    cd $HOME/apps/src
    git clone https://www.github.com/Airblader/i3
    cd i3-gaps
    autoreconf --force --install
    rm -rf build/
    mkdir -p build && cd build/
    ../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
    make -j4
    sudo make install
    cd
else
    echo $LYEL"  i3-gaps seams to be installed on ~/apps/src/i3-gaps. Skipping"$RST
fi

# i3
echo $LBLU"Installing config files and scripts"$RST
ln -sf $GIT_DIR/i3/config $DOT_DIR/i3/config
ln -sf $GIT_DIR/i3/compton.conf $DOT_DIR/i3/compton.conf
ln -sf $GIT_DIR/i3/i3blocks.conf $DOT_DIR/i3/i3blocks.conf
ln -sf $GIT_DIR/i3/rofi.conf $DOT_DIR/i3/rofi.conf
ln -sf $GIT_DIR/i3/i3_init.sh $DOT_DIR/i3/i3_init.sh

ln -sf $GIT_DIR/scripts/getmyip.sh $DOT_DIR/scripts/getmyip.sh
ln -sf $GIT_DIR/scripts/screenshot_selection.sh $DOT_DIR/scripts/screenshot_selection.sh
ln -sf $GIT_DIR/scripts/screenshot_full.sh $DOT_DIR/scripts/screenshot_full.sh
ln -sf $GIT_DIR/scripts/CPU_usage.sh $DOT_DIR/scripts/CPU_usage.sh
ln -sf $GIT_DIR/scripts/GPU_usage.sh $DOT_DIR/scripts/GPU_usage.sh
ln -sf $GIT_DIR/scripts/MEM_usage.sh $DOT_DIR/scripts/MEM_usage.sh
ln -sf $GIT_DIR/scripts/screenlock.sh $DOT_DIR/scripts/screenlock.sh
ln -sf $GIT_DIR/scripts/change_desktop_wallpaper.sh $DOT_DIR/scripts/change_desktop_wallpaper.sh
ln -sf $GIT_DIR/scripts/lock.png $DOT_DIR/scripts/lock.png
ln -sf $GIT_DIR/scripts/lock2.png $DOT_DIR/scripts/lock2.png

ln -sf $GIT_DIR/ranger/rc.conf $DOT_DIR/ranger/rc.conf
ln -sf $GIT_DIR/ranger/rifle.conf $DOT_DIR/ranger/rifle.conf

ln -sf $GIT_DIR/Xdefaults $HOME/.Xdefaults

# font awesome
echo $LBLU"Installing fonts"$RST
if [[ ! -e $HOME/.fonts/fontawesome-webfont.ttf ]];
then
    mkdir -p tmp && cd tmp
    wget http://fontawesome.io/assets/font-awesome-4.7.0.zip
    unzip font-awesome-4.7.0.zip
    mkdir -p $HOME/.fonts
    cp font-awesome-4.7.0/fonts/fontawesome-webfont.ttf $HOME/.fonts
    rm -rf tmp
else
    echo $LYEL"  Font Awesome seams to be installed in ~/.fonts. Skipping"$RST
fi

# font san francisco display
if [[ ! -e "$HOME/.fonts/System San Francisco Display Bold.ttf" ]];
then
    mkdir -p tmp && cd tmp
    git clone https://github.com/supermarin/YosemiteSanFranciscoFont.git
    cp YosemiteSanFranciscoFont/*.ttf $HOME/.fonts
    rm -rf tmp
else
    echo $LYEL"  Font San Francisco Display seams to be installed in ~/.fonts. Skipping"$RST
fi

i3-msg restart

echo 
echo $LBLU"In order to get the screens work, log in into i3, execute the program arandr,"
echo "arrange the displays and save the configuration in the predefined folder with"
echo "the name 'myscreenlayout.sh'. Then, log out and log in again."$RST

# TODO multimonitor support for i3lock
# TODO bash prompt
# TODO take a look at media keys
