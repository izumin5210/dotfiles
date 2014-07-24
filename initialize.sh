#!/bin/sh

function is_exists() {
    return `type $1 > /dev/null 2>&1`
}

function is_installed() {
    return `brew info $1 | grep -vq "Not installed"`
}


if is_installed "ricty" && [ `find ~/Library/Fonts -name "Ricty*.ttf" | wc -l` -eq 0 ]; then
    # もっとスマートに生きていきたい
    args=$(brew info ricty | grep "Ricty\*.ttf" | sed -e "s/.*cp -f \(.*\) \(.*\)/\1 \2/")
    eval "cp -f $args"
    fc-cache -vf
fi

if ! is_exists "brew"; then
    # install Homebrew
    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
fi

if [ ! -e ~/.gvm ]; then
    # install GVM(Groovy enVironment Manager)
    curl -s get.gvmtool.net | bash
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
