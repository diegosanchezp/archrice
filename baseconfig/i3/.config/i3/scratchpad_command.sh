#!/bin/bash
alacritty --title "Notes" -e zsh -c "nvim -c ':colorscheme github_light_tritanopia' -c ':Copilot disable' -c 'lua require(\"telescope.builtin\").oldfiles({cwd = \"/home/diego/Documents\"})' && exec zsh"


