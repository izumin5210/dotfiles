# ==== peco project ================================================================
peco_ghq_list() {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco_ghq_list
bindkey '^gs' peco_ghq_list


# ==== git status ===============================================================
git_status() {
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
        echo git status -sb
        git status -sb
    fi
    zle reset-prompt
}
zle -N git_status
bindkey '^gs' git_status


# ==== git patch ================================================================
git_patch() {
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
        local selected_file='$(git status --porcelain | peco --query "$LBUFFER")'
        if [ -n "$selected_file" ]; then
            BUFFER="git add -p ${selected_file}"
            zle accept-line
        fi
        zle clear-screen
    else
        zle reset-prompt
    fi
}
zle -N git_patch
bindkey '^gp' git_patch
