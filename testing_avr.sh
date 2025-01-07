#!/bin/bash
# test USBasp with connected MCU (ATmega8)
avrdude -p m8 -c usbasp -P usb -n
