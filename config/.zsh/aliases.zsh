alias ls='ls -G'
alias vim='nvim'

alias history='history -E'

alias mkdir='mkdir -p'
alias be='bundle exec'

alias sed='gsed'

# `hub` has implemented `pr` and `sync` subcommands. they are conflicted with self-defined commands.
# alias git='hub'

if [[ -x `which colordiff` ]]; then
  alias diff='colordiff -u'
else
  alias diff='diff -u'
fi
