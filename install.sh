#!/usr/bin/env bash

# ref: http://qiita.com/b4b4r07/items/24872cdcbec964ce2178#deploy

set -eu

DOTPATH=~/.dotfiles

DOTPATH=$DOTPATH ./scripts/fetch.sh
DOTPATH=$DOTPATH ./scripts/deploy.sh
