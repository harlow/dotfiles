""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VUNDLE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if filereadable($HOME . "/.dotfiles/vim/vundle.vim")
  source ~/.dotfiles/vim/vundle.vim
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SET LEADER KEY TO SPACEBAR
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader=" "

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" IMPORT FUNCTIONS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
for fpath in split(globpath('~/.dotfiles/vim/functions', '*.vim'), '\n')
  exec 'source' fpath
endfor

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COLOR SCHEME
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable
color codeschool
set guifont=Monaco:h15
set background=dark

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SETTINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set autoindent
set backspace=indent,eol,start
set bs=2
set colorcolumn=81
set complete-=i " don't look in included files when autocompleting
set expandtab
set hidden
set history=50
set hlsearch
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
set wildmode=longest,list
set tabstop=2
set vb

" Silver searcher
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" jump to previous file
nnoremap <leader><leader> <c-^>

" Markdown options
au BufRead,BufNewFile *.md set filetype=markdown
au BufRead,BufNewFile *.md setlocal spell
au BufRead,BufNewFile *.md setlocal textwidth=80

" Remove trailing whitespace on save for ruby files
au BufWritePre *.* :%s/\s\+$//e

" Tags
let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Go to file in new tab
map <C-\> :vs<CR>:exec("tag ".expand("<cword>"))<CR>

" Set rules for git commit files
autocmd Filetype gitcommit setlocal spell textwidth=72

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
" ACK SEARCH
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if executable("ack")
  set grepprg=ack\ -H\ --nogroup\ --nocolor
endif
