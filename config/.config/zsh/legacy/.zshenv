setopt no_global_rcs

# homebrew
brewPrefix=""

case "$(uname)" in
  "Darwin")
    if [ -d "/opt/homebrew" ]; then
      brewPrefix="/opt/homebrew"
    else
      brewPrefix="/usr/local"
    fi
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

source $HOME/.config/zsh/legacy/exports.zsh
source $HOME/.config/zsh/legacy/aliases.zsh

# rbenv
if [ -d "${HOME}/.rbenv" ]; then
  eval "$(rbenv init -)"
fi

# pyenv
if [ -d "${HOME}/.pyenv" ]; then
  eval "$(pyenv init -)"
fi

if type fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --log-level error)"
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

# 1password
if [ -d "$HOME/.config/op/plugins.sh" ]; then
  source $HOME/.config/op/plugins.sh
fi
