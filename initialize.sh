#!/bin/sh

function is_exists() {
    return `type $1 > /dev/null 2>&1`
}

function is_installed() {
    return $(brew info $1 | grep -c "Not installed")
}

if ! is_exists "brew"; then
    # install Homebrew
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if is_installed "ricty" && [ `find ~/Library/Fonts -name "Ricty*.ttf" | wc -l` -eq 0 ]; then
    # もっとスマートに生きていきたい
    args=$(brew info ricty | grep "Ricty\*.ttf" | sed -e "s/.*cp -f \(.*\) \(.*\)/\1 \2/")
    eval "cp -f $args"
    fc-cache -vf
fi

if is_installed "zsh" && [ $SHELL != `which zsh` ]; then
    echo current shell: $SHELL
    echo Please exec
    echo "\t$ sudo sh -c \"echo `which zsh` >> /etc/shells\""
    echo "\t$ chsh -s `which zsh`"
fi

if [ ! -e ~/.gvm ]; then
    # install GVM(Groovy enVironment Manager)
    curl -s get.gvmtool.net | bash
fi

if ! is_exists "~/.tmux/plugins/tpm/tpm"; then
    # install tpm(Tmux Plugin Manager)
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if is_exists "node" && `which node | grep -qF .nodebrew`; then
    echo "- [o] node"
else
    echo "- [ ] node"
fi

if is_exists "groovy" && `which groovy | grep -qF .gvm`; then
    echo "- [o] groovy"
else
    echo "- [ ] groovy"
fi

if is_exists "gradle" && `which gradle | grep -qF .gvm`; then
    echo "- [o] gradle"
else
    echo "- [ ] gradle"
fi

if is_exists "ruby" && `which ruby | grep -qF .rbenv`; then
    echo "- [o] ruby"
else
    echo "- [ ] ruby"
fi
