export LANG=ja_JP.UTF-8
export EDITOR=vim


# ================================================================
# path
# ================================================================
# ruby
export RBENV_ROOT=$HOME/.rbenv

# python
export PYENV_ROOT=$HOME/.pyenv

# node
export NODEBREW_ROOT=$HOME/.nodebrew

# golang
export GOPATH=$HOME/go

# android
export ANDROID_HOME=/usr/local/opt/android-sdk
export ANDROID_SDK_ROOT=/usr/local/opt/android-sdk
export ANDROID_SDK_TOOLS=/usr/local/opt/android-sdk/tools
export ANDROID_SDK_PLATFORM_TOOLS=/usr/local/opt/android-sdk/platform-tools

# groovy
export GROOVY_HOME=/usr/local/opt/groovy/libexec

# postgres
export POSTGRESAPP_ROOT=/Applications/Postgres.app/Contents/Versions/9.4

# path
export PATH=/usr/local/bin:$PATH
export PATH=$HOME/bin:$PATH
export PATH=$RBENV_ROOT/bin:$PATH
export PATH=$PYENV_ROOT/bin:$PATH
export PATH=$NODEBREW_ROOT/current/bin:$PATH
export PATH=$GOPATH/bin:$PATH
export PATH=$ANDROID_SDK_TOOLS:$ANDROID_SDK_PLATFORM_TOOLS:$PATH
export PATH=$POSTGRESAPP_ROOT/bin:$PATH


# ================================================================
# other
# ================================================================
# homebrew cask
export HOMEBREW_CASK_OPTS="--appdir=/Applications --caskroom=/opt/homebrew-cask/Caskroom"

# docker
export DOCKER_HOST=tcp://192.168.59.103:2376
export DOCKER_CERT_PATH=/Users/izumin/.boot2docker/certs/boot2docker-vm
export DOCKER_TLS_VERIFY=1
