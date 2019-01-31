call denite#custom#map(
    \   'insert',
    \   '<C-j>',
    \   '<denite:move_to_next_line>',
    \   'noremap'
    \ )
call denite#custom#map(
    \   'insert',
    \   '<C-k>',
    \   '<denite:move_to_previous_line>',
    \   'noremap'
    \ )

if executable('rg')
  call denite#custom#var('file/rec', 'command',
      \   ['rg', '--files', '--hidden', '--follow', '--glob', '!.git']
      \ )
  call denite#custom#var('grep', 'command', ['rg'])
  call denite#custom#var('grep', 'default_opts',
      \   ['--vimgrep', '--no-heading']
      \ )
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
endif

if isdirectory('.git')
  call denite#custom#var('file/rec', 'command',
    \   ['git', 'ls-files', '--cached', '--others', '--exclude-standard']
    \ )
endif
