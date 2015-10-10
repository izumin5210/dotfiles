_register_keycommand() {
  zle -N $2
  bindkey "$1" $2
}

# ==== peco project ================================================================
peco_ghq_list() {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}

_register_keycommand '^]' peco_ghq_list


# ==== tmux attach ================================================================
tmux_attach() {
    local selected_session=$(tmux list-sessions | peco | awk -F: '{ print $1 }')
    if [ -n "$selected_session" ]; then
        title $selected_session
        BUFFER="tmux attach -t ${selected_session}"
        zle accept-line
    fi
    zle clear-screen
}

_register_keycommand '^[' tmux_attach


# ==== git status ===============================================================
git_status() {
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
        echo git status -sb
        git status -sb
    fi
    zle reset-prompt
}

_register_keycommand '^gs' git_status


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

_register_keycommand '^gp' git_patch
