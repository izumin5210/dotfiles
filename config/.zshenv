setopt no_global_rcs  # disable path helper

export ZDOTDIR="$HOME"/.config/zsh

# PATH の重複除去。POSIX 共通の env.sh には書けない zsh 専用の設定なのでここに置く。
# `export PATH=...` は属性を貼り直すので、tie されたスカラ側にも -U が要る。
typeset -U path PATH fpath FPATH

# 環境変数と PATH は全 zsh で要る。.zshrc (対話シェル専用) から読むと
# `ssh host 'cmd'` / `zsh -c` / スクリプトに PATH が渡らず、たとえば
# herdr のリモート探索 (`ssh host 'command -v herdr'`) が黙って失敗する。
# 1 行目の no_global_rcs で path_helper を止めてあるので、ここに PATH を
# 置いても /etc/zprofile に並べ替えられることはない。
. "$HOME/.config/shell/env.sh"

# API キー類。対話シェル以外にも渡すためここで読む。
# 生成 (op inject) は 1Password の認証が要るので .zshrc 側で対話シェル限定に行う。
if [ -r "$HOME/.config/shell/secrets.sh" ]; then
  . "$HOME/.config/shell/secrets.sh"
fi
