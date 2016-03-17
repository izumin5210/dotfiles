
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

# direnv
eval "$(direnv hook bash)"
