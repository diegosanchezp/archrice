-- vim: ts=2 sts=2 sw=2 et
return {
  -- the colorscheme should be available when starting Neovim
  {
    "projekt0n/github-nvim-theme",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme github_dark_high_contrast]])
    end,
  },
  {
    -- Detect tabstop and shiftwidth automatically
    'NMAC427/guess-indent.nvim'
  },
  {
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      opts = {
        sections = {
          lualine_c = {
            {
              "filename",
              newfile_status = true,
              path = 4,
              -- show_filename_only = false,
              -- mode = 4
            },
          }
        },
        -- options = {
        --   theme = 'gruvbox_dark'
        --
        -- }
      }
  },
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
          -- Jumping to context (upwards)
          vim.keymap.set("n", "[c", function()
            require("treesitter-context").go_to_context(vim.v.count1)
          end, { silent = true })
        end,
        opts = {
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
      }
    },
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    -- lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    -- event = { "VeryLazy" },
    -- cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
    -- opts_extend = { "ensure_installed" },
    opts = {
      -- LazyVim config for treesitter
      folds = { enable = true },
      auto_install = true,
      install_dir = vim.fn.stdpath('data') .. '/site',
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    config = function(_, opts)
      require'nvim-treesitter'.install { 'python', 'javascript', 'typescript','tsx', 'json', 'yaml', 'xml', 'lua', 'markdown', 'vim', 'vimdoc', 'diff', 'html' }

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'python', 'lua', 'markdown', 'yaml', 'xml' },
        -- Enable syntax highlight for these languages
        callback = function() vim.treesitter.start() end,
      })
    end,

  },
  {
    -- For auto closing xml, html tags
    "windwp/nvim-ts-autotag",
    opts={
      opts = {
        -- Defaults
        enable_close = true, -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = false -- Auto close on trailing </
      },
    },
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    config = function()
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
    end,
  },
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    dependencies = {
      "epheien/outline-treesitter-provider.nvim",
    },
    keys = {
      {"<leader>sy", "<cmd>Outline<CR>", desc = "Toggle outline"}
    },
    opts = {
      relative_width = true,
      width = 40,
      preview_window = {
        width = 80,
      },
      providers = {
        priority = { 'lsp', 'markdown', 'norg', 'treesitter' },
      },
    },
  },
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit

    -- config = function()
    --   vim.opt.conceallevel = 1
    -- end,
    -- ft = "*",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
      -- event = {
        --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
        --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
        --   -- refer to `:h file-pattern` for more examples
        --   "BufReadPre path/to/my-vault/*.md",
        --   "BufNewFile path/to/my-vault/*.md",
      -- },
      ---@module 'obsidian'
      ---@type obsidian.config

      opts = {
        legacy_commands = false,
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
        }
      },
      keys = {

        -- ,qs: quick switch
        -- map('n', '<leader>qs', ':ObsidianQuickSwitch<CR>', {noremap = true})
        {"<leader>qs", "<cmd>Obsidian quick_switch<CR>", desc = "Open Obsidian Note"},

        -- ,toc: opens table of contents
        -- map('n', '<leader>toc', ':ObsidianTOC<CR>', {noremap = true})
        {"<leader>toc", "<cmd>Obsidian toc<CR>", desc = "Opens table of contents"},

        -- ,sn: search notes
        -- map('n', '<leader>sn', ':ObsidianSearch<CR>', {noremap = true})
        {"<leader>sn", "<cmd>Obsidian search<CR>", desc = "Search notes"},
      },
  },
  {
    "nvim-mini/mini.surround",
    opts = {
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
    },
  }
}
