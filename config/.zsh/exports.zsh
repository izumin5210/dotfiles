export LANG=en_US.UTF-8

export EDITOR=nvim
export TERM=xterm-256color

# ================================================================
# path
# ================================================================

export PATH=$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:${PATH}
export MANPATH=$HOMEBREW_PREFIX/opt/coreutils/libexec/gnuman:${MANPATH}

# yarn
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

# path
export PATH=$HOME/bin:$PATH
export PATH=$RBENV_ROOT/bin:$PATH
export PATH=$PYENV_ROOT/bin:$PATH
export PATH=$GOBIN:$PATH
export PATH=$ANDROID_SDK_TOOLS:$ANDROID_SDK_PLATFORM_TOOLS:$PATH
export PATH=$POSTGRESAPP_ROOT/bin:$PATH

# Tools in wantedly
export PATH=$HOME/.wantedly/bin:$PATH

# fzf
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
--color=dark
--color=fg:-1,bg:-1,hl:#95c4ce,fg+:-1,bg+:-1,hl+:#e9b189
--color=info:#a093c7,prompt:#89bac2,pointer:#ada0d3,marker:#ada0d3,spinner:#ada0d3
'
