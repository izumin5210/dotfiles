
# zmodload zsh/zprof && zprof

# ================================================================
# 環境変数とかそんなん
# ================================================================

export LANG=ja_JP.UTF-8
export EDITOR=vim

# MacTeX by homebrew
eval `/usr/libexec/path_helper -s`

# gvm
[[ -s "/Users/izumin/.gvm/bin/gvm-init.sh" ]] && source "/Users/izumin/.gvm/bin/gvm-init.sh"

# rbenv
if [ -d ${HOME}/.rbenv ]; then
  export PATH=$HOME/.rbenv/bin:$PATH
  eval "$(rbenv init - --no-rehash)"
fi

# nodebrew
export PATH=$HOME/.nodebrew/current/bin:$PATH

# android
export ANDROID_HOME=/usr/local/opt/android-sdk
export ANDROID_SDK_ROOT=/usr/local/opt/android-sdk
export ANDROID_SDK_TOOLS=/usr/local/opt/android-sdk/tools
export ANDROID_SDK_PLATFORM_TOOLS=/usr/local/opt/android-sdk/platform-tools
export GROOVY_HOME=/usr/local/opt/groovy/libexec
export PATH=$PATH:$ANDROID_SDK_TOOLS:$ANDROID_SDK_PLATFORM_TOOLS

# homebrew
export PATH=/usr/local/bin:$PATH

export PATH=$HOME/bin:$PATH

# homebrew cask
export HOMEBREW_CASK_OPTS="--appdir=/Applications --caskroom=/opt/homebrew-cask/Caskroom"

# docker
export DOCKER_HOST=tcp://192.168.59.103:2376
export DOCKER_CERT_PATH=/Users/izumin/.boot2docker/certs/boot2docker-vm
export DOCKER_TLS_VERIFY=1

# Postgres.app
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/9.4/bin

# Go
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/opt/go/libexec/bin:$GOPATH/bin

# pyenv
if which pyenv > /dev/null; then
  export PYENV_ROOT=$HOME/.pyenv
  export PATH=$PYENV_ROOT/bin:$PATH
  eval "$(pyenv init -)";
fi
