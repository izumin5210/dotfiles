
# zmodload zsh/zprof && zprof

source $HOME/.zsh/exports.zsh
source $HOME/.zsh/aliases.zsh

# MacTeX by homebrew
eval `/usr/libexec/path_helper -s`

# gvm
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# anyenv
if [ -d ${HOME}/.anyenv ]; then
  eval "$(anyenv init - --no-rehash)"
fi

# rbenv
if [ -d ${HOME}/.rbenv ]; then
  eval "$(rbenv init - --no-rehash)"
fi

# pyenv
if which pyenv > /dev/null; then
  eval "$(pyenv init -)";
fi

# docker-machine
local machine='default'

if docker-machine ls | awk 'NR>1 { print $1 }' | grep -q $machine; then
  if [ "`docker-machine status $machine`" = "Stopped" ]; then
    docker-machine start $machine
  fi
  if [ "`docker-machine status $machine`" = "Running" ]; then
    eval "$(docker-machine env $machine)"
  fi
fi
