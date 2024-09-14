#!/bin/bash
alacritty --title "Notes" -e zsh -c "nvim -c ':Copilot disable' -c 'lua require(\"telescope.builtin\").oldfiles({cwd = \"/home/diego/Documents\"})' && exec zsh"


