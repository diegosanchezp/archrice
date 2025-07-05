#!/bin/bash
i3-msg "workspace 2; append_layout $HOME/.config/i3/workspace-2.json"

# Spawn 4 alacritty terminals
for ((n=0;n<1;n++)); do
  i3-msg "workspace 2; exec alacritty";
done
