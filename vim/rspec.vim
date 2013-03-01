map <Leader>a :call RunAllSpecs()<CR>
map <Leader>t :call RunCurrentSpec()<CR>
map <Leader>l :call RunNearestSpec()<CR>
map <Leader>r :call RunLastSpec()<CR>

function! RunAllSpecs()
  let l:command = "rspec"
  call SetLastSpecCommand(l:command)
  call RunSpecs(l:command)
endfunction

function! RunCurrentSpec()
  if InSpecFile()
    let l:command = "rspec " . @% . " -f documentation"
    call SetLastSpecCommand(l:command)
    call RunSpecs(l:command)
  endif
endfunction

function! RunNearestSpec()
  if InSpecFile()
    let l:command = "rspec " . @% . " -l " . line(".") . " -f documentation"
    call SetLastSpecCommand(l:command)
    call RunSpecs(l:command)
  endif
endfunction

function! RunLastSpec()
  if exists("t:last_spec_command")
    call RunSpecs(t:last_spec_command)
  endif
endfunction

function! InSpecFile()
  return match(expand("%"), "_spec.rb$") != -1
endfunction

function! SetLastSpecCommand(command)
  let t:last_spec_command = a:command
endfunction

function! RunSpecs(command)
  execute ":w\|!clear && echo " . a:command . " && echo && " . a:command
endfunction
