set vb
set guioptions-=T
set guioptions+=c

if filereadable($HOME . "/.vimrc")
  source ~/.vimrc
endif
