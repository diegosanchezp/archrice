#!/bin/bash

# Set wallpaper and generate colorscheme when i3 launches
setwall

bash $HOME/.config/polybar/launch.sh

i3-msg 'workspace 1; append_layout /home/diego/.config/i3/workspace-1.json'

# Open google calendar window
i3-msg 'workspace 1; exec gtk-launch $(xdg-settings get default-web-browser) https://calendar.google.com'

# St terminal layout
bash $HOME/.config/i3/setup_workspaces_2.sh

i3-msg 'workspace 3; append_layout /home/diego/.config/i3/workspace-3.json'

i3-msg 'workspace 3; exec --no-startup-id obsidian'

