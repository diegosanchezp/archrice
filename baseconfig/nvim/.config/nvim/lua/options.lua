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

opt.clipboard:append {"unnamedplus"}
o.foldmethod = "indent"

-- Splits open at the bottom and right, which is non-retarded, unlike vim defaults.

o.splitbelow = true
o.splitright = true
