#!/usr/bin/env python3

import dbus
import sys

def print_help(script):
    print(script + " [--up | --down] [val | -val]")

def is_integer(val):
    try:
        int(val)
        return True
    except ValueError:
        return False

def transform_100_to_max_range(data, max_range):
    if (data > 100):
        return max_range
    if (data < -100):
        return -max_range

    return int(float(max_range) * (data / 100.0))

def kb_light_set(delta):
    bus = dbus.SystemBus()
    kbd_backlight_proxy = bus.get_object('org.freedesktop.UPower', '/org/freedesktop/UPower/KbdBacklight')
    kbd_backlight = dbus.Interface(kbd_backlight_proxy, 'org.freedesktop.UPower.KbdBacklight')

    current = kbd_backlight.GetBrightness()
    maximum = kbd_backlight.GetMaxBrightness()

    delta = transform_100_to_max_range(delta, maximum)
    kbd_backlight.SetBrightness(current + delta)

if __name__ ==  '__main__':
    def_delta = 15  # of 100
    if len(sys.argv) == 2:
        if sys.argv[1] == "--up":
            kb_light_set(def_delta)
        elif sys.argv[1] == "--down":
            kb_light_set(-def_delta)
        elif is_integer(sys.argv[1]):
            kb_light_set(int(sys.argv[1]))
        else:
            print_help(sys.argv[0])
    else:
        print_help(sys.argv[0])

