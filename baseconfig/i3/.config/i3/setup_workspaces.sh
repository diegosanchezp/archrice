#!/bin/bash

# Set wallpaper and generate colorscheme when i3 launches
setwall

bash "$HOME/.config/polybar/launch.sh"

i3-msg "workspace 1; append_layout $HOME/.config/i3/workspace-1.json"

# Opens browser webpages in workspace 1
setup_workspace_1.py

# St terminal layout
bash $HOME/.config/i3/setup_workspaces_2.sh

i3-msg "workspace 3; append_layout $HOME/.config/i3/workspace-3.json"

i3-msg "workspace 3; exec --no-startup-id obsidian"

# Scratchpad
bash "$HOME/.config/i3/scratchpad.sh"
