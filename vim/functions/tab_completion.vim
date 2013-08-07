""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TAB COMPLETION OPTIONS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin on
set complete=.,w,t
set completeopt=longest,menuone
set ofu=syntaxcomplete#Complete
set wildmode=list:longest,list:full
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? "<C-n>" : '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <M-,> pumvisible() ? "<C-n>" : '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
