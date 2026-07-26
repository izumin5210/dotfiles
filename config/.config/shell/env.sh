# すべてのシェルの全起動で読まれる (zsh: .zshenv / bash: .bashrc / sh: .profile)。
# POSIX sh の範囲で書き、外部コマンドの実行・副作用・非冪等な追記を持ち込まないこと。
# シェル固有の設定は .zshenv / .bashrc へ、対話シェル専用の設定は .zshrc へ。

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$HOME/.config"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$HOME/.cache"}
export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}
export XDG_STATE_HOME=${XDG_STATE_HOME:="$HOME/.local/state"}

export LANG=en_US.UTF-8
export EDITOR=nvim

# ================================================================
# path
# ================================================================

export PATH="${HOME}/.local/bin:${PATH}"
export PATH="/usr/local/bin:${PATH}"
export PATH=$HOME/bin:$PATH
export PATH=$HOME/.bin:$PATH

# Go
export GOPATH="$XDG_DATA_HOME"/go
export GOMODCACHE="$XDG_CACHE_HOME"/go/mod
export GOBIN=$HOME/gobin
export PATH=$GOBIN:$PATH

# Node.js
export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history

# Ruby
export IRBRC="$XDG_CONFIG_HOME"/irb/irbrc

# MySQL
export MYSQL_HISTFILE="$XDG_DATA_HOME"/mysql_history

# PostgreSQL
export PSQL_HISTORY="$XDG_STATE_HOME"/psql_history

# Redis
export REDISCLI_HISTFILE="$XDG_DATA_HOME"/redis/rediscli_history
export REDISCLI_RCFILE="$XDG_CONFIG_HOME"/redis/redisclirc

# Rancher Desktop
export PATH=$HOME/.rd/bin:$PATH

# Nix
export PATH=/nix/var/nix/profiles/default/bin:$PATH
export PATH=$HOME/.nix-profile/bin:$PATH

# fzf
export FZF_DEFAULT_OPTS_FILE="$XDG_CONFIG_HOME"/fzf/config

# ripgrep
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME"/ripgrep/config

# git
# $OSTYPE を持たないシェルでだけ uname を呼ぶ
case "${OSTYPE:-$(uname)}" in
[Dd]arwin*)
  export GIT_CREDENTIAL_HELPER="osxkeychain"
  ;;
[Ll]inux*)
  # NOTE: gnome-keyring and libsecret do not work on my Pixelbook...
  export GIT_CREDENTIAL_HELPER="store"
  ;;
esac

# aqua
# bin/* は aqua-proxy への symlink なので、PATH だけでは解決できず設定も要る
export PATH="${AQUA_ROOT_DIR:-${XDG_DATA_HOME}/aquaproj-aqua}/bin:$PATH"
export AQUA_GLOBAL_CONFIG="${XDG_CONFIG_HOME}/aquaproj-aqua/aqua.yaml"
export AQUA_POLICY_CONFIG="${XDG_CONFIG_HOME}/aquaproj-aqua/aqua-policy.yaml"

# ghq
# git config の ghq.root より優先されるので、ここが実行時の値になる
export GHQ_ROOT="$HOME/src"

# dotfiles
export DOTFILES_DIR="${DOTFILES_DIR:-$GHQ_ROOT/github.com/izumin5210/dotfiles}"
export PATH="${DOTFILES_DIR}/node_modules/.bin":$PATH

# Osidian
export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"

# LayerX
export GOPRIVATE=github.com/LayerXcom/

# misc
# ホスト名は zsh が $HOST、bash が $HOSTNAME
_host=${HOSTNAME:-${HOST:-$(uname -n)}}
if [ "${_host%%.*}" != 'rabbithouse' ]; then
  export TM_REMOTE_HOSTS=rabbithouse
fi
unset _host

# ================================================================
# overrides on codespaces
# ================================================================
if [ "$CODESPACES" = "true" ]; then
  export AQUA_GLOBAL_CONFIG="${AQUA_GLOBAL_CONFIG}:${XDG_CONFIG_HOME}/aquaproj-aqua/codespaces/aqua.yaml"
  # set VSCode to $EDITOR on VSCode intergarted terminal
  if [ "$VSCODE_INJECTION" = "1" ]; then
    export EDITOR="code --wait"
  fi
fi
