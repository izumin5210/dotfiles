alias ls='ls -G'

alias history='history -E'

alias cd='cdr'
alias mkdir='mkdir -p'
alias be='bundle exec'

alias vim='vim -c Obsession'

alias sed='gsed'
alias git='hub'

if [[ -x `which colordiff` ]]; then
  alias diff='colordiff -u'
else
  alias diff='diff -u'
fi
