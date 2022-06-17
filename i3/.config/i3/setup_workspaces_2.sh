#!/bin/bash
i3-msg 'workspace 2; append_layout $HOME/.config/i3/workspace-2.json'

# Spawn 4 st terminals
for ((n=0;n<4;n++)); do
  i3-msg 'workspace 2; exec --no-startup-id st';
done
