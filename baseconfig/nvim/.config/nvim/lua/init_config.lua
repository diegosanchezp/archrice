-- vim: ts=2 sts=2 sw=2 et
local utils = require("utils")
-- Install plugin manager
-- utils.install_packer()


-- Telescope configuration
local telescope = require("telescope")
local telescope_actions = require('telescope.actions')
local builtin = require 'telescope.builtin'

telescope.setup {
  defaults = {
    file_ignore_patterns = {"node_modules", ".git"},

    wrap_results = true,
    path_display = {"smart"},
    dynamic_preview_title = true,
  },
  pickers = {
    find_files = {
      theme = "dropdown",
      -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
    },
    live_grep = {
      theme = "ivy",
      path_display = {"absolute"}
    },
    buffers = {
      theme = "dropdown",
    },
    help_tags = {
      theme = "dropdown",
    },
    oldfiles = {
      theme = "dropdown",
    },
  },
}
vim.o.completeopt = "menuone,noselect"

-- active the theme call this in your neovim config
-- local pywal = require('pywal')

-- pywal.setup()
-- require("transparent").setup({
--   extra_groups = { -- table/string: additional groups that should be clear
--     -- In particular, when you set it to 'all', that means all avaliable groups
--
--     -- example of akinsho/nvim-bufferline.lua
--     "BufferLineTabClose",
--     "BufferlineBufferSelected",
--     "BufferLineFill",
--     "BufferLineBackground",
--     "BufferLineSeparator",
--     "BufferLineIndicatorSelected",
--   },
--   exclude_groups = {}, -- table: groups you don't want to clear
-- })
require('nvim_comment').setup()


-- Mappings.
local opts = { noremap=true, silent=true }

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)

    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.
    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

    -- Find references for the word under your cursor.
    map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

    -- Jump to the implementation of the word under your cursor.
    --  Useful when your language has ways of declaring types without an actual implementation.
    map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

    -- Jump to the definition of the word under your cursor.
    --  This is where a variable was first declared, or where a function is defined, etc.
    --  To jump back, press <C-t>.
    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

    -- WARN: This is not Goto Definition, this is Goto Declaration.
    --  For example, in C this would take you to the header.
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    -- Fuzzy find all the symbols in your current document.
    --  Symbols are things like variables, functions, types, etc.
    map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

    -- Fuzzy find all the symbols in your current workspace.
    --  Similar to document symbols, except searches over your entire project.
    map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

    -- Jump to the type of the word under your cursor.
    --  Useful when you're not sure what type a variable is and you want to see
    --  the definition of its *type*, not where it was *defined*.
    map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
  end
})

-- Diagnostic Config
-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  } or {},
  virtual_text = {
    source = 'if_many',
    spacing = 2,
    format = function(diagnostic)
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
}
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer

-- local on_attach = function(client, bufnr)
--   local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
--   local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end


-- See `:help vim.lsp.*` for documentation on any of the below functions
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
-- end

local lspconfig = require('lspconfig')


-- vim.lsp.enable('basedpyright')
vim.lsp.enable('pyright')
vim.lsp.enable('bashls')
vim.lsp.enable('ts_ls')
vim.lsp.enable('cssls')
-- vim.lsp.enable('svelte')
vim.lsp.enable('html')

--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- I don't know if nvim_cmp is needed for nvim v11
-- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#jsonls
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#html
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}
vim.lsp.config("*", {
  capabilities = capabilities,
})

vim.lsp.config('html', {
  capabilities = capabilities,
  filetypes = { "html", "templ", "htmldjango", "jinja.html" },
})

-- Enable language servers for schemas, to have docker, cloudformation, github actinons yaml syntax support

vim.lsp.enable('jsonls')
vim.lsp.enable('yamlls')

vim.lsp.config('jsonls', {
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
})

vim.lsp.config('yamlls', {
  settings = {
    yaml = {
      schemaStore = {
        -- You must disable built-in schemaStore support if you want to use
        -- this plugin and its advanced options like `ignore`.
        enable = false,
        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        url = "",
      },
      schemas = require('schemastore').yaml.schemas(),
    },
  },
})

-- A sidebar with a tree-like outline of symbols from your code, powered by LSP.
local outline = require("outline")
outline.setup({
  -- leaving empty to use defaults
  relative_width = false,
  width = 40,
  preview_window = {
    width = 80,
  },
  providers = {
    priority = { 'lsp', 'markdown', 'norg', 'treesitter' },
  },
})

-- vim.api.nvim_create_autocmd("FileType", { pattern = "Outline", command = [[setlocal nofoldenable]] })

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

local ftMap = {
    vim = 'indent',
    -- python = {'lsp', 'treesitter', 'indent'},
    git = '',
    Outline = ''
}

-- lsp->treesitter->indent
---@param bufnr number
---@return Promise
local function customizeSelector(bufnr)
    local function handleFallbackException(err, providerName)
        if type(err) == 'string' and err:match('UfoFallbackException') then
            return require('ufo').getFolds(bufnr, providerName)
        else
            return require('promise').reject(err)
        end
    end

    return require('ufo').getFolds(bufnr, 'lsp'):catch(function(err)
        return handleFallbackException(err, 'treesitter')
    end):catch(function(err)
        return handleFallbackException(err, 'indent')
    end)
end

require('ufo').setup({
    provider_selector = function(bufnr, filetype, buftype)
        return ftMap[filetype] or customizeSelector
    end
})

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "Outline",
--   callback = function()
--     vim.opt_local.foldenable = false
--   end,
-- })

local cmp = require 'cmp'

local luasnip = require 'luasnip'
-- Load friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- Load VSCode CloudFormation snippets
require("luasnip.loaders.from_vscode").lazy_load({
  paths={"~/vscode-cloudformation-snippets"},
  exclude = {"yaml.docker-compose"}
})

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'nvim_lua' },
    { name = 'path' },
    { name = 'buffer' },
  },
}

require'lspconfig'.phpactor.setup{
    on_attach = on_attach,
    init_options = {
        ["language_server_phpstan.enabled"] = false,
        ["language_server_psalm.enabled"] = false,
    }
}

-- Define your odoo LSP config
-- This is causing me more problems with other type of files, it lags the help (shift+k)
vim.lsp.config('odoo_lsp', {
  name = 'odoo-lsp',
  cmd = { 'odoo-lsp' },
  filetypes = { 'javascript', 'xml', 'python' },
  root_markers = {'.odoo_lsp', '.odoo_lsp.json'},
})
-- vim.lsp.enable('odoo_lsp')

require("obsidian").setup({
    workspaces = {
      {
        name = "personal",
        path = "~/Documents/ObsidianVaults/diegos-knowledge/",
      },
      {
        name = "personal-smartphone",
        path = "~/Documents/obsidian-smartphone-notes",
      },
    },

    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },

    picker = {
      -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
      name = "telescope.nvim",
      -- Optional, configure key mappings for the picker. These are the defaults.
      -- Not all pickers support all mappings.
      note_mappings = {
        -- Create a new note from your query.
        new = "<C-x>",
        -- Insert a link to the selected note.
        insert_link = "<C-l>",
      },
      tag_mappings = {
        -- Add tag(s) to current note.
        tag_note = "<C-x>",
        -- Insert a tag at the current location.
        insert_tag = "<C-l>",
      },
    },

    -- Optional, sort search results by "path", "modified", "accessed", or "created".
    -- The recommend value is "modified" and `true` for `sort_reversed`, which means, for example,
    -- that `:ObsidianQuickSwitch` will show the notes sorted by latest modified time
    sort_by = "modified",
    sort_reversed = true,

    -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
    -- URL it will be ignored but you can customize this behavior here.
    ---@param url string
    follow_url_func = function(url)
      -- Open the URL in the default web browser.
      -- vim.fn.jobstart({"xdg-open", url})  -- linux
      vim.ui.open(url) -- need Neovim 0.10.0+
    end,
})

require('mini.surround').setup({

    custom_surroundings = {
      -- Make `)` insert parts with spaces. `input` pattern stays the same.
      [')'] = { output = { left = '(', right = ')' } },
      ['('] = { output = { left = '(', right = ')' } },

      -- Use function to compute surrounding info
      ['*'] = {
        input = function()
          -- Default to 2 stars if in markdown file, otherwise 1
          local default_stars = vim.bo.filetype == 'markdown' and 2 or 1
          local prompt = 'Number of * to find (' .. default_stars .. ' default)'
          local n_star = MiniSurround.user_input(prompt) or tostring(default_stars)
          local many_star = string.rep('%*', tonumber(n_star) or default_stars)
          return { many_star .. '().-()' .. many_star }
        end,
        output = function()
          -- Default to 2 stars if in markdown file, otherwise 1
          local default_stars = vim.bo.filetype == 'markdown' and 2 or 1
          local prompt = 'Number of * to output (' .. default_stars .. ' default)'
          local n_star = MiniSurround.user_input(prompt) or tostring(default_stars)
          local many_star = string.rep('*', tonumber(n_star) or default_stars)
          return { left = many_star, right = many_star }
        end,
      },
    },
    mappings = {
      add = 'sa', -- Add surrounding in Normal and Visual modes
      delete = 'sd', -- Delete surrounding
      find = 'sf', -- Find surrounding (to the right)
      find_left = 'sF', -- Find surrounding (to the left)
      highlight = 'sh', -- Highlight surrounding
      replace = 'sr', -- Replace surrounding
      update_n_lines = 'sn', -- Update `n_lines`

      suffix_last = 'l', -- Suffix to search with "prev" method
      suffix_next = 'n', -- Suffix to search with "next" method
    },
})


-- https://github.com/nvim-treesitter/nvim-treesitter
require'nvim-treesitter'.setup {
  -- Directory to install parsers and queries to
  install_dir = vim.fn.stdpath('data') .. '/site'
}

require'nvim-treesitter'.install { 'javascript', 'python', 'xml', 'json', 'yaml', 'html', 'htmldjango', 'css', 'scss' }


require'treesitter-context'.setup{
  enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  multiwindow = false, -- Enable multiwindow support.
  max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
  min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  line_numbers = true,
  multiline_threshold = 20, -- Maximum number of lines to show for a single context
  trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
  -- Separator between context and content. Should be a single character string, like '-'.
  -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  separator = nil,
  zindex = 20, -- The Z-index of the context window
  on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
}

vim.keymap.set("n", "[c", function()
  require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true })
