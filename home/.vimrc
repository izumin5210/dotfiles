set guifont=Ricty\ 9

set encoding=utf-8

syntax on

set number				" 行番号
set ruler
set showmatch				" 対応する括弧を表示
set whichwrap=b,s,h,l,<,>,[,]		" カーソルのワープ
set showcmd				" 入力中のコマンド表示
set cursorline				" カーソルのある行のハイライト
set hlsearch                " 検索のハイライト
nmap <Esc><Esc> :nohlsearch<CR><Esc>    " Esc連打でハイライト消す

set autoindent				" インデントの継承
set smartindent				" スマートなインデント
set expandtab				" インデントにスペース
set tabstop=4				" タブ幅4
set shiftwidth=4            " インデント幅4
set list				" 空白文字の可視化
set listchars=tab:»-,trail:_,eol:↲,extends:»,precedes:«,nbsp:･

set splitbelow				" 新しいウィンドウを下に開く
set splitright				" 新しいウィンドウを右に開く

function! GetStatusEx()
  let str = ''
  if &ft != ''
    let str = str . '[' . &ft . ']'
  endif
  if has('multi_byte')
    if &fenc != ''
      let str = str . '[' . &fenc . ']'
    elseif &enc != ''
      let str = str . '[' . &enc . ']'
    endif
  endif
  if &ff != ''
    let str = str . '[' . &ff . ']'
  endif
  return str
endfunction
set statusline=%<%f\ %m%r%h%w%=%{GetStatusEx()}\ \ %l,%c%V%8P

"===============================================================
"	plugin
"===============================================================

set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

Bundle "The-NERD-Commenter"
Bundle "neocomplcache"
Bundle "ZenCoding.vim"
Bundle "quickrun"
Bundle "Wombat"

filetype plugin indent on

colorscheme wombat
highlight SpecialKey ctermfg=DarkGray ctermbg=NONE
highlight SpecialKey guifg=#333333 guibg=NONE

" neocomplcache
let g:neocomplcache_enable_at_startup=1	" 起動時に有効化

" NERD Commenter
let NERDSpaceDelims=1			" スペース数

