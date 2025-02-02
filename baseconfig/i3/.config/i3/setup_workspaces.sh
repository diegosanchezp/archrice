#!/bin/bash

# Set wallpaper and generate colorscheme when i3 launches
setwall

bash "$HOME/.config/polybar/launch.sh"

# Opens browser webpages in workspace 1
i3-msg "workspace 1; append_layout $HOME/.config/i3/workspace-1.json" &&
setup_workspace_1.py

# St terminal layout
bash "$HOME/.config/i3/setup_workspaces_2.sh" &&

# Open obsidian
i3-msg "workspace 3; append_layout $HOME/.config/i3/workspace-3.json" &&
i3-msg "workspace 3; exec --no-startup-id obsidian" &&

# Scratchpad notes
bash "$HOME/.config/i3/scratchpad.sh"

# Open gnome system monitor on workspace 4
i3-msg "workspace 4; append_layout $HOME/.config/i3/workspace-4.json" &&
i3-msg "workspace 4; exec --no-startup-id gnome-system-monitor --show-resources-tab" &&

# Go back to workspace 1 for browsing
i3-msg "workspace 1"
