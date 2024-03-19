fzf_base="/usr/share/doc/fzf/examples"
if type fzf-share >/dev/null 2>&1; then
  fzf_base=$(fzf-share)
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "${fzf_base}/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "${fzf_base}/key-bindings.zsh"
