let g:lightline = {
    \ 'colorscheme': 'wombat',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'fugitive', 'filename' ] ]
    \ },
    \ 'component_function': {
    \   'fugitive': 'LightlineFugitive',
    \   'readonly': 'LightlineReadonly',
    \   'modified': 'LightlineModified',
    \   'filename': 'LightlineFilename'
    \ },
    \ 'separator': { 'left': '⮀', 'right': '⮂' },
    \ 'subseparator': { 'left': '⮁', 'right': '⮃' }
    \ }

function! LightlineModified()
if &filetype == "help"
    return ""
elseif &modified
    return "+"
elseif &modifiable
    return ""
else
    return ""
endif
endfunction

function! LightlineReadonly()
if &filetype == "help"
    return ""
elseif &readonly
    return "⭤"
else
    return ""
endif
endfunction

function! LightlineFugitive()
return exists('*fugitive#head') ? fugitive#head() : ''
endfunction

function! LightlineFilename()
return ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
    \ ('' != expand('%:t') ? expand('%:t') : '[No Name]') .
    \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction
