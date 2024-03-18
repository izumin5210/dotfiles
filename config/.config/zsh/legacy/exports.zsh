export LANG=en_US.UTF-8

export EDITOR=nvim
export TERM=xterm-256color

# ================================================================
# path
# ================================================================

export DEFAULT_PREFIX="${HOMEBREW_PREFIX:-"${HOME}/.local"}"

if [ -n "$HOMEBREW_PREFIX" ]; then
  export PATH=$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:${PATH}
  export MANPATH=$HOMEBREW_PREFIX/opt/coreutils/libexec/gnuman:${MANPATH}
fi

export PATH="${HOMEBREW_PREFIX}/bin:${PATH}"
export PATH="${HOME}/.local/bin:${PATH}"
export PATH="/usr/local/bin:${PATH}"

# yarn
export PATH="$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$HOME/.yarn/bin:$PATH"

# golang
export GOPATH=$HOME
export GOBIN=$GOPATH/gobin

# rust
export PATH=$HOME/.cargo/bin:$PATH

# android
export ANDROID_SDK_ROOT=$HOMEBREW_PREFIX/share/android-sdk
export ANDROID_SDK_TOOLS=$ANDROID_SDK_ROOT/tools
export ANDROID_SDK_PLATFORM_TOOLS=$ANDROID_SDK_ROOT/platform-tools
export ANDROID_HOME=$ANDROID_SDK_ROOT

# Rancher Desktop
export PATH=$HOME/.rd/bin:$PATH

# path
export PATH=$HOME/bin:$PATH
export PATH=$HOME/.bin:$PATH
export PATH=$RBENV_ROOT/bin:$PATH
export PATH=$PYENV_ROOT/bin:$PATH
export PATH=$GOBIN:$PATH
export PATH=$ANDROID_SDK_TOOLS:$ANDROID_SDK_PLATFORM_TOOLS:$PATH
export PATH=$POSTGRESAPP_ROOT/bin:$PATH
# nix
export PATH=/nix/var/nix/profiles/default/bin:$PATH
export PATH=$HOME/.nix-profile/bin:$PATH

# Tools in wantedly
export PATH=$HOME/.wantedly/bin:$PATH

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

export GOPRIVATE=github.com/LayerXcom/
