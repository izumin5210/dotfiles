# 環境変数と PATH は zsh と共通の ~/.config/shell/env.sh から読む。
# bash には .zshenv 相当 (どんな起動でも読まれるファイル) が無い。BASH_ENV は
# 非対話シェル専用で、sshd がそれを渡さない限り `ssh host 'cmd'` には効かない。
# そのため bash では .bashrc / .bash_profile / .profile が読み込み口になる。
[ -r "$HOME/.config/shell/env.sh" ] && . "$HOME/.config/shell/env.sh"
[ -r "$HOME/.config/shell/secrets.sh" ] && . "$HOME/.config/shell/secrets.sh"

# ここから下は対話シェル専用
case $- in
  *i*) ;;
  *) return ;;
esac
