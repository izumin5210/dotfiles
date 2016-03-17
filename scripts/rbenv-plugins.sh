#!/usr/bin/env bash

function is_exists() {
    return 
}

if `type rbenv > /dev/null 2>&1`; then
    git clone https://github.com/rbenv/rbenv-default-gems.git $(rbenv root)/plugins/rbenv-default-gems
fi
