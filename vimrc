""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VUNDLE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if filereadable($HOME . "/.dotfiles/vim/vundle.vim")
  source ~/.dotfiles/vim/vundle.vim
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" IMPORT FUNCTIONS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
for fpath in split(globpath('~/.dotfiles/vim/functions', '*.vim'), '\n')
  exe 'source' fpath
endfor

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SET LEADER KEY TO SPACEBAR
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader=" "

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COLOR SCHEME
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable
colorscheme railscasts
set guifont=Monaco:h15
set background=dark

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SETTINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set backspace=indent,eol,start
set colorcolumn=81
set expandtab
set hidden
set history=50
set hls
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set list listchars=tab:»·,trail:·
set nobackup
set nocompatible  " Use Vim settings, rather then Vi settings
set noswapfile
set nowritebackup
set number
set numberwidth=5
set ruler         " show the cursor position all the time
set shiftwidth=2
set showcmd       " display incomplete commands
set splitbelow
set splitright
set tabstop=2
set vb

" Silver searcher
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" jump to previous file
nnoremap <leader><leader> <c-^>

" Markdown files end in .md
au BufRead,BufNewFile *.md set filetype=markdown

" Spell check for .md files
au BufRead,BufNewFile *.md setlocal spell

" Automatically wrap at 80 characters for Markdown
au BufRead,BufNewFile *.md setlocal textwidth=80

" Remove trailing whitespace on save for ruby files
au BufWritePre *.* :%s/\s\+$//e

" Tags
let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Go to file in new tab
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GET OFF MY LAWN
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SPLIT SCREEN NAVIGATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <C-J> <C-W><C-J>
nmap <C-K> <C-W><C-K>
nmap <C-H> <C-W><C-H>
nmap <C-L> <C-W><C-L>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ADDITIONAL NAVIGATION SHORTCUTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd User Rails Rnavcommand config config -glob=**/* -default=routes
autocmd User Rails Rnavcommand policy app/policies -glob=**/* -suffix=_policy.rb
autocmd User Rails Rnavcommand service app/services -glob=**/*
autocmd User Rails Rnavcommand presenter app/presenters -glob=**/*
autocmd User Rails Rnavcommand decorator app/decorators -glob=**/* -suffix=_decorator.rb -default=model()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ACK SEARCH
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if executable("ack")
  set grepprg=ack\ -H\ --nogroup\ --nocolor
endif
