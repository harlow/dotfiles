""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" JUMP TO LAST KNOWN CURSOR POINT FOR FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrcEx
  au!

  autocmd FileType text setlocal textwidth=78

  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
augroup END
