#!/bin/bash

echo "Running $1"
alacritty --option "env = { tesisdev = \"True\", tcommand = \"$*\" }"

