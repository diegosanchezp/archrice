#!/bin/bash

WORKSPACE_NUM=1
# Append layout in workspace 1
i3-msg workspace $WORKSPACE_NUM && \
i3-msg "append_layout \"~/.config/i3/scratchpad-layout.json\"" && \

# Move container to scratchpad
i3-msg "[con_mark=\"start_on_scratch\"] move scratchpad" && \

# Spawn a terminal with neovim, when the file is opened, open a table of contents, this mimics <leader>sy keybinding
setsid --fork alacritty --title "Notes" -e zsh -c "nvim -c ':colorscheme github_light_tritanopia' -c 'lua vim.defer_fn(function() vim.cmd(\"SymbolsOutline\"); vim.cmd(\"normal! zR\") end, 100)' ~/Documents/ObsidianVaults/diegos-knowledge/rutinas-diarias/rutinas-diarias.md && exec zsh"

# Show the scratchpad
i3-msg "scratchpad show"
