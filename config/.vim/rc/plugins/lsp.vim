if empty(globpath(&rtp, 'autoload/lsp.vim'))
  finish
endif

"  asynccomplete.vim
"--------------------------------
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 0
let g:asyncomplete_popup_delay = 200

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

set completeopt=menuone,noinsert,noselect,preview

"  vim-lsp
"--------------------------------
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gs <plug>(lsp-document-symbol-search)
  nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> gt <plug>(lsp-type-definition)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> [g <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <plug>(lsp-next-diagnostic)
  nmap <buffer> K <plug>(lsp-hover)
  nnoremap <buffer> <expr><c-j> lsp#scroll(+4)
  nnoremap <buffer> <expr><c-k> lsp#scroll(-4)

  let g:lsp_format_sync_timeout = 1000
  autocmd BufWritePre *.go call execute(['LspCodeActionSync source.organizeImports', 'LspDocumentFormatSync'])
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
  \    'gofumpt': v:true,
  \    'experimentalWorkspaceModule': v:true,
  \  },
  \  'initialization_options': {
  \    'usePlaceholders': v:true,
  \    'gofumpt': v:true,
  \    'experimentalWorkspaceModule': v:true,
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
