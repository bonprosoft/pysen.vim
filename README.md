# pysen.vim

A vim plugin for [pysen-ls](https://github.com/bonprosoft/pysen-ls)

## Installation

- Plug
```viml
Plug 'prabirshrestha/vim-lsp'
Plug 'bonprosoft/pysen.vim'
```

Note that you also need to install [pysen-ls >= 0.1.0](https://github.com/bonprosoft/pysen-ls) in your python environment.

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

## FAQ

### How can I work with other linter plugins?

You may need to disable some linter plugins (e.g. flake8, mypy, isort, black) as they don't read `pysen` configuration.

The recommended way is to disable conflicting linter plugins.
For example, ALE users can specify a list of linters to use for each language.
```vim
let g:ale_linters = {
\   'python': [],
\}
```

You can also setup your editor's linter plugins with pysen compatible settings by configuring pysen to export configuration files.
See [`Settings file directory` section in pysen's README](https://github.com/pfnet/pysen#how-it-works-settings-file-directory).
