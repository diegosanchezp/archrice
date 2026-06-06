#!/bin/bash

SESSION_NAME="update-arch"
SCRIPT_DIR="$HOME/.local/bin"
SCRIPT_NAME="updatearch.sh"

# Check if the tmux session already exists
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo "Session '$SESSION_NAME' already exists. Attaching..."
    tmux attach-session -t "$SESSION_NAME"
else
    echo "Session '$SESSION_NAME' not found. Creating and starting update..."
    # Create a new detached session
    tmux new-session -d -s "$SESSION_NAME"
fi

# Send the command using absolute paths
tmux send-keys -t "$SESSION_NAME" "sudo bash $SCRIPT_DIR/$SCRIPT_NAME" ENTER

# Attach to the newly created session
tmux attach-session -t "$SESSION_NAME"

