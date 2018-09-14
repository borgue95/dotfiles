# TODO solve paths

# solve power key
echo HandlePowerKey=ignore | sudo tee -a /etc/systemd/logind.conf
sudo cp install_scripts/macUbuntu18/mac_power_button_handler /etc/acpi/events/

# invert FN key
#sudo bash -c "echo 2 > /sys/module/hid_apple/parameters/fnmode" # not persistent
echo options hid_apple fnmode=2 | sudo tee -a /etc/modprobe.d/hid_apple.conf
sudo update-initramfs -u -k all

# solve backlight
cat install_scripts/macUbuntu18/mac_backlight_patch | sudo tee -a /etc/X11/xorg.conf
