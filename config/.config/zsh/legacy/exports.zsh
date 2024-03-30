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
export GOPATH=$HOME
export GOBIN=$GOPATH/gobin
export PATH=$GOBIN:$PATH

# Rancher Desktop
export PATH=$HOME/.rd/bin:$PATH

# Nix
export PATH=/nix/var/nix/profiles/default/bin:$PATH
export PATH=$HOME/.nix-profile/bin:$PATH

# fzf
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
--color=dark
--color=fg:-1,bg:-1,hl:#95c4ce,fg+:-1,bg+:-1,hl+:#e9b189
--color=info:#a093c7,prompt:#89bac2,pointer:#ada0d3,marker:#ada0d3,spinner:#ada0d3
'

# ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

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
