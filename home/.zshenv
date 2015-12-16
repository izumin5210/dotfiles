
# zmodload zsh/zprof && zprof

source $HOME/.zsh/exports.zsh
source $HOME/.zsh/aliases.zsh

# MacTeX by homebrew
eval `/usr/libexec/path_helper -s`

# gvm
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# rbenv
if [ -d ${HOME}/.rbenv ]; then
  eval "$(rbenv init - --no-rehash)"
fi

# pyenv
if which pyenv > /dev/null; then
  eval "$(pyenv init -)";
fi
