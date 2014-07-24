if has('vim_starting')
   set nocompatible
   set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))

NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'tpope/vim-endwise'
NeoBundle 'osyo-manga/vim-over'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'vim-scripts/TaskList.vim'
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'tpope/vim-surround'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimproc.vim', {
      \ 'build' : {
      \     'windows' : 'tools\\update-dll-mingw',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
NeoBundle 'basyura/unite-rails'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'AndrewRadev/switch.vim'
NeoBundle 'vim-scripts/ruby-matchit'
NeoBundle 'tpope/vim-rails'
NeoBundle "sudar/vim-arduino-syntax"
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'git://git.code.sf.net/p/vim-latex/vim-latex'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'mattn/webapi-vim'
NeoBundle 'tyru/open-browser.vim'
NeoBundle 'superbrothers/vim-quickrun-markdown-gfm'
NeoBundle 'tpope/vim-markdown'

set fileencodings=utf-8,cp932,euc-jp,iso-2022-jp
set fenc=utf-8
set encoding=utf-8

filetype plugin indent on

"================================================================
" search
"================================================================

" 検索時に大文字小文字の区別しない
set ignorecase
" 大文字小文字がどちらも含まれている場合は区別
set smartcase

" インクリメンタルサーチON
set incsearch

" 検索結果のハイライト
set hlsearch

" ファイル末尾まで検索したら先頭に戻る
set wrapscan

" Esc連打でハイライトを消す
nmap <Esc><Esc> :nohlsearch<CR><Esc>

"================================================================
" appearance
"================================================================

syntax on
set guifont=Ricty:h12
set t_Co=256
colorscheme hybrid

" 行番号を表示
set number

" カーソル位置表示
set ruler

" 折り返し禁止
set nowrap

" 対応するカッコをハイライト
set showmatch
" カッコをハイライトする時間(sec)
set matchtime=3
" <hoge></hoge>みたいなのも%で移動できる
set matchpairs+=<:>
" matchitを有効化（rubyのコードブロックに対応させる）
if !exists('loaded_matchit')
  " matchitを有効化
  runtime macros/matchit.vim
endif

" 行を跨いで移動できるアレ
set whichwrap=b,s,h,l,<,>,[,]

" カーソル行をハイライト
set cursorline
" カーソル位置のカラムのハイライト
set cursorcolumn

" コマンド非表示
set noshowcmd

" 空白文字の可視化
set list
set listchars=tab:»-,trail:_,eol:↲,extends:»,precedes:«,nbsp:･

" ステータスラインを常に表示
set laststatus=2

" コマンドラインの高さ
set cmdheight=2

" タイトル表示
set title

" タブエリアを常に表示
set showtabline=2

"================================================================
" edit
"================================================================

" スマートインデントON
set autoindent
set smartindent

" タブをスペースに展開
set expandtab

" インデント幅を4に
set tabstop=4
set shiftwidth=4
set softtabstop=4

autocmd FileType ruby,html,html.eruby,coffee,sass,scss setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd BufNewFile,BufRead *.html.erb set filetype=html.eruby

" インデントをshiftwidthの倍数に丸める
set shiftround

" backspaceで改行とかインデントとかを消せるようにする
set backspace=indent,eol,start

" 単語を補完する時の大文字小文字の無視
set infercase

" スワップファイルを作らない
set noswapfile

" 折りたたみON
set foldenable
set foldmethod=syntax
set foldcolumn=4
" 起動時は全開にする
set foldlevel=99

" 新しいウィンドウを下（右）に開く
set splitbelow
set splitright

" 3行分だけ余裕をもたせてスクロール
set scrolloff=3

" カッコを自動補完
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
vnoremap { "zdi{<C-R>z}<ESC>
vnoremap [ "zdi[<C-R>z]<ESC>
vnoremap ( "zdi(<C-R>z)<ESC>
vnoremap " "zdi"<C-R>z"<ESC>
vnoremap ' "zdi'<C-R>z'<ESC>

"===============================================================
" plugin
"===============================================================

"---------------------------------------------------------------
" vim-quickrun
"---------------------------------------------------------------

let g:quickrun_config = {
    \   'markdown': {
    \     'type': 'markdown/gfm',
    \     'outputter': 'browser'
    \   }
    \ }

"---------------------------------------------------------------
" vim-indent-guides
"---------------------------------------------------------------

let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1

"---------------------------------------------------------------
" vim-over
"---------------------------------------------------------------

nnoremap <Leader>o :OverCommandLine<CR>

"---------------------------------------------------------------
" lightline.vim
"---------------------------------------------------------------

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?"⭤":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
      \ },
      \ 'separator': { 'left': '⮀', 'right': '⮂' },
      \ 'subseparator': { 'left': '⮁', 'right': '⮃' }
      \ }

"---------------------------------------------------------------
" NERD_commenter.vim
"---------------------------------------------------------------

let g:NERDSpaceDelims = 1

"---------------------------------------------------------------
" TaskList.vim
"---------------------------------------------------------------

nmap <C-T> <plug>TaskList

"---------------------------------------------------------------
" neocomplete
"---------------------------------------------------------------

" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

"---------------------------------------------------------------
" unite.vim
"---------------------------------------------------------------

let g:unite_enable_start_insert = 1
let g:unite_enable_split_vertically = 1
let g:unite_winwidth = 48
let g:unite_enable_short_source_names = 1
let g:unite_source_history_yank_enable = 1
noremap <silent> ,ub :<C-u>Unite buffer<CR>
noremap <silent> ,uh :<C-u>Unite file_mru<CR>
noremap <silent> ,uy :<C-u>Unite history/yank<CR>

" ref: http://qiita.com/yuku_t/items/9263e6d9105ba972aea8
function! DispatchUniteFileRecAsyncOrGit()
  if isdirectory(getcwd()."/.git")
    Unite file_rec/git
  else
    Unite file_rec/async
  endif
endfunction

nnoremap <silent> ,uf :<C-u>call DispatchUniteFileRecAsyncOrGit()<CR>

"---------------------------------------------------------------
" switch.vim
"---------------------------------------------------------------

nnoremap ! :Switch<CR>

autocmd FileType ruby let b:switch_custom_definitions = [
    \       ['if', 'unless'],
    \       ['while', 'until'],
    \       ['.blank?', '.present?'],
    \       ['include', 'extend'],
    \       ['class', 'module'],
    \       ['.inject', '.delete_if'],
    \       ['.map', '.map!'],
    \       ['attr_accessor', 'attr_reader', 'attr_writer'],
    \       [100, ':continue', ':information'],
    \       [101, ':switching_protocols'],
    \       [102, ':processing'],
    \       [200, ':ok', ':success'],
    \       [201, ':created'],
    \       [202, ':accepted'],
    \       [203, ':non_authoritative_information'],
    \       [204, ':no_content'],
    \       [205, ':reset_content'],
    \       [206, ':partial_content'],
    \       [207, ':multi_status'],
    \       [208, ':already_reported'],
    \       [226, ':im_used'],
    \       [300, ':multiple_choices'],
    \       [301, ':moved_permanently'],
    \       [302, ':found'],
    \       [303, ':see_other'],
    \       [304, ':not_modified'],
    \       [305, ':use_proxy'],
    \       [306, ':reserved'],
    \       [307, ':temporary_redirect'],
    \       [308, ':permanent_redirect'],
    \       [400, ':bad_request'],
    \       [401, ':unauthorized'],
    \       [402, ':payment_required'],
    \       [403, ':forbidden'],
    \       [404, ':not_found'],
    \       [405, ':method_not_allowed'],
    \       [406, ':not_acceptable'],
    \       [407, ':proxy_authentication_required'],
    \       [408, ':request_timeout'],
    \       [409, ':conflict'],
    \       [410, ':gone'],
    \       [411, ':length_required'],
    \       [412, ':precondition_failed'],
    \       [413, ':request_entity_too_large'],
    \       [414, ':request_uri_too_long'],
    \       [415, ':unsupported_media_type'],
    \       [416, ':requested_range_not_satisfiable'],
    \       [417, ':expectation_failed'],
    \       [422, ':unprocessable_entity'],
    \       [423, ':precondition_required'],
    \       [424, ':too_many_requests'],
    \       [426, ':request_header_fields_too_large'],
    \       [500, ':internal_server_error'],
    \       [501, ':not_implemented'],
    \       [502, ':bad_gateway'],
    \       [503, ':service_unavailable'],
    \       [504, ':gateway_timeout'],
    \       [505, ':http_version_not_supported'],
    \       [506, ':variant_also_negotiates'],
    \       [507, ':insufficient_storage'],
    \       [508, ':loop_detected'],
    \       [510, ':not_extended'],
    \       [511, ':network_authentication_required'],
    \ ]

"---------------------------------------------------------------
" Vim-LaTeX
"---------------------------------------------------------------

set shellslash
set grepprg=grep\ -nH\ $*
let g:Tex_AutoFolding = 0
let g:tex_flavor='latex'
let g:Imap_UsePlaceHolders = 1
let g:Imap_DeleteEmptyPlaceHolders = 1
let g:Imap_StickyPlaceHolders = 0
let g:Tex_DefaultTargetFormat = 'pdf'
"let g:Tex_FormatDependency_pdf = 'pdf'
let g:Tex_FormatDependency_pdf = 'dvi,pdf'
"let g:Tex_FormatDependency_pdf = 'dvi,ps,pdf'
let g:Tex_FormatDependency_ps = 'dvi,ps'
"let g:Tex_CompileRule_pdf = '/usr/texbin/ptex2pdf -l -ot "-synctex=1 -interaction=nonstopmode -file-line-error-style" $*'
"let g:Tex_CompileRule_pdf = '/usr/texbin/ptex2pdf -l -u -ot "-synctex=1 -interaction=nonstopmode -file-line-error-style" $*'
"let g:Tex_CompileRule_pdf = '/usr/texbin/pdflatex -synctex=1 -interaction=nonstopmode -file-line-error-style $*'
"let g:Tex_CompileRule_pdf = '/usr/texbin/lualatex -synctex=1 -interaction=nonstopmode -file-line-error-style $*'
"let g:Tex_CompileRule_pdf = '/usr/texbin/luajitlatex -synctex=1 -interaction=nonstopmode -file-line-error-style $*'
"let g:Tex_CompileRule_pdf = '/usr/texbin/xelatex -synctex=1 -interaction=nonstopmode -file-line-error-style $*'
let g:Tex_CompileRule_pdf = '/usr/texbin/dvipdfmx $*.dvi'
"let g:Tex_CompileRule_pdf = '/usr/local/bin/ps2pdf $*.ps'
let g:Tex_CompileRule_ps = '/usr/texbin/dvips -Ppdf -o $*.ps $*.dvi'
let g:Tex_CompileRule_dvi = '/usr/texbin/platex -synctex=1 -interaction=nonstopmode -file-line-error-style $*'
"let g:Tex_CompileRule_dvi = '/usr/texbin/uplatex -synctex=1 -interaction=nonstopmode -file-line-error-style $*'
let g:Tex_BibtexFlavor = '/usr/texbin/pbibtex'
"let g:Tex_BibtexFlavor = '/usr/texbin/upbibtex'
"let g:Tex_BibtexFlavor = '/usr/texbin/bibtex'
"let g:Tex_BibtexFlavor = '/usr/texbin/bibtexu'
let g:Tex_MakeIndexFlavor = '/usr/texbin/mendex $*.idx'
"let g:Tex_MakeIndexFlavor = '/usr/texbin/makeindex $*.idx'
"let g:Tex_MakeIndexFlavor = '/usr/texbin/texindy $*.idx'
let g:Tex_UseEditorSettingInDVIViewer = 1
"let g:Tex_ViewRule_pdf = '/usr/bin/open'
"let g:Tex_ViewRule_pdf = '/usr/bin/open -a Preview.app'
"let g:Tex_ViewRule_pdf = '/usr/bin/open -a Skim.app'
let g:Tex_ViewRule_pdf = '/usr/bin/open -a TeXShop.app'
"let g:Tex_ViewRule_pdf = '/usr/bin/open -a TeXworks.app'
"let g:Tex_ViewRule_pdf = '/usr/bin/open -a Firefox.app'
"let g:Tex_ViewRule_pdf = '/usr/bin/open -a "Adobe Reader.app"'

