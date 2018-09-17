#!/bin/bash

# prevent error snowballing
set -e -o errexit

DIALOG="dialog --stdout"
WIDTH=50
HEIGHT=14

myexit() {\
    clear
    exit $1
}

running_from_gitfolder() { \
    title="Running from git folder"
    question="Are you running this script from the git folder? If not, you must."
    $DIALOG --title "$title" --yesno "$question" $HEIGHT $WIDTH
    echo $?
}
yesno=$(running_from_gitfolder)
if [[ $yesno -eq "1" ]];
then # no
    myexit 1
fi

select_distro() {
    title="Select a distribution"
    desc="Select your distribution to know the package manager:"
    distro=$($DIALOG --title "$title" --radiolist "$desc" $HEIGHT $WIDTH 2 \
        1 "Ubuntu based" on \
        2 "Arch based" off
    )
    echo $distro
}

installing_pkg_process() {
    title="Installing packages"
    infobox="Wait while I install needed packages for you..."
    $DIALOG --title "$title" --infobox "$infobox" $HEIGHT $WIDTH
}

# Selecting distribution and installing utilities
distro=$(select_distro $WIDTH $HEIGHT)
last_result=$?

installing_pkg_process

if [[ ! $last_result -eq "1" ]]
then
    case $distro in
        1)
            #bash install_scripts/app_generic_ubuntu.sh
            ;;
        2)
            bash install_scripts/app_generic_arch.sh
            ;;
        *)
            ;;
    esac
else
    myexit 1
fi

###############################################################################
# SETTING UP RESOLUTION #######################################################

# TODO move this to another script. Here, ask if resolution is OK; 
# If is OK, go ahead
# If not, ask, for width and height and call a magic script which sets the resolution

arandr1() { \
    title="Running arandr"
    question="If your resolution is incorrect, run arandr and save your configuration to ~/.screenlayout/myscreenlayout.sh.\n\nHave you done that?"
    $DIALOG --title "$title" --yesno "$question" $HEIGHT $WIDTH
    echo $?
}

arandr_mode_not_present() { \
    title="Mode not present"
    question="Have you got any trouble?"
    $DIALOG --title "$title" --yesno "$question" $HEIGHT $WIDTH
    echo $?
}

arandr_customize_script() { \
    title="Scripting time"
    msgbox="Customize custom_resolution.sh script to create a new mode and run it. After that, reexecute this script and answer yes to this question"
    $DIALOG --title "$title" --msgbox "$msgbox" $HEIGHT $WIDTH
    echo $?
}

arandr_just_do_it() { \
    title="Arandr"
    msgbox="Then just do it. After that, reexecute this script and answer yes to this question"
    $DIALOG --title "$title" --msgbox "$msgbox" $HEIGHT $WIDTH
    echo $?
}

yesno=$(arandr1)
if [[ $yesno -eq "0" ]];
then # yes
    yesno=$(arandr_mode_not_present)
    if [[ $yesno -eq "0" ]];
    then # yes
        arandr_customize_script
        myexit 0
    # else continue
    fi
else # no
    arandr_just_do_it
    myexit 0
fi

###############################################################################
# SETTING UP VIM

vim_installing_plugins() { \
    title="VIM"
    infobox="Installing VIM plugin manager and plugins"
    $DIALOG --title "$title" --infobox "$infobox" $HEIGHT $WIDTH
}

vim_installing_plugins

# COPY vimrc
if [[ -e $HOME/.vimrc ]];  # if exists vimrc
then
    if [[ ! -h $HOME/.vimrc ]];  # if is not a symolic link
    then
        mv $HOME/.vimrc $HOME/.vimrc_old
    fi
fi
ln -sf $(pwd)/config_files/vimrc $HOME/.vimrc

# VIM plugins
if [[ ! -e ~/.vim/bundle/Vundle.vim ]];
then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
fi

###############################################################################
# SETTING UP I3-GAPS

i3gaps_installing() {
    title="i3 gaps"
    infobox="Installing i3 gaps from source... please wait"
    $DIALOG --title "$title" --infobox "$infobox" $HEIGHT $WIDTH
}

i3gaps_installing

current_dir=$(pwd)
mkdir -p ~/apps/src
cd ~/apps/src
if [ ! -d "i3" ]
then
    git clone https://github.com/Airblader/i3.git
fi
cd i3
autoreconf --force --install
rm -rf build/
mkdir -p build && cd build/
../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
make
sudo make install
cd $current_dir

###############################################################################
# SETTING UP URXVT
ln -sf $(pwd)/config_files/Xdefaults ~/.Xdefaults

###############################################################################
# SETTING UP SCRIPTS

ask_for_configuration() {
    title="Select a type of configuration"
    text="Here are some pre-configured environments. Select the most appropiate:"
    config=$($DIALOG --title "$title" --radiolist "$text" $HEIGHT $WIDTH 2 \
        1 "Mac with Ubuntu 18" on \
        2 "Desktop with Ubuntu 16" off
    )
    echo $config
    
}

setting_up_scripts() {
    title="Scripts"
    infobox="Setting up scripts..."
    $DIALOG --title "$title" --infobox "$infobox" $HEIGHT $WIDTH
    echo $?
}

config2=$(ask_for_configuration)
case $config2 in
    1)
        config=macUbuntu18
        ;;
    2)
        config=desktopUbuntu16
        ;;
    *)
        myexit 1
        ;;
esac

setting_up_scripts

# do general things for all configs
o_i3=$(pwd)/i3
d_i3=~/.config/i3
o_config_files=$(pwd)/config_files
d_config_fiels=$d_i3/config_files
o_ranger=$(pwd)/ranger
d_ranger=~/.config/ranger
o_scripts=$(pwd)/scripts
d_scripts=$d_i3/scripts

ln -sf $o_i3/config $d_i3/config
ln -sf $o_i3/init.sh $d_i3/init.sh

mkdir -p ~/.config/i3/config_files
ln -sf $o_config_files/compton.conf $d_config_fiels/compton.conf
ln -sf $o_config_files/i3blocks.conf $d_config_fiels/i3blocks.conf
ln -sf $o_config_files/rofi.conf $d_config_fiels/rofi.conf

mkdir -p ~/.config/ranger
ln -sf $o_ranger/rc.conf $d_ranger/rc.conf
ln -sf $o_ranger/rifle.conf $d_ranger/rifle.conf

mkdir -p ~/.config/i3/scripts
ln -sf $o_scripts/CPU_usage.sh $d_scripts/CPU_usage.sh
ln -sf $o_scripts/dmenu_mount.sh $d_scripts/dmenu_mount.sh
ln -sf $o_scripts/getmyip.sh $d_scripts/getmyip.sh
ln -sf $o_scripts/GPU_usage.sh $d_scripts/GPU_usage.sh
ln -sf $o_scripts/MEM_usage.sh $d_scripts/MEM_usage.sh
ln -sf $o_scripts/screenshot_full.sh $d_scripts/screenshot_full.sh
ln -sf $o_scripts/screenshot_selection.sh $d_scripts/screenshot_selection.sh
ln -sf $o_scripts/lock $d_scripts/lock
ln -sf $o_scripts/wallpaper $d_scripts/wallpaper


# do the specifics to the selected config
if [[ "$config" = "macUbuntu18" ]]
then
    bash install_scripts/macUbuntu18/mac_specifics.sh
    ln -sf $o_scripts/init/macUbuntu18.sh $d_i3/second_init.sh
    ln -sf $o_scripts/keyboard_backlight.py $d_scripts/keyboard_backlight.py
elif [[ "$config" = "desktopUbuntu16" ]]
then
    ln -sf $o_scripts/init/desktopUbuntu.sh $d_i3/second_init.sh
#elif [[ "$config" = "otherConfigHere" ]]
#then
#    # do things
else
    # cancelled
    myexit 1
fi

im_done() {
    title="DONE"
    infobox="The installation has finished. Congrats!"
    $DIALOG --title "$title" --msgbox "$infobox" $HEIGHT $WIDTH
}

im_done
myexit 0
