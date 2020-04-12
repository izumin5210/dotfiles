let g:memolist_path = $HOME . "/memo"
let g:memolist_memo_suffix = "md"
let g:memolist_template_dir_path = $HOME . "/.config/memo/templates"
let g:memolist_fzf = 1

nnoremap <Leader>mn  :MemoNew<CR>
nnoremap <Leader>ml  :MemoList<CR>
nnoremap <Leader>mg  :MemoGrep<CR>
