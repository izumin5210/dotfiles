setopt no_global_rcs

source $HOME/.zsh/exports.zsh
source $HOME/.zsh/secrets.zsh
source $HOME/.zsh/aliases.zsh

# gvm
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# anyenv
if [ -d ${HOME}/.anyenv ]; then
  eval "$(anyenv init - --no-rehash)"
fi

# direnv
eval "$(direnv hook zsh)"
