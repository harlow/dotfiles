set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'kchmck/vim-coffee-script'
Bundle 'pangloss/vim-javascript'
Bundle 'tpope/vim-markdown'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-cucumber'
Bundle 'tpope/vim-surround'
Bundle 'tsaleh/vim-matchit'
Bundle 'vim-scripts/tComment'
Bundle 'mileszs/ack.vim'
Bundle 'ervandew/supertab'
Bundle 'altercation/vim-colors-solarized'
Bundle 'jnwhiteh/vim-golang'
Bundle 'avakhov/vim-yaml'
Bundle 'kien/ctrlp.vim'
Bundle 'tpope/vim-bundler'
Bundle 'skwp/vim-rspec'

" Bundle 'vim-ruby/vim-ruby'
" Bundle 'scrooloose/nerdtree'
" Bundle 'tpope/vim-fugitive'

Bundle 'IndexedSearch'

syntax on
filetype plugin indent on
