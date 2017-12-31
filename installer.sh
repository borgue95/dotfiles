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


if [ "$1" == "--install-dependencies" ]; 
then
    # DEPENDENCIES
    echo $LBLU"Updating repositories"$RST
    sudo apt-get update &> /dev/null

    # general dependencies
    echo $LBLU"Installing basic dependencies and desktop utilities"$RST
    sudo apt-get install -y -qq arandr\
                                build-essential\
                                feh\
                                git\
                                gnome-terminal\
                                imagemagick\
                                lm-sensors\
                                lxappearance\
                                rofi\
                                scrot\
                                unzip\
                                vim\
                                wget\
                                xdotool > /dev/null

    # i3-gaps dependencies
    if [[ ! -e /proc/device-tree/model ]];
    then
        # if this is not a raspberry pi
        echo $LYEL"Press enter to continue the installation"$RST
        sudo add-apt-repository ppa:aguignard/ppa > /dev/null
        sudo apt-get update > /dev/null
    fi
    echo $LBLU"Installing i3-gaps dependencies"$RST
    sudo apt-get install -y -qq autoconf\
                                automake\
                                libev-dev\
                                libpango1.0-dev\
                                libstartup-notification0-dev\
                                libxcb-cursor-dev\
                                libxcb-icccm4-dev\
                                libxcb-keysyms1-dev\
                                libxcb-randr0-dev\
                                libxcb-util0-dev\
                                libxcb-xinerama0-dev\
                                libxcb-xkb-dev\
                                libxcb-xrm-dev\
                                libxcb1-dev\
                                libxkbcommon-dev\
                                libxkbcommon-x11-dev\
                                libyajl-dev > /dev/null

    # i3 itself
    echo $LBLU"Installing i3 itself"$RST
    sudo apt-get install -y -qq i3 i3blocks i3lock > /dev/null

    # arc theme
    echo $LBLU"Installing arc theme"$RST
    if [[ -e /proc/device-tree/model ]]; # raspberry pi
    then
        wget -nv https://download.opensuse.org/repositories/home:Horst3180/Debian_8.0/Release.key -O Release.key
        sudo apt-key add - < Release.key > /dev/null
        sudo apt-get update &> /dev/null
        sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/Debian_8.0/ /' > /etc/apt/sources.list.d/arc-theme.list" > /dev/null
        sudo apt-get update &> /dev/null
        sudo apt-get install -y -qq --allow-unauthenticated arc-theme > /dev/null
    else
        wget -nv https://download.opensuse.org/repositories/home:Horst3180/xUbuntu_16.04/Release.key -O Release.key
        sudo apt-key add - < Release.key
        sudo apt-get update &> /dev/null
        sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /' > /etc/apt/sources.list.d/arc-theme.list"
        sudo apt-get update &> /dev/null
        sudo apt-get install -y -qq --allow-unauthenticated arc-theme > /dev/null
    fi

    # paper icons
    echo $LBLU"Installing paper icons theme"$RST
    if [[ -e /proc/device-tree/model ]]; # raspberry pi
    then
        wget 'https://snwh.org/paper/download.php?owner=snwh&ppa=pulp&pkg=paper-icon-theme,16.04' -O icon-theme.deb &> /dev/null
        wget 'https://snwh.org/paper/download.php?owner=snwh&ppa=pulp&pkg=paper-gtk-theme,16.04' -O paper-theme.deb &> /dev/null
        sudo dpkg -i icon-theme.deb &> /dev/null
        sudo dpkg -i paper-theme.deb &> /dev/null
        rm icon-theme.deb
        rm paper-theme.deb
    else
        sudo add-apt-repository ppa:snwh/pulp < \n &> /dev/null
        sudo apt-get update &> /dev/null
        sudo apt-get install -y -qq paper-icon-theme\
                                    paper-cursor-theme\
                                    paper-gtk-theme > /dev/null
    fi
    echo $LYEL"  After the installation, open lxappearance and change the theme and the icons"$RST

    

fi

# MISC
mkdir -p $(xdg-user-dir PICTURES)/screen_shots
mkdir -p .config/i3/
GIT_DIR=$(dirname $(realpath $0))

# where to put my dot files
DOT_DIR=$HOME/.mydotfiles
mkdir -p $DOT_DIR
mkdir -p $DOT_DIR/vim
mkdir -p $DOT_DIR/i3
mkdir -p $DOT_DIR/scripts

# VIM
echo $LBLU"Installing vimrc. If previous rc file is encountered, it will be saved as .vimrc_old"$RST
cp $GIT_DIR/vim/vimrc $DOT_DIR/vim/vimrc
if [[ -e $HOME/.vimrc ]];  # if exists
then
    if [[ ! -h $HOME/.vimrc ]];  # if is not a symolic link
    then
        mv $HOME/.vimrc $HOME/.vimrc_old
    fi
fi
ln -sf $DOT_DIR/vim/vimrc $HOME/.vimrc

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
    echo $LYEL"  i3-gaps seams to be installed on ~/apps/src/i3-gaps. Skipping"$RST
fi

# i3
echo $LBLU"Installing config files and scripts"$RST
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
cp $GIT_DIR/scripts/MEM_usage.sh $DOT_DIR/scripts/MEM_usage.sh
cp $GIT_DIR/scripts/screenlock.sh $DOT_DIR/scripts/screenlock.sh

# font awesome
echo $LBLU"Installing fonts"$RST
if [[ ! -e $HOME/.fonts/fontawesome-webfont.ttf ]];
then
    cd $DOT_DIR
    wget http://fontawesome.io/assets/font-awesome-4.7.0.zip
    unzip font-awesome-4.7.0.zip
    cd font-awesome-4.7.0/fonts
    mkdir -p $HOME/.fonts
    cp fontawesome-webfont.ttf $HOME/.fonts
else
    echo $LYEL"  Font Awesome seams to be installed in ~/.fonts. Skipping"$RST
fi

# font san francisco display
if [[ ! -e "$HOME/.fonts/System San Francisco Display Bold.ttf" ]];
then
    cd $DOT_DIR
    git clone https://github.com/supermarin/YosemiteSanFranciscoFont.git
    cd YosemiteSanFranciscoFont/
    cp *.ttf $HOME/.fonts
else
    echo $LYEL"  Font San Francisco Display seams to be installed in ~/.fonts. Skipping"$RST
fi

if [ "$(ps aux | grep -e i3 | grep -v grep | awk '{print $11}' | grep -e ^i3$)" == "i3" ];
then
    i3-msg restart
else
    echo $LGRE"Log out and re-log in using i3 to enjoy your productivity"
fi

echo 
echo $LBLU"In order to get the screens work, log in into i3, execute the program arandr,"
echo "arrange the displays and save the configuration in the predefined folder with"
echo "the name 'myscreenlayout.sh'. Then, log out and log in again."$RST


# TODO change desktop background
# TODO multimonitor support for i3lock
# TODO bash prompt
# TODO take a look at media keys
