export LANG=en_US.UTF-8

export EDITOR=vim

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

# java
export JAVA8_HOME=`/usr/libexec/java_home -v 1.8`
export JAVA_HOME=$JAVA8_HOME

# groovy
export GROOVY_HOME=/usr/local/opt/groovy/libexec
# sdkman
export SDKMAN_DIR="/Users/izumin/.sdkman"

# postgres
export POSTGRESAPP_ROOT=/Applications/Postgres.app/Contents/Versions/9.4

# path
export PATH=$HOME/bin:$PATH
export PATH=$RBENV_ROOT/bin:$PATH
export PATH=$PYENV_ROOT/bin:$PATH
export PATH=$GOBIN:$PATH
export PATH=$ANDROID_SDK_TOOLS:$ANDROID_SDK_PLATFORM_TOOLS:$PATH
export PATH=$POSTGRESAPP_ROOT/bin:$PATH

# openni2
export OPENNI2_INCLUDE=/usr/local/include/ni2
export OPENNI2_REDIST=/usr/local/lib/ni2
export NITE2_INCLUDE=/usr/local/Cellar/nite2/2.2a/Include
export NITE2_REDIST=/usr/local/Cellar/nite2/2.2a/Redist

# OpenCV3
export OpenCV_DIR=/usr/local/Cellar/opencv3/3.1.0_1/share/OpenCV/

# Tools in wantedly
export PATH=$HOME/.wantedly/bin:$PATH

# ================================================================
# other
# ================================================================
# OpenNI2
export DYLD_LIBRARY_PATH=/usr/local/lib/ni2:$DYLD_LIBRARY_PATH
export OPENNI2_INCLUDE=/usr/local/include/ni2
export OPENNI2_REDIST=/usr/local/lib/ni2
