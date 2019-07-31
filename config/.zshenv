setopt no_global_rcs

source $HOME/.zsh/exports.zsh
source $HOME/.zsh/aliases.zsh

# rbenv
if [ -d "${HOME}/.rbenv" ]; then
  eval "$(rbenv init - --no-hash)"
fi

# pyenv
if [ -d "${HOME}/.pyenv" ]; then
  eval "$(pyenv init - --no-hash)"
fi

# nodenv
if [ -d "${HOME}/.nodenv" ]; then
  eval "$(nodenv init - --no-hash)"
fi

# direnv
eval "$(direnv hook zsh)"

# rust
source $HOME/.cargo/env
