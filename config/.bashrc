# 環境変数と PATH は zsh と共通の ~/.config/shell/env.sh から読む。
# bash には .zshenv 相当 (どんな起動でも読まれるファイル) が無い。BASH_ENV は
# 非対話シェル専用で、sshd がそれを渡さない限り `ssh host 'cmd'` には効かない。
# そのため bash では .bashrc / .bash_profile / .profile が読み込み口になる。
#
# bash はビルド次第で非対話起動でもこのファイルを読む (SSH_SOURCE_BASHRC)。
# それに乗るために env の読み込みをここに置いているので、対話シェル専用の設定を
# 足すときは `case $- in *i*) ;; *) return ;; esac` でガードしてから下に書くこと。
[ -r "$HOME/.config/shell/env.sh" ] && . "$HOME/.config/shell/env.sh"
[ -r "$HOME/.config/shell/secrets.sh" ] && . "$HOME/.config/shell/secrets.sh"
