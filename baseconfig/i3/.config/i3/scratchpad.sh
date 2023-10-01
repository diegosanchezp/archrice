#!/bin/bash

# Spawn a terminal
command="exec alacritty --class scratchpad,scratchpad"

i3-msg "$command"

# Move terminal to the scratchpad, wait one second, otherwise the "move" i3 command won't work
sleep 1s && i3-msg "[class=\"scratchpad\"] move scratchpad"
