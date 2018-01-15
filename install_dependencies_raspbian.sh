#!/bin/bash

# Install dependencies for ubuntu based systems (tested on ubuntu 16.04)

# prevent error snowballing
set -e -o errexit

# pretty terminal colors for information:
LBLU=$(tput setaf 12)  # light blue
LYEL=$(tput setaf 11)  # light yellow
LGRE=$(tput setaf 10)  # light green
RST=$(tput sgr0)

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
                            realpath\
                            rofi\
                            rxvt-unicode\
                            scrot\
                            unzip\
                            vim\
                            wget\
                            xdotool > /dev/null

# i3-gaps dependencies
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
wget -nv https://download.opensuse.org/repositories/home:Horst3180/Debian_8.0/Release.key -O Release.key
sudo apt-key add - < Release.key > /dev/null
sudo apt-get update &> /dev/null
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/Debian_8.0/ /' > /etc/apt/sources.list.d/arc-theme.list" > /dev/null
sudo apt-get update &> /dev/null
sudo apt-get install -y -qq --allow-unauthenticated arc-theme > /dev/null

# paper icons
echo $LBLU"Installing paper icons theme"$RST
wget 'https://snwh.org/paper/download.php?owner=snwh&ppa=pulp&pkg=paper-icon-theme,16.04' -O icon-theme.deb &> /dev/null
wget 'https://snwh.org/paper/download.php?owner=snwh&ppa=pulp&pkg=paper-gtk-theme,16.04' -O paper-theme.deb &> /dev/null
sudo dpkg -i icon-theme.deb &> /dev/null
sudo dpkg -i paper-theme.deb &> /dev/null
rm icon-theme.deb
rm paper-theme.deb
echo $LYEL"  After the installation, open lxappearance and change the theme and the icons"$RST

