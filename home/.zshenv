
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

