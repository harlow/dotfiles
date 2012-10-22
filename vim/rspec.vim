function! SendToTerminal(args)
  execute ":silent !run_command '" . a:args . "'"
endfunction

function! ClearTerminal()
  call SendToTerminal("clear")
endfunction

function! RSpec()
  call ClearTerminal()
  if exists("s:current_test")
    call SendToTerminal("zeus rspec -fd " . s:current_test)
  endif
endfunction

function! RunAllTests()
  let s:current_test = ''
  call RSpec()
endfunction

function! RunCurrentTest()
  let s:current_test = expand('%:p')
  call RSpec()
endfunction

function! RunCurrentLineInTest()
  let s:current_test = expand('%:p') . ":" . line('.')
  call RSpec()
endfunction

function! RunLastCommand()
  call RSpec()
endfunction

nmap <Leader>a :call RunAllTests()<CR>
nmap <Leader>t :call RunCurrentTest()<CR>
nmap <Leader>l :call RunCurrentLineInTest()<CR>
nmap <Leader>r :call RunLastCommand()<CR>
