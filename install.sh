#!/bin/bash

echo "You need to install some packages:"
echo "  - arandr"
echo "  - dialog"
echo "  - vim"
echo "  - rxtv-unicode"
echo "  - ranger"
echo
# TODO ask for arch or debian based and install them automatically
# Exit 1 on error, continue on success

DIALOG="dialog --stdout"
WIDTH=50
HEIGHT=14

myexit() {\
    clear; exit $1
}

###############################################################################
# FIXING FONTS ################################################################
###############################################################################


###############################################################################
# SETTING UP RESOLUTION #######################################################
###############################################################################

arandr1() { \
    title="Running arandr"
    question="Run arandr and save your configuration to ~/.screenlayout/myscreenlayout.sh.\n\nHave you done that?"
    $DIALOG --title "$title" --yesno "$question" $HEIGHT $WIDTH
    echo $?
}

arandr_mode_not_present() { \
    title="Mode not present"
    question="Is your mode listed?"
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
    $DIALOG --title $title --msgbox "$msgbox" $HEIGHT $WIDTH
    echo $?
}

yesno=$(arandr1)
if [[ $yesno -eq "0" ]];
then # yes
    yesno=$(arandr_mode_not_present)
    if [[ $yesno -eq "1" ]];
    then # no
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
###############################################################################

# COPY vimrc

# Install plugins

