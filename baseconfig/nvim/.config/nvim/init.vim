" ==== Vanilla configuration ==== "

lua << EOF
require("options")
require("mappings")
EOF

syntax on
filetype on


" Highlight when searching, then set off after search done
augroup vimrc-incsearch-highlight
  autocmd!
  autocmd CmdlineEnter /,\? :set hlsearch
  autocmd CmdlineLeave /,\? :set nohlsearch
augroup END

" Disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" ==== Functions ==== "
" https://vi.stackexchange.com/a/456

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

" ==== Commands ==== "
command! TrimWhitespace call TrimWhitespace()

" ==== Key mappings ==== "
" Use ESC to exit insert mode in :term
tnoremap <Esc> <C-\><C-n>

" To use `ALT+{h,j,k,l}` to navigate windows from any mode: >
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" Trim whitespaces from file
:noremap <Leader>t :call TrimWhitespace()<CR>

" Spell-check set to <leader>o, 'o' for 'orthography':
map <leader>o :setlocal spell! spelllang=en_us<CR>

" Spanish orthography
map <leader>so :setlocal spell! spelllang=es<CR>

" Spanish and dual english orthography
map <leader>do :setlocal spell! spelllang=en_us,es<CR>

:noremap <leader>l :diffget 1<CR>
:noremap <leader>r :diffget 3<CR>

" ==== Vim plug configuration ==== "

" Specify a directory for plugins
call plug#begin(stdpath('data') . '/plugged')

" ==== closetag.vim: Auto close (X)HTML tags ====
Plug 'alvan/vim-closetag'

" ==== Vim-orgmode: Text outlining and task management for Vim based on Emacs' Org-Mode ====
Plug 'jceb/vim-orgmode'

" ==== HTML Template Literals: Syntax highlighting for html template literals in javascript ====
Plug 'jonsmithers/vim-html-template-literals'
Plug 'pangloss/vim-javascript'

" ====  React JSX syntax highlighting for vim and Typescript  ====
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

" ==== Vimtex: a modern Vim and neovim filetype plugin for LaTeX files ====
Plug 'lervag/vimtex'

" ==== emmet for vim ====
Plug 'mattn/emmet-vim'

" ==== Polyglot: A collection of language packs for Vim.
Plug 'sheerun/vim-polyglot'

" Vim syntax highlighting and indentation for Svelte 3 components. 
Plug 'evanleck/vim-svelte', {'branch': 'main'}

" === Comment plugin: A comment toggler for Neovim, written in Lua ===
Plug  'terrortylor/nvim-comment'

" Quickstart configurations for the Nvim LSP client
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" === Snippets plugin ===
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'

" ====  Auto completion Lua plugin for nvim
Plug 'hrsh7th/nvim-cmp'

" ==== LSP source for nvim-cmp
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'simrat39/symbols-outline.nvim'

" ====  Modern theme for modern VIMs  ====
Plug 'ayu-theme/ayu-vim' " or other package manager

Plug 'glench/vim-jinja2-syntax'

" Lua Development for Neovim.
Plug 'tjdevries/nlua.nvim'

" plenary: full; complete; entire; absolute; unqualified.
" All the lua functions I don't want to write twice. 
Plug 'nvim-lua/plenary.nvim'

" Lean & mean status/tabline for vim that's light as air 
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" A vim colorscheme for use with wal
"Plug 'dylanaraps/wal.vim'

" pywal.nvim is a reimplementation of pywal.vim
"Plug 'AlphaTechnolog/pywal.nvim', { 'as': 'pywal' }

"
Plug 'xiyaowong/nvim-transparent', {'as': 'transparent'}

" PlantUML
Plug 'tyru/open-browser.vim'
Plug 'aklt/plantuml-syntax'
Plug 'weirongxu/plantuml-previewer.vim'

" markdown preview plugin for (neo)vim 
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

" The undo history visualizer for VIM 
Plug 'mbbill/undotree'

" surround.vim: Delete/change/add parentheses/quotes/XML-tags/much more with ease 
Plug 'tpope/vim-surround'

" Initialize plugin system
call plug#end()

" Set colorscheme
" colorscheme wal

let ayucolor="dark" " for mirage version of theme
runtime colors/ayu.vim
highlight Normal ctermfg=black ctermbg=black
" let s:fg_comment = "#FFFFFF"

"colorscheme ayu
" ==== closetag.vim: Auto close (X)HTML tags ====


" configure the vim-closetag plugin to work inside html template literals
let g:closetag_filetypes = 'html,xhtml,phtml,javascript,typescript'
let g:closetag_regions = {
      \ 'typescript.tsx': 'jsxRegion,tsxRegion,litHtmlRegion',
      \ 'javascript.jsx': 'jsxRegion,litHtmlRegion',
      \ 'javascript':     'litHtmlRegion',
      \ 'typescript':     'litHtmlRegion',
      \ }

" ==== HTML Template Literals: Syntax highlighting for html template literals in javascript ====

" reasonable indentation of <style>
let g:html_indent_style1 = "inc"

" Enable css syntax inside css-tagged template literals (css`...`).
let g:htl_css_templates = 1

"(Experimental) Enable html syntax inside all template literals (`...`).
let g:htl_all_templates = 1

" ==== Vimtex: a modern Vim and neovim filetype plugin for LaTeX files ====
" vimtex-tex-flavor
let g:tex_flavor = 'latex'

let g:vimtex_view_method = 'zathura'

" vim-airline powerline integration
let g:airline_powerline_fonts = 1
let g:airline_detect_spell=1
let g:airline#extensions#branch#format = 2
" ====  React JSX syntax highlighting for vim and Typescript  ====
" set filetypes as typescriptreact
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescriptreact
"  Highlighting for large files
autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

" ==== LSP config (the mappings used in the default file don't quite work right)

" ==== Vim telescope mappings using Lua functions
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
" Deprecated i don't use this, substituted by lspsymbols
" nnoremap <leader>fs <cmd>lua require('telescope.builtin').git_status()<cr>
nnoremap <leader>fs <cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>

nnoremap <leader>fo <cmd>lua require('telescope.builtin').oldfiles()<cr>


set dictionary+=/usr/share/dict/spanish,/usr/share/dict/words

" ====  Lua config "
lua << EOF
require("init_config")
EOF
