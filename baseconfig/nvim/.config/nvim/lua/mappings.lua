local map = vim.api.nvim_set_keymap
local g = vim.g

-- "noremap" disables recursive_mapping

g.mapleader = ","
map('', '<leader>h', ':nohlsearch<CR>', { noremap = true, silent = true })

-- Obsidian plugin mappings ---
-- n stands for normal mode

-- ,qs: quick switch
map('n', '<leader>qs', ':ObsidianQuickSwitch<CR>', {noremap = true})

-- ,toc: opens table of contents
map('n', '<leader>toc', ':ObsidianTOC<CR>', {noremap = true})

-- ,sn: search notes
map('n', '<leader>sn', ':ObsidianSearch<CR>', {noremap = true})

-- ,sy: opens SymbolsOutline and then opens all folds (like zR)
map('n', '<leader>sy', ':SymbolsOutline<CR>:normal! zR<CR>', { noremap = true, silent = true })
