# dotfiles

## i3(-gaps) rice

Those are my dot files nicely placed in visible directories. I've made a script, `installer.sh`, that install all the dependencies and copy the dotfiles to the appropiate directory. 

* `./i3`. Contains basic configs, like i3 itself, compton, i3blocks and rofi. It contains an init script which is called at login. 
* `./scripts`. Contains my scripts for doing desktop related things, such as blocks for i3blocks, taking screen shots or changing all the color shceme based on the wallpaper.
* `./vim`. Contains my vimrc file.
* `./wallpapers`. Contains various wallpapers that I like, most from Apple MacOS. 

## Installer

* A folder named `.mydotfiles` will be created to store the files in your home directory.

* To install this setup from scratch, execute `bash installer.sh --install-dependencies` from a terminal. Only valid for `apt` based distros. I've tried this in Ubuntu 16.04. 

* To install only the dot files (reinstalling), execute `bash installer.sh`. 

* To modify the files consistenly, edit them from the folder you have downloaded and execute `bash installer.sh` to place the updated content into each folder.
