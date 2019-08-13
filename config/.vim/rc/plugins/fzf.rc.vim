let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color always --colors path:fg:0xb2,0x94,0xbb --colors line:fg:0x6c,0x7a,0x80 --colors column:fg:0x6c,0x7a,0x80 --smart-case --hidden --glob "!/.git" '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview({'options': '--color dark,hl:#8abeb7,hl+:#8abeb7,prompt:#8abeb7,pointer:#8abeb7 --delimiter : --nth 4..'}, 'up:60%')
  \           : fzf#vim#with_preview({'options': '--color dark,hl:#8abeb7,hl+:#8abeb7,prompt:#8abeb7,pointer:#8abeb7 --delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
  \   <bang>0)

let g:fzf_layout = { 'window': 'call FloatingFZF()' }

function! FloatingFZF()
  let buf = nvim_create_buf(v:false, v:true)
  call setbufvar(buf, '&signcolumn', 'no')

  let height = float2nr(&lines * 0.6)
  let width = float2nr(&columns - (&columns * 2 / 10))
  let row = float2nr(&lines * 0.2)
  let col = float2nr((&columns - width) / 2)

  let opts = {
        \ 'relative': 'editor',
        \ 'row': row,
        \ 'col': col,
        \ 'width': width,
        \ 'height': height
        \ }

  call nvim_open_win(buf, v:true, opts)
endfunction
