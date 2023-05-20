#!/bin/bash

sudo pacman -Syu
paccache --dryrun --keep 2
read -rp "Remove packages ? [y/n]: " answer

if [ "$answer" = "y" ]; then
  sudo paccache --remove --keep 2
fi

read -rp "Reboot ? [y/n]: " answer
if [ "$answer" = "y" ]; then
  sudo reboot
fi
