#!/bin/bash

# Append layout in workspace 4
i3-msg "workspace 4; append_layout \"~/.config/i3/scratchpad-layout.json\"" &&

# Move container to scratchpad
i3-msg "workspace 4; [con_mark=\"start_on_scratch\"] move scratchpad" && \

# Spawn a terminal with neovim
i3-msg "workspace 4; exec bash ~/.config/i3/scratchpad_command.sh" &&

# Return back to previous workspace
i3-msg "workspace back_and_forth"
