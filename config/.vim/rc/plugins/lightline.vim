let g:lightline = {
\   'colorscheme': 'iceberg',
\   'mode_map': {'c': 'NORMAL'},
\   'active': {
\     'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ],
\    'right': [ [ 'lsp_error', 'linter_errors', 'linter_warnings', 'lineinfo' ],
\               [ 'percent' ],
\               [ 'fileformat', 'fileencoding', 'filetype' ] ]
\   },
\   'component_function': {
\     'modified': 'LightlineModified',
\     'readonly': 'LightlineReadonly',
\     'fugitive': 'LightlineFugitive',
\     'filename': 'LightlineFilename',
\     'fileformat': 'LightlineFileformat',
\     'filetype': 'LightlineFiletype',
\     'fileencoding': 'LightlineFileencoding',
\     'mode': 'LightlineMode',
\   },
\   'component_expand': {
\     'linter_warnings': 'lightline#ale#warnings',
\     'linter_errors': 'lightline#ale#errors',
\     'lsp_error': 'LightlineLSPError'
\   },
\   'component_type': {
\     'linter_warnings': 'warning',
\     'linter_errors': 'error',
\     'lsp_error': 'error'
\   }
\ }

function! LightlineModified()
  return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightlineReadonly()
  return &ft !~? 'help' && &readonly ? 'x' : ''
endfunction

function! LightlineFilename()
  return ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
        \ ('' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction

function! LightlineFugitive()
  if exists('*fugitive#head')
    return fugitive#head()
  else
    return ''
  endif
endfunction

function! LightlineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightlineMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! LightlineLSPError()
  let firstErrLine = lsp#get_buffer_first_error_line()
  return (firstErrLine ? "E: ".lsp#get_buffer_diagnostics_counts()["error"]."(L".firstErrLine.")":"")
endfunction

augroup MyAutoCmd
  autocmd CompleteDone * call lightline#update()
  autocmd CursorHold * call lightline#update()
  autocmd InsertEnter * call lightline#update()
augroup END
