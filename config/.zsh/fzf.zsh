# Setup fzf
# ---------
export FZF_PREFIX="${DEFAULT_PREFIX}/opt/fzf"

export MANPATH="${FZF_PREFIX}/man:${MANPATH}"

if [[ ! "$PATH" == *${FZF_PREFIX}/bin* ]]; then
  export PATH="${PATH:+${PATH}:}${FZF_PREFIX}/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "${FZF_PREFIX}/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "${FZF_PREFIX}/shell/key-bindings.zsh"
