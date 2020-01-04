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
  nmap <buffer> <f2> <plug>(lsp-rename)
  " refer to doc to add more commands
endfunction

augroup lsp_install
  au!
  " call s:on_lsp_buffer_enabled only for languages that has the server registered.
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_signs_enabled = 1
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_text_edit_enabled = 1

"  vim-lsp-settings
"--------------------------------
let g:lsp_settings = {
      \  'gopls': {'workspace_config': {
      \     'staticcheck': v:true,
      \     'completeUnimported': v:true,
      \     'caseSensitiveCompletion': v:true,
      \     'usePlaceholders': v:true,
      \     'completionDocumentation': v:true,
      \     'watchFileChanges': v:true,
      \     'hoverKind': 'SingleLine',
      \  }}
      \}
