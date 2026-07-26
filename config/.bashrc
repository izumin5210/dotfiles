# bash には .zshenv 相当 (全起動で読まれるファイル) が無いのでここが読み込み口
[ -r "$HOME/.config/shell/env.sh" ] && . "$HOME/.config/shell/env.sh"
[ -r "$HOME/.config/shell/secrets.sh" ] && . "$HOME/.config/shell/secrets.sh"
