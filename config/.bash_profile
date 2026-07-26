# bash はログインシェルだと .bashrc を読まないので、慣例どおりここから読む。
[ -r "$HOME/.bashrc" ] && . "$HOME/.bashrc"
