setopt no_global_rcs

# homebrew
brewPrefix=""

case "$(uname)" in
  "Darwin")
    brewPrefix="/usr/local"
    ;;
  "Linux")
    brewPrefix="/home/linuxbrew/.linuxbrew"
    if [ ! -d "$brewPrefix" ]; then
      brewPrefix="/home/$USER/.linuxbrew"
    fi
esac

if [ -f "$brewPrefix/bin/brew" ]; then
  eval $($brewPrefix/bin/brew shellenv)
fi

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

# jenv
if [ -d "${HOME}/.jenv" ]; then
  eval "$(jenv init -)"
fi

# direnv
if type direnv > /dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# rust
if [ -d "${HOME}/.cargo" ]; then
  source $HOME/.cargo/env
fi
