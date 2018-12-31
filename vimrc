" vundle
if filereadable($HOME . "/.vimrc.bundles")
  source ~/.vimrc.bundles
endif

" set leader to spacebar
let mapleader=" "

" import all functions
for fpath in split(globpath('~/.vim/functions', '*.vim'), '\n')
  exec 'source' fpath
endfor

" colors
syntax enable
set background=dark
let g:solarized_termtrans = 1
colorscheme solarized

" general settings
set autoindent
set backspace=indent,eol,start
set bs=2
set colorcolumn=81
set complete-=i    " don't look in included files when autocompleting
set expandtab
set guifont=Menlo:h16
set hidden
set history=50
set hlsearch
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set nobackup
set nocompatible  " Use Vim settings, rather then Vi settings
set noswapfile
set nowritebackup
set number
set numberwidth=5
set ruler         " show the cursor position all the time
set shiftwidth=2
set shortmess=I
set showcmd       " display incomplete commands
set splitbelow
set splitright
set tabstop=2

" Silver searcher
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" jump to previous file
nnoremap <leader><leader> <c-^>

" highlight tabs and trailing space in Ruby
au BufNewFile,BufRead *.rb set list listchars=tab:»·,trail:·

" Markdown options
au BufRead,BufNewFile *.md set filetype=markdown
au BufRead,BufNewFile *.md setlocal spell
au BufRead,BufNewFile *.md setlocal textwidth=80

" Remove trailing whitespace on save
au BufWritePre *.* :%s/\s\+$//e

" Golang tabs and vim-go settings
au BufNewFile,BufRead *.go setlocal noet ts=4 sw=4 sts=4
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)

" Ctags
let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Go to file in vertical split
map <C-\> :vs<CR>:exec("tag ".expand("<cword>"))<CR>

" Set rules for git commit files
autocmd Filetype gitcommit setlocal spell textwidth=72

" CtrlP ignore files
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

" spec runners
nmap <silent> <leader>s :TestNearest<CR>
nmap <silent> <leader>t :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>

" tab completion
set wildmode=list:longest,list:full
" set complete=.,w,t
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>

" GET OFF MY LAWN
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" split screen nav
nmap <C-J> <C-W><C-J>
nmap <C-K> <C-W><C-K>
nmap <C-H> <C-W><C-H>
nmap <C-L> <C-W><C-L>

" search
if executable("ack")
  set grepprg=ack\ -H\ --nogroup\ --nocolor
endif

" friendly paste
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

" go linter
set rtp+=$GOPATH/src/github.com/golang/lint/misc/vim
