-- Set , as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)

-- Enable filetype detection and plugins
-- vim.cmd('filetype on')

-- Disable automatic commenting on newline for all filetypes
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "*",
--   callback = function()
--     vim.opt_local.formatoptions:remove{'c', 'r', 'o'}
--   end,
-- })

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- timeoutlen will give 2 seconds to enter the next keys after pressing space as leader, making it easier to perform leader key mappings at a relaxed pace
vim.o.timeoutlen = 2000 -- time in milliseconds (2 seconds here)

vim.o.termguicolors = true

vim.o.tabstop = 2 -- to specify the number of spaces a tab counts for
vim.o.shiftwidth = 2 -- to control the number of spaces used for each step of indentation
vim.o.softtabstop = 2 -- to control how many spaces a Tab counts for while editing
vim.o.expandtab = true -- to convert tabs to spaces

-- vim.g.noshiftround = true

-- override the default tab settings for these specific files
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"html", "htmldjango", "jinja.html", "xml"},
    command = "setlocal shiftwidth=4 tabstop=4"
})

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Make line numbers default
vim.o.number = true

-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

vim.o.foldenable = true -- enable folding
vim.o.foldcolumn = '0' -- '0' means fold column is disabled
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99 -- start all folds opened when opening a file

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

--  See `:help hlsearch`
-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
-- Clear highlights on search when pressing <space> + h in normal mode
vim.api.nvim_set_keymap('', '<leader>h', ':nohlsearch<CR>', { noremap = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)



-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })



-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Trim trailing whitespace function
local function trim_whitespace()
  local view = vim.fn.winsaveview()
  vim.cmd([[keeppatterns %s/\s\+$//e]])
  vim.fn.winrestview(view)
end

-- Create TrimWhitespace command
vim.api.nvim_create_user_command('TrimWhitespace', trim_whitespace, {})

-- Trim whitespaces from file with <Leader>t
vim.keymap.set('n', '<Leader>t', trim_whitespace, opts)

-- Spell-check toggles
vim.keymap.set('n', '<Leader>o', ':setlocal spell! spelllang=en_us<CR>', opts)
vim.keymap.set('n', '<Leader>so', ':setlocal spell! spelllang=es<CR>', opts)
vim.keymap.set('n', '<Leader>do', ':setlocal spell! spelllang=en_us,es<CR>', opts)

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- See folder lua/plugins/
require('lazy').setup({
  import = "plugins",
})
