
bindkey -e
autoload -Uz add-zsh-hook
source $HOME/.zsh/prompt.zsh
source $HOME/.zsh/functions.zsh
source $HOME/.zsh/notify.zsh


# ================================================================
# オプション
# ================================================================

REPORTTIME=3

#### complement ####
fpath=($(brew --prefix)/share/zsh/site-functions $fpath)    # gitのbranch名補完
autoload -Uz compinit; compinit -C      # 補完機能を有効にする
setopt auto_menu                        # 補完候補が複数あるときに自動的に一覧表示
bindkey "^[[Z" reverse-menu-complete    # Shift-Tabで補完候補を逆順する("\e[Z"でも動作する)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 補完時に大文字小文字を区別しない
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
    /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin    # sudo の後ろでコマンド名を補完
if [ -e /usr/local/share/zsh-completions ]; then
  fpath=(/usr/local/share/zsh-completions $fpath)   # zsh-completions有効化
fi


#### history ####
HISTFILE=~/.zsh_history         # 履歴の保存先
HISTSIZE=1000000                # メモリに保存される履歴の件数
SAVEHIST=1000000                # 保存される履歴の件数
setopt hist_ignore_all_dups     # コマンド履歴がダブってたら古い方を消す
setopt hist_ignore_space        # スペースから始まるコマンドを履歴に追加しない
setopt hist_reduce_blanks       # 履歴追加時に余分なスペースを削除
setopt share_history            # 同時に起動したzshの間で履歴共有

#### directory stack ####
setopt auto_pushd           # ディレクトリスタックに追加（`cd +<Tab>`で履歴表示）
setopt pushd_ignore_dups    # pushd時にすでにスタックに含まれてた場合は追加しない
DIRSTACKSIZE=100            # ディレクトリスタック保存件数

#### cdr ####
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 5000
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':completion:*' recent-dirs-insert both

# 拡張globを有効化
setopt extended_glob

# ディレクトリ名を入力したら自動でcd
setopt auto_cd
# cdしたあとで、自動的に ls する
function chpwd() { ls }

# コマンドが間違ってるときのサジェスト
setopt correct

# '#' 以降をコメントとして扱う
setopt interactive_comments

# ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする
# bindkey '^R' history-incremental-pattern-search-backward

# ================================================================
# プロファイリング結果出力
# ================================================================

# if (which zprof > /dev/null) ;then
  # zprof | less
# fi

# added by travis gem
[ -f /Users/izumin/.travis/travis.sh ] && source /Users/izumin/.travis/travis.sh
