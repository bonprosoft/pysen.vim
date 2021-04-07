# pysen.vim

A vim plugin for [pysen-ls](https://github.com/bonprosoft/pysen-ls)

## Installation

- Plug
```viml
Plug 'prabirshrestha/vim-lsp'
Plug 'bonprosoft/pysen.vim'
```

## Commands

Use the commands `vim-lsp` provides to invoke the standard language server feature.
For example:
```vim
:LspDocumentDiagnostics  " show diagnostics
:LspDocumentFormat  " apply formatter
:LspCodeAction  " show code action
```

`pysen-ls` provides some extra commands to trigger formatter/linter.

```vim
" to invoke `pysen.callLintDocument`
:PysenLintDocument
:PysenLintDocument <path>

" to invoke `pysen.callFormatDocument`
:PysenFormatDocument
:PysenFormatDocument <path>

" to invoke `pysen.callLintWorkspace`
:PysenLintWorkspace

" to invoke `pysen.callFormatWorkspace`
:PysenFormatWorkspace
```

Note that those commands will be available only if the `pysen-ls` is activated to the current buffer.

## Configuration

- (Default) Use stdio to connect to `pysen-ls`
```vim
let g:pysen_connection_mode = 'io'
let g:pysen_python_path = 'python3'
```

- Use tcp to connect to `pysen-ls`
```vim
let g:pysen_connection_mode = 'tcp'
let g:pysen_tcp_addr = '127.0.0.1:3746'
```

- Configure `pysen-ls` settings
```vim
let g:pysen_language_server_config = {
  \ 'enableLintOnSave': v:true,
  \ 'enableCodeAction': v:true,
  \ 'lintTargets': ['lint'],
  \ 'formatTargets': ['format', 'lint'],
  \ }
```
