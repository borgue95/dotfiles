#!/bin/bash
while [[ 1 ]]
    do 
        wget http://ipinfo.io/ip -qO - > $HOME/Dropbox/myip.txt
        sleep 3600
    done
