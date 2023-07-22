#!/bin/bash

FILE_PATH="${1:-./airootfs/etc/pacman.d/mirrorlist}"
wget "https://archlinux.org/mirrorlist/?country=US&protocol=http&protocol=https&ip_version=4&ip_version=6" -O $FILE_PATH

# Uncomment server urls
sed  -i 's/^#Server/Server/' $FILE_PATH
