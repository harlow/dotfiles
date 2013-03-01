set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'kchmck/vim-coffee-script'
Bundle 'pangloss/vim-javascript'
Bundle 'tpope/vim-markdown'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-surround'
Bundle 'tsaleh/vim-matchit'
Bundle 'vim-scripts/tComment'
Bundle 'mileszs/ack.vim'
Bundle 'altercation/vim-colors-solarized'
Bundle 'ervandew/supertab'

" Bundle 'tsaleh/vim-shoulda'
" Bundle 'vim-ruby/vim-ruby'
" Bundle 'scrooloose/nerdtree'
" Bundle 'tpope/vim-vividchalk'
" Bundle 'tpope/vim-bundler'
" Bundle 'tpope/vim-fugitive'
" Bundle 'tpope/vim-git'

Bundle 'IndexedSearch'

syntax on
filetype plugin indent on
