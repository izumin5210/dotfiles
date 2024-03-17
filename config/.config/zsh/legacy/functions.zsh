_register_keycommand() {
  zle -N $2
  bindkey "$1" $2
}

_buffer_insert() {
  local rbuf="$RBUFFER"
  BUFFER="$LBUFFER$(cat)"
  CURSOR=$#BUFFER
  BUFFER="$BUFFER$rbuf"
}

_buffer_replace() {
  BUFFER="$(cat)"
  CURSOR=$#BUFFER
}

#  Move to repository
#--------------------------------
_ghq_list_fzf() {
  _buffer_replace <<< "$(echo $(ghq root)/$(ghq list | fzf))"
  zle accept-line
  zle fzf-redraw-prompt
}

_register_keycommand '^]' _ghq_list_fzf

_tmux_session() {
  _buffer_replace <<< "tm"
  zle accept-line
  zle reset-prompt
}

_register_keycommand '^tm' _tmux_session

#  git interactive operations
#--------------------------------
_git_interactive_add() {
  _buffer_replace <<< "git interactive-add"
  zle accept-line
  zle reset-prompt
}

_register_keycommand '^ga' _git_interactive_add

_git_interactive_checkout() {
  _buffer_replace <<< "git interactive-checkout"
  zle accept-line
  zle fzf-redraw-prompt
}

_register_keycommand '^gc' _git_interactive_checkout

_git_interactive_fixup() {
  _buffer_replace <<< "git interactive-fixup"
  zle accept-line
  zle fzf-redraw-prompt
}

_register_keycommand '^gf' _git_interactive_fixup
