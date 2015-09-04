
# zmodload zsh/zprof && zprof

source $HOME/.zsh/functions.zsh
source $HOME/.zsh/exports.zsh

# MacTeX by homebrew
eval `/usr/libexec/path_helper -s`

# gvm
[[ -s "/Users/izumin/.gvm/bin/gvm-init.sh" ]] && source "/Users/izumin/.gvm/bin/gvm-init.sh"

# rbenv
if [ -d ${HOME}/.rbenv ]; then
  eval "$(rbenv init - --no-rehash)"
fi

# pyenv
if which pyenv > /dev/null; then
  eval "$(pyenv init -)";
fi
