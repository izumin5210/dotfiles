# sh/dash のログインシェル用。
# bash は .bash_profile を優先するのでここには来ない (zsh は .profile を読まない)。
[ -r "$HOME/.config/shell/env.sh" ] && . "$HOME/.config/shell/env.sh"
[ -r "$HOME/.config/shell/secrets.sh" ] && . "$HOME/.config/shell/secrets.sh"
