" Settings
set nocompatible  " Use Vim settings, rather then Vi settings
set nobackup
set nowritebackup
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set splitright
set splitbelow
set hls
set incsearch

" Pathogen
call pathogen#infect()
syntax on
filetype plugin indent on

augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
augroup END

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab

" Display extra whitespace
set list listchars=tab:»·,trail:·

" Local config
if filereadable(".vimrc.local")
  source .vimrc.local
endif

" <Space> is the leader character
let mapleader = " "

" Use Ack instead of Grep when available
if executable("ack")
  set grepprg=ack\ -H\ --nogroup\ --nocolor
endif

" Color scheme
syntax enable
set background=dark
colorscheme solarized

highlight NonText guibg=#060606
highlight Folded  guibg=#0A0A0A guifg=#9090D0

" Numbers
set number
set numberwidth=5

" Snippets are activated by Shift+Tab
let g:snippetsEmu_key = "<S-Tab>"

" Tab completion options
set wildmode=list:longest,list:full
set complete=.,w,t

" Tags
let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"

" Cucumber navigation commands
autocmd User Rails Rnavcommand step features/step_definitions -glob=**/* -suffix=_steps.rb
autocmd User Rails Rnavcommand config config -glob=**/* -suffix=.rb -default=routes

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Window navigation
nmap <C-J> <C-W><C-J>
nmap <C-K> <C-W><C-K>

" Rails configuration
autocmd User Rails Rnavcommand step features/step_definitions -glob=**/* -suffix=_steps.rb
autocmd User Rails Rnavcommand config config -glob=**/* -suffix=.rb -default=routes
autocmd User Rails map <Leader>p :Rstep 
autocmd User Rails map <Leader>sp :RSstep 
autocmd User Rails map <Leader>tp :RTstep 
autocmd User Rails map <Leader>m :Rmodel 
autocmd User Rails map <Leader>c :Rcontroller 
autocmd User Rails map <Leader>v :Rview 
autocmd User Rails map <Leader>u :Runittest 
autocmd User Rails map <Leader>f :Rfunctionaltest 
autocmd User Rails map <Leader>i :Rintegrationtest 
autocmd User Rails map <Leader>h :Rhelper 

autocmd User Rails map <Leader>tm :RTmodel 
autocmd User Rails map <Leader>tc :RTcontroller 
autocmd User Rails map <Leader>tv :RTview 
autocmd User Rails map <Leader>tu :RTunittest 
autocmd User Rails map <Leader>tf :RTfunctionaltest 
autocmd User Rails map <Leader>ti :RTintegrationtest 

autocmd User Rails map <Leader>sm :RSmodel 
autocmd User Rails map <Leader>sc :RScontroller 
autocmd User Rails map <Leader>sv :RSview 
autocmd User Rails map <Leader>su :RSunittest 
autocmd User Rails map <Leader>sf :RSfunctionaltest 
autocmd User Rails map <Leader>si :RSintegrationtest 

autocmd User Rails map <Leader>mm :RVmodel 
autocmd User Rails map <Leader>cc :RVcontroller 
autocmd User Rails map <Leader>vv :RVview 
autocmd User Rails map <Leader>uu :RVunittest 
autocmd User Rails map <Leader>ff :RVfunctionaltest 
autocmd User Rails map <Leader>ii :RVintegrationtest

autocmd User Rails map <Leader>g :Rconfig 
autocmd User Rails map <Leader>sg :RSconfig 
autocmd User Rails map <Leader>tg :RTconfig

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>