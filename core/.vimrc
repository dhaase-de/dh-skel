" use bash as shell
set shell=/bin/bash

" use 4 spaces instead of tabs
set expandtab
set shiftwidth=4
set softtabstop=4

" show tabs
set list
set listchars=tab:>-

" use <Shift-Tab> to insert real tab
inoremap <S-Tab> <C-V><Tab>

" turn on autoindent
set autoindent

" can be used to turn off autoindent when pasting
set pastetoggle=<F3>

" show line numbers
set number

" highlight results of search
set hlsearch

" ignore case for searches
set ignorecase

" show information about the current command
set showcmd

" allow mouse in normal, visual and insert mode
set mouse=nvi

" keep 10 lines below and above the cursor
set scrolloff=10

" color scheme
syntax on
colorscheme evening 
