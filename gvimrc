set vb
set guioptions+=c
set guioptions-=T " Removes top toolbar
set guioptions-=r " Removes right hand scroll bar
set go-=L         " Removes left hand scroll bar

if filereadable($HOME . "/.vimrc")
  source ~/.vimrc
endif
