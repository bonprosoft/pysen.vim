function! s:get_tcp_server_config(addr) abort
  return {
    \ 'tcp': {server_info->a:addr},
    \ }
endfunction

function! s:get_io_server_config(python_path) abort
  return {
    \ 'cmd': {server_info->[a:python_path, '-m', 'pysen_ls', '--io']},
    \ }
endfunction

function! s:get_server_name() abort
  return 'pysen'
endfunction

function! s:get_document_uri(path) abort
  if empty(a:path)
    return lsp#get_text_document_identifier(bufnr('%'))['uri']
  else
    let l:abs_path = fnamemodify(a:path, ":p")
    return lsp#utils#path_to_uri(l:abs_path)
  endif
endfunction

function! s:on_lsp_buffer_enabled()  abort
  command! -nargs=? PysenLintDocument call pysen#lint_document(<f-args>)
  command! -nargs=? PysenFormatDocument call pysen#format_document(<f-args>)
  command! PysenLintWorkspace call pysen#lint_workspace()
  command! PysenFormatWorkspace call pysen#format_workspace()
endfunction

function! s:ensure_buffer_nomodified(...) abort
  let l:buffer = get(a:, 1, bufnr('%'))
  let l:modified = getbufvar(l:buffer, '&modified')
  if l:modified
    echohl ErrorMsg
    echo 'Buffer is modified. Please save it before running the command'
    echohl None
    return v:false
  endif
  return v:true
endfunction

function! pysen#get_server_config() abort
  let l:server_config = get(g:, 'pysen_language_server_config', v:null)
  let l:base = {
    \ 'name': s:get_server_name(),
    \ 'allowlist': ['python'],
    \ 'languageId': {server_info->'python'},
    \ 'workspace_config': {'config': l:server_config},
    \ }
  let l:connection_mode = get(g:, 'pysen_connection_mode', 'stdio')

  if l:connection_mode ==? 'tcp'
    let l:addr = get(g:, 'pysen_tcp_addr', '127.0.0.1:3746')
    return extend(s:get_tcp_server_config(l:addr), l:base)
  elseif l:connection_mode ==? 'stdio'
    let l:python_path = get(g:, 'pysen_python_path', 'python3')
    if !executable(l:python_path)
      throw 'Python path: ' . l:python_path . ' not found!'
    endif
    return extend(s:get_io_server_config(l:python_path), l:base)
  else
    throw 'Unknown connection_mode: ' . l:connection_mode
  endif
endfunction

function! pysen#lint_document(...) abort
  if !s:ensure_buffer_nomodified()
    return
  endif

  let l:target_uri = s:get_document_uri(get(a:, 1, ''))
  call lsp#ui#vim#execute_command#_execute({
    \ 'command_name': 'pysen.callLintDocument',
    \ 'command_args': [l:target_uri],
    \ 'server_name': s:get_server_name(),
    \ })
  " TODO: Show diagnostic window automatically
endfunction

function! pysen#format_document(...) abort
  if !s:ensure_buffer_nomodified()
    return
  endif

  let l:target_uri = s:get_document_uri(get(a:, 1, ''))
  call lsp#ui#vim#execute_command#_execute({
    \ 'command_name': 'pysen.callFormatDocument',
    \ 'command_args': [l:target_uri],
    \ 'server_name': s:get_server_name(),
    \ 'sync': v:true,
    \ })
  " TODO: Wait the execution asynchronously
  " See the implementation to know how to register the callback
  " https://github.com/prabirshrestha/vim-lsp/blob/bba0f45c892b3c815c65ce44f93bcbe118a40377/autoload/lsp/ui/vim/execute_command.vim#L45-L54
  echo "Format completed"
  edit
endfunction

function! pysen#lint_workspace() abort
  if !s:ensure_buffer_nomodified()
    return
  endif

  call lsp#ui#vim#execute_command#_execute({
    \ 'command_name': 'pysen.callLintWorkspace',
    \ 'command_args': [],
    \ 'server_name': s:get_server_name(),
    \ })
  " TODO: Show diagnostic window automatically
endfunction

function! pysen#format_workspace() abort
  if !s:ensure_buffer_nomodified()
    return
  endif

  call lsp#ui#vim#execute_command#_execute({
    \ 'command_name': 'pysen.callFormatWorkspace',
    \ 'command_args': [],
    \ 'server_name': s:get_server_name(),
    \ 'sync': v:true,
    \ })
  " TODO: Wait the execution asynchronously
  echo "Format completed"
  edit
endfunction

function! pysen#init() abort
  au User lsp_setup call lsp#register_server(pysen#get_server_config())
  au User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
endfunction
