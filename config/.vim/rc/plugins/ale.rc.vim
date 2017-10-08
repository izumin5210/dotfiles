let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1
let g:ale_sign_column_always = 0
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1

let g:ale_sign_error = '⤫'
let g:ale_sign_warning = '⚠'

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

let g:airline#extensions#ale#enabled = 1

" Golang
" ================================================================
let g:ale_linters = {
\   'go': ['gometalinter'],
\}

let g:ale_go_gometalinter_options = '
\   --vendored-linters --disable-all --tests
\   --enable=vet
\   --enable=gotype
\   --enable=golint
\ '
