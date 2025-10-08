--[[
  Nevim options configuration
  see :h vim.o ofr :h vim.opt
  for more
]]
local o = vim.o
local g = vim.g
local opt = vim.opt

vim.api.nvim_create_autocmd("FileType", {
    pattern = {"html", "htmldjango", "jinja.html"},
    command = "setlocal shiftwidth=4 tabstop=4"
})

o.listchars = "trail:~,extends:>,precedes:<,tab:▸·"

o.list = true
o.confirm = true

o.tabstop = 2
o.shiftwidth = 2
o.softtabstop = 2

-- pywall recomendation
o.termguicolors = true
o.encoding = "utf-8"

-- Tabs are spaces
o.expandtab = true
g.noshiftround = true
o.autoindent = true
o.wrap = true
o.relativenumber = true
o.number = true

-- Set to true if you have a Nerd Font installed and selected in the terminal
g.have_nerd_font = true

opt.clipboard:append {"unnamedplus"}

-- setting auto will remove the annoying random number on foldcolumn, if there is less than 9 levels of folding, for more, than 9, numbers will start to appear again. It also adjusts the foldcolumn size/width accordingly
-- o.foldcolumn = 'auto:9'
-- o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]] -- This works only if foldcolumn is enabled
o.foldenable = true -- enable folding
o.foldcolumn = '0' -- '0' means fold column is disabled
o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
o.foldlevelstart = 99 -- start all folds opened when opening a file


-- Splits open at the bottom and right, which is non-retarded, unlike vim defaults.

o.splitbelow = true
o.splitright = true

-- obsidian.nvim char concealling
-- https://github.com/epwalsh/obsidian.nvim?tab=readme-ov-file#concealing-characters
vim.opt.conceallevel = 1
