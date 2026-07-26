# bash はログインシェルだと .bashrc を読まない
[ -r "$HOME/.bashrc" ] && . "$HOME/.bashrc"
