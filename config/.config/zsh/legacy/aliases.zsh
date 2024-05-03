alias ls='ls -G'

alias l='eza --icons -a --git --git-ignore'
alias ll='l -l'
alias lll='eza --icons -al --git' # ll without --git-ignore
alias lt='l -T -L 3'
alias llt='ll -T -L 3'

alias vim='nvim'
if type ripgrep > /dev/null 2>&1; then
  alias rg='ripgrep'
fi

alias history='history -E'

alias mkdir='mkdir -p'

alias gsed=sed

if [[ -x `which colordiff` ]]; then
  alias diff='colordiff -u'
else
  alias diff='diff -u'
fi

alias mw="docker compose -f $HOME/.bin/compose.mw.yaml"

alias lg="lazygit"
