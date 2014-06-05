#!/bin/sh

function is_exists() {
    return `type $1 > /dev/null 2>&1`
}

if ! is_exists "brew"; then
    # install Homebrew
    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
fi

if ! is_exists "nodebrew"; then
    # install Nodebrew
    curl -L git.io/nodebrew | perl - setup
fi

