-- vim: ts=2 sts=2 sw=2 et
return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },

    config = function()

      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
        defaults = {
          file_ignore_patterns = {"node_modules", ".git"},
          wrap_results = true,
          path_display = {"smart"},
          dynamic_preview_title = true,
          layout_config = {
            vertical = { height = 1, width = 1 }
            -- other layout configuration here
          },
        },
        pickers = {
          find_files = {
            theme = "ivy",
            -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          },
          live_grep = {
            theme = "ivy",
          },
          buffers = {
            theme = "ivy",
          },
          help_tags = {
            theme = "ivy",
          },
          oldfiles = {
            theme = "ivy",
          },
        },
      }

      -- Enable Telescope extensions if they are installed
        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'ui-select')

        -- See `:help telescope.builtin`
        local builtin = require 'telescope.builtin'

        -- Slightly advanced example of overriding default behavior and theme
        vim.keymap.set('n', '<leader>/', function()
          -- You can pass additional configuration to Telescope to change the theme, layout, etc.
          builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
              winblend = 10,
              previewer = false,
            })
        end, { desc = '[/] Fuzzily search in current buffer' })

        -- It's also possible to pass additional configuration options.
        --  See `:help telescope.builtin.live_grep()` for information about particular keys
        vim.keymap.set('n', '<leader>s/', function()
          builtin.live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
          }
        end, { desc = '[S]earch [/] in Open Files' })

        vim.api.nvim_create_user_command('GrepOdoo', function(opts)
          builtin.live_grep({
              search_dirs = {"/home/diego/repos/ladonsoft/odoo18/odoo"},
              glob_pattern = { "!*.po", "!*.pot" },
          })
        end, {desc = "Search Odoo Files"})
    end,
    -- https://github.com/LazyVim/LazyVim/blob/b4606f9df3395a261bb6a09acc837993da5d8bfc/lua/lazyvim/plugins/extras/editor/telescope.lua#L4
    keys = {
      {
        "<leader>ff",
        function()
          require('telescope.builtin').find_files({hidden = true})
        end,
      },
      {
        "<leader>fg",
	"<cmd>Telescope live_grep<cr>", 
	desc="Live grep"
      },
      {
        "<leader>fb",
        "<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>",
        desc = "Buffers",
      },
      -- Similar to vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
      { "<leader>fm", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
      { "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
      {
        "<leader>fs",
        "<cmd>Telescope lsp_document_symbols<cr>",
        desc = "Goto Symbol",
      },
      {
        "<leader>cfo",
        function()
          require('telescope.builtin').oldfiles({cwd = vim.fn.getcwd()})
        end,
        desc = "Search oldfiles that were opened in the current working directory"
      }
    }
  },
}
