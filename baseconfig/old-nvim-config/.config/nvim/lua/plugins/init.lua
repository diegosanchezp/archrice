return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Portable package manager for Neovim
  use { "williamboman/mason.nvim" }

  -- parser generator tool and an incremental parsing library
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

end)
