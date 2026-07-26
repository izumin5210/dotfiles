setopt no_global_rcs  # disable path helper

export ZDOTDIR="$HOME"/.config/zsh

# `export PATH=...` は属性を貼り直すので、tie されたスカラ側にも -U が要る
typeset -U path PATH fpath FPATH

. "$HOME/.config/shell/env.sh"

if [ -r "$HOME/.config/shell/secrets.sh" ]; then
  . "$HOME/.config/shell/secrets.sh"
fi
