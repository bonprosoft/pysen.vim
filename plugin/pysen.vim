if exists('g:loaded_pysen') || !has('lambda')
  finish
endif
let g:loaded_pysen = 1

call pysen#init()
