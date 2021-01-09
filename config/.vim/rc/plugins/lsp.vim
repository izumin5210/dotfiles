if empty(globpath(&rtp, 'autoload/lsp.vim'))
  finish
endif

"  asynccomplete.vim
"--------------------------------
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 0
let g:asyncomplete_popup_delay = 200

"  vim-lsp
"--------------------------------
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> <C-]> <plug>(lsp-definition)
  nmap <buffer> <f2> <plug>(lsp-rename)
  nmap <buffer> <Leader>d <plug>(lsp-type-definition)
  nmap <buffer> <Leader>r <plug>(lsp-references)
  nmap <buffer> <Leader>i <plug>(lsp-implementation)
  inoremap <expr> <cr> pumvisible() ? "\<c-y>\<cr>" : "\<cr>"
endfunction

augroup lsp_install
  au!
  " call s:on_lsp_buffer_enabled only for languages that has the server registered.
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:asyncomplete_popup_delay = 200
let g:lsp_text_edit_enabled = 1
let g:lsp_preview_float = 1
let g:lsp_diagnostics_float_cursor = 1
let g:lsp_settings_filetype_go = ['gopls', 'golangci-lint-langserver']

"  vim-lsp-settings
"--------------------------------

let g:lsp_settings = {}
let g:lsp_settings['gopls'] = {
  \  'workspace_config': {
  \    'usePlaceholders': v:true,
  \    'semanticTokens': v:true,
  \    'gofumpt': v:true,
  \    'experimentalWorkspaceModule': v:true,
  \    'codelens': {
  \      'test': v:true,
  \    },
  \  },
  \  'initialization_options': {
  \    'usePlaceholders': v:true,
  \    'semanticTokens': v:true,
  \    'gofumpt': v:true,
  \    'experimentalWorkspaceModule': v:true,
  \    'codelens': {
  \      'test': v:true,
  \    },
  \  },
  \}

let g:lsp_settings['golangci-lint-langserver'] = {
  \  'initialization_options': {
  \    'command': ['golangci-lint', 'run',
  \        '--enable-all',
  \        '--fast',
  \        '--disable', 'lll',
  \        '--disable', 'wsl',
  \        '--disable', 'gochecknoglobals',
  \        '--disable', 'gci',
  \        '--disable', 'gofumpt',
  \        '--out-format', 'json',
  \        '--max-issues-per-linter', '0',
  \        '--max-same-issues', '0',
  \    ],
  \  },
  \}
