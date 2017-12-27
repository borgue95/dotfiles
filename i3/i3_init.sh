# i3blocks config file
#
# Please see man i3blocks for a complete reference!
# The man page is also hosted at http://vivien.github.io/i3blocks
#
# List of valid properties:
#
# align
# color
# command
# full_text
# instance
# interval
# label
# min_width
# name
# separator
# separator_block_width
# short_text
# signal
# urgent

# Global properties
#
# The top properties below are applied to every block, but can be overridden.
# Each block command defaults to the script name to avoid boilerplate.
command=/usr/share/i3blocks/$BLOCK_NAME
separator_block_width=15
#markup=none

# Volume indicator
#
# The first parameter sets the step (and units to display)
# The second parameter overrides the mixer selection
# See the script for details.
[volume]
label=
instance=Master
#instance=PCM
interval=1
signal=10
#command=/usr/share/i3blocks/volume 5 pulse
command=/usr/share/i3blocks/volume

# Disk usage
#
# The directory defaults to $HOME if the instance is not specified.
# The script may be called with a optional argument to set the alert
# (defaults to 10 for 10%).
[disk]
label=HOME 
#instance=/mnt/data
interval=30

# Network interface monitoring
#
# If the instance is not specified, use the interface used for default route.
# The address can be forced to IPv4 or IPv6 with -4 or -6 switches.
[iface]
#instance=wlan0
color=#00FF00
interval=30
separator=false

[bandwidth]
#instance=eth0
label=
interval=5
separator=true

# Memory usage
#
# The type defaults to "mem" if the instance is not specified.
[memory]
label=MEM
instance=mem
separator=true
interval=10

[CPU]
label= CPU:
command=$HOME/.config/i3/myscripts/CPU_usage.sh
interval=2
markup=pango

[GPU]
label= GPU:
command=$HOME/.config/i3/myscripts/GPU_usage.sh
interval=2
markup=pango

# Date Time
#
[time]
command=date '+%d-%m-%Y %H:%M:%S'
interval=1
