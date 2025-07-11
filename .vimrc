" --- Basics ---
set nocompatible
syntax on
set number
set relativenumber
set mouse=a
set clipboard=unnamedplus

" --- Indentation ---
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set autoindent

" --- Searching ---
set ignorecase
set smartcase
set incsearch
set hlsearch

" --- UI ---
set cursorline
set scrolloff=8
set signcolumn=yes
set showcmd

" --- File handling ---
set hidden
set undofile

" --- Code Folding ---
set foldmethod=syntax
set foldlevelstart=99
set foldenable

" --- Mappings ---
nnoremap <SPACE> :noh<CR>
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>i
nnoremap <C-q> :q<CR>
nnoremap <C-a> ggVG         " Ctrl+A to select all
