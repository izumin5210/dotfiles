# ==== peco project ================================================================
function _peco_project() {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco_project _peco_project
bindkey '^]' peco_project


# ==== git status ===============================================================
function _git_status() {
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
        echo git status -sb
        git status -sb
    fi
    zle reset-prompt
}
zle -N git_status _git_status
bindkey '^gs' git_status


# ==== git patch ================================================================
function _git_patch() {
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
zle -N git_patch _git_patch
bindkey '^gp' git_patch
