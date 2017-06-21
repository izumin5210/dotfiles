alias ls='ls -G'

alias history='history -E'

alias cd='cdr'
alias mkdir='mkdir -p'
alias be='bundle exec'

if type nvim > /dev/null 2>&1; then
  alias vim='nvim -c Obsession'
else
  alias vim='vim -c Obsession'
fi

alias sed='gsed'
alias git='hub'
