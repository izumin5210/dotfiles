#!/usr/bin/env bash

set -eu

cd $DOTPATH/home
if [ $? -ne 0 ]; then
    die "not found: $DOTPATH"
fi

for f in .??*
do
    [ "$f" = ".git" ] && continue

    ln -snfv "$DOTPATH/home/$f" "$HOME/$f"
done

ln -snfv "$DOTPATH/home/bin" "$HOME/bin"
