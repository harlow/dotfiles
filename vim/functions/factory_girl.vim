""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OPEN FACTORIES IN A SPLIT
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! OpenFactoryFile()
  execute ":vs spec/factories.rb"
endfunction

map <Leader>f :call OpenFactoryFile()<CR>
