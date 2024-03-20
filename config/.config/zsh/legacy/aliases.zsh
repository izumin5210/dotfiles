alias ls='ls -G'
alias vim='nvim'
if type ripgrep > /dev/null 2>&1; then
  alias rg='ripgrep'
fi

alias history='history -E'

alias mkdir='mkdir -p'
alias be='bundle exec'

alias gsed=sed

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
