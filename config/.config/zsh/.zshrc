source $HOME/.config/zsh/legacy/exports.zsh
source $HOME/.config/zsh/legacy/aliases.zsh

ulimit -u 2048
ulimit -n 16384

bindkey -e # emacs emulation
autoload -Uz add-zsh-hook

# Zsh options
# ================================================================
REPORTTIME=3

setopt correct
setopt interactive_comments
setopt extended_glob

# ---- Histroy ----
mkdir -p "$XDG_STATE_HOME"/zsh "$XDG_CACHE_HOME"/zsh

HISTFILE="$XDG_STATE_HOME"/zsh/history
HISTSIZE=10000    # メモリに保存される履歴の件数
SAVEHIST=1000000  # 保存される履歴の件数
# https://github.com/rothgar/mastering-zsh/blob/921766e642bcf02d0f1be8fc57d0159a867299b0/docs/config/history.md
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt APPEND_HISTORY            # append to history file
setopt HIST_NO_STORE             # Don't store history commands

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 5000
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':chpwd:*' recent-dirs-prune 'parent'
zstyle ':chpwd:*' recent-dirs-file "$XDG_CACHE_HOME"/zsh/chpwd-recent-dirs
zstyle ':completion:*' recent-dirs-insert both
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache

# cdしたあとで、自動的に ls する
function chpwd() { eza --icons -a --git-ignore }

# ---- Directory stack ----
setopt auto_cd            # ディレクトリ名を入力したら自動でcd
setopt auto_pushd         # ディレクトリスタックに追加（`cd +<Tab>`で履歴表示）
setopt pushd_ignore_dups  # pushd時にすでにスタックに含まれてた場合は追加しない
DIRSTACKSIZE=100          # ディレクトリスタック保存件数

# ---- Completion ----
if [ -d "$HOME/.nix-profile/share/zsh/site-functions" ]; then
  fpath=($HOME/.nix-profile/share/zsh/site-functions $fpath)
fi

setopt auto_menu                      # 補完候補が複数あるときに自動的に一覧表示
bindkey "^[[Z" reverse-menu-complete  # Shift-Tabで補完候補を逆順する("\e[Z"でも動作する)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 補完時に大文字小文字を区別しない

autoload -Uz compinit
compinit -C -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION

# Load plugins
# ================================================================
# aqua
if type aqua >/dev/null 2>&1; then
  source <(aqua completion zsh);
  aqua install --all --only-link
fi

# Sheldon
eval "$(sheldon source)"

# Starship
eval "$(starship init zsh)"

# direnv
if type direnv > /dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# fnm (Node.js)
if type fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --log-level error)"
fi

# fzf
if type fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi

# 1Password
if [ -d "${HOME}/.config/op/plugins.sh" ]; then
  source "${HOME}/.config/op/plugins.sh"
fi

# Orbstack
if [ -f "${HOME}/.orbstack/shell/init.zsh" ]; then
  source "${HOME}/.orbstack/shell/init.zsh"
fi

source $HOME/.config/zsh/legacy/functions.zsh
