local map = vim.api.nvim_set_keymap
local g = vim.g

g.mapleader = ","
map('', '<leader>h', ':nohlsearch<CR>', { noremap = true, silent = true })
