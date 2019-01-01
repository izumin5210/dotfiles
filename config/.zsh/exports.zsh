export LANG=en_US.UTF-8

export EDITOR=nvim

# ================================================================
# path
# ================================================================
# homebrew
export PATH=/usr/local/bin:$PATH

export PATH=/usr/local/opt/coreutils/libexec/gnubin:${PATH}
export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:${MANPATH}

# yarn
export PATH="$HOME/.yarn/bin:$PATH"

# golang
export GOPATH=$HOME
export GOBIN=$GOPATH/gobin

# rust
export PATH=$HOME/.cargo/bin:$PATH

# android
export ANDROID_SDK_ROOT=/usr/local/share/android-sdk
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
