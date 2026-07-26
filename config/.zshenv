setopt no_global_rcs  # disable path helper

export ZDOTDIR="$HOME"/.config/zsh

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$HOME/.config"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$HOME/.cache"}
export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}
export XDG_STATE_HOME=${XDG_STATE_HOME:="$HOME/.local/state"}

# 環境変数と PATH は全 zsh で要る。.zshrc (対話シェル専用) から読むと
# `ssh host 'cmd'` / `zsh -c` / スクリプトに PATH が渡らず、たとえば
# herdr のリモート探索 (`ssh host 'command -v herdr'`) が黙って失敗する。
# 1 行目の no_global_rcs で path_helper を止めてあるので、ここに PATH を
# 置いても /etc/zprofile に並べ替えられることはない。
source "$ZDOTDIR/env.zsh"

# API キー類。対話シェル以外にも渡すためここで読む。
# 生成 (op inject) は 1Password の認証が要るので .zshrc 側で対話シェル限定に行う。
if [ -r "$ZDOTDIR/secrets.zsh" ]; then
  source "$ZDOTDIR/secrets.zsh"
fi
