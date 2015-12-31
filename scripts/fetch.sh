#!/usr/bin/env bash

set -eu

GITHUB_URL="https://github.com/izumin5210/dotfiles"

function has() {
    return `type $1 > /dev/null 2>&1`
}

if has "git"; then
    git clone --recursive "$GITHUB_URL" "$DOTPATH"

elif has "curl" || has "wget"; then
    tarball="$GITHUB_URL/archive/master.tar.gz"

    if has "curl"; then
        curl -L "$tarball"

    elif has "wget"; then
        wget -O - "$tarball"

    fi | tar xv -

    mv -f dotfiles-master "$DOTPATH"

else
    die "curl or wget required"
fi

