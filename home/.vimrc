source $HOME/.vim/.vimrc.bundle
source $HOME/.vim/.vimrc.indent
source $HOME/.vim/.vimrc.appearance

set fileencodings=utf-8,cp932,euc-jp,iso-2022-jp
set fenc=utf-8
set encoding=utf-8

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
" moving
"================================================================

" <hoge></hoge>みたいなのも%で移動できる
set matchpairs+=<:>
" matchitを有効化（rubyのコードブロックに対応させる）
if !exists('loaded_matchit')
  " matchitを有効化
  runtime macros/matchit.vim
endif

" 行を跨いで移動できるアレ
set whichwrap=b,s,h,l,<,>,[,]

"================================================================
" tab
"================================================================

nnoremap [tab] <Nop>
nmap t [tab]

for n in range(1, 9)
    execute 'nnoremap <silent> [tab]'.n ':<C-u>tabnext'.n.'<CR>'
endfor

map <silent> [tab]t :tablast <bar> tabnew<CR>
map <silent> [tab]x :tabclose<CR>
map <silent> [tab]n :tabnext<CR>
map <silent> [tab]p :tabprevious<CR>

"================================================================
" edit
"================================================================

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

" クリップボード有効化
set clipboard+=unnamed

