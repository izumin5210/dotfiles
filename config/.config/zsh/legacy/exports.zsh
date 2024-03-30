export LANG=en_US.UTF-8

if [ "$CODESPACES" = "true" ]; then
  export EDITOR="code --wait"
else
  export EDITOR=nvim
fi
export TERM=xterm-256color

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
mkdir -p "$XDG_DATA_HOME"/redis
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
case "$(uname)" in
  "Darwin")
    export GIT_CREDENTIAL_HELPER="osxkeychain"
    ;;
  "Linux")
    # NOTE: gnome-keyring and libsecret do not work on my Pixelbook...
    export GIT_CREDENTIAL_HELPER="store"
    ;;
esac

if [ -d "$HOME/.nix-profile/share/git/contrib/diff-highlight" ];then
  export PATH="$HOME/.nix-profile/share/git/contrib/diff-highlight:$PATH"
fi

# LayerX
export GOPRIVATE=github.com/LayerXcom/
