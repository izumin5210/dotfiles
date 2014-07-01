export PS1="\[\033[0;31m\][\t \w]\n\[\033[0;32m\] \$ \[\033[00m\]"
alias ls='ls -G'
export LSCOLORS=gxfxcxdxbxegedabagacad

export LANG='ja_JP.UTF-8'
export LC_ALL='ja_JP.UTF-8'
export LC_MESSAGES='ja_JP.UTF-8'
export LC_CTYPE='ja_JP.UTF-8'

eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/shims:/usr/local/bin:$PATH:/usr/local/sbin:~/bin:/usr/local/share/npm/bin"
export ANDROID_SDK_ROOT=/usr/local/opt/android-sdk
export ANDROID_SDK_TOOLS=/usr/local/opt/android-sdk/tools
export ANDROID_SDK_PLATFORM_TOOLS=/usr/local/opt/android-sdk/platform-tools
export GROOVY_HOME=/usr/local/opt/groovy/libexec
export PATH=$PATH:$ANDROID_SDK_TOOLS:$ANDROID_SDK_PLATFORM_TOOLS
alias ssaver='open /System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app'

#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "/Users/izumin/.gvm/bin/gvm-init.sh" ]] && source "/Users/izumin/.gvm/bin/gvm-init.sh"
