local utils = require("utils")
-- Install plugin manager
-- utils.install_packer()


-- Telescope configuration
local telescope = require("telescope")
local telescope_actions = require('telescope.actions')

telescope.setup {
  defaults = {
    file_ignore_patterns = {"node_modules", ".git"},
    path_display = {"smart"},
    dynamic_preview_title = true,
    mappings = {
      i = {
        ["<esc>"] = telescope_actions.close
      },
    },
  },
  pickers = {
    find_files = {
      theme = "dropdown",
      -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
    },
    live_grep = {
      theme = "dropdown",
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
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end


  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

local lspconfig = require('lspconfig')


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

vim.lsp.config("*", {
  capabilities = capabilities,
  on_attach = on_attach
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

-- A tree like view for symbols in Neovim using the Language Server Protocol
require("symbols-outline").setup()

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
vim.lsp.config('odoo_lsp', {
  name = 'odoo-lsp',
  cmd = { 'odoo-lsp' },
  filetypes = { 'javascript', 'xml', 'python' },
  root_makers = {
    '.odoo_lsp', '.odoo_lsp.json', '.git'
  },
  on_attach = on_attach,
})
vim.lsp.enable('odoo_lsp')

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
