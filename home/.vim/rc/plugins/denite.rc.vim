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

nnoremap <silent> <Leader><Leader> :<C-u>Denite file_rec<CR>
nnoremap <silent> <Leader>g :<C-u>Denite grep<CR>

if isdirectory(".git")
  call denite#custom#var('file_rec', 'command',
      \   ['git', 'ls-files', '--cached', '--others', '--exclude-standard']
      \ )
  call denite#custom#var('grep', 'command', ['git', '--no-pager', 'grep'])
  call denite#custom#var('grep', 'default_opts',
      \   ['--ignore-case', '--cached', '--untracked', '--exclude-standard', '-nH']
      \ )
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', ['--extended-regexp'])
  call denite#custom#var('grep', 'separator', [])
  call denite#custom#var('grep', 'final_opts', [])
else
  call denite#custom#var('file_rec', 'command',
      \   ['rg', '--follow', '--no-heading', '--hidden', '--glob', '!.git']
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
