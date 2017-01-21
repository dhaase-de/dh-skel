" use bash as shell
set shell=/bin/bash

" use 4 spaces instead of tabs
set expandtab
set shiftwidth=4
set softtabstop=4

" turn on autoindent
set autoindent

" show tabs
set list
set listchars=tab:>-

" show line numbers
set number

" allow mouse in normal, visual and insert mode
set mouse=nvi

" highlight results of search
set hlsearch

" ignore case for searches
set ignorecase

" show information about the current command
set showcmd

" CTRL-m will run a make command
map <c-m> :! make<cr>

" color scheme
colorscheme delek
