#!/bin/bash

# Spawns a tmux session and begin
tmux new-session -d -s update-arch

tmux send-keys -t update-arch "./updatearch.sh''" ENTER

tmux attach -t update-arch

