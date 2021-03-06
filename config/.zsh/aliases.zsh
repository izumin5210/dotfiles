alias ls='ls -G'
alias vim='nvim'
alias rg='ripgrep'

alias history='history -E'

alias mkdir='mkdir -p'
alias be='bundle exec'

if type gsed > /dev/null 2>&1; then
  alias sed='gsed'
fi

# `hub` has implemented `pr` and `sync` subcommands. they are conflicted with self-defined commands.
# alias git='hub'

if [[ -x `which colordiff` ]]; then
  alias diff='colordiff -u'
else
  alias diff='diff -u'
fi

alias ew='envchain wtd'

alias psql='mid pg psql'
alias createdb='mid pg createdb'
alias dropdb='mid pg dropdb'
alias redis-cli='mid redis exec redis-cli'
