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

_peco_select() {
  local tx="$(cat)"
  local query="$1"

  if [ "$tx" = '' ]; then
    tx=' '
    query='(nothing)'
  fi

  peco --query "$query" <<< "$tx"
}

_reverse() {
  if which tac > /dev/null; then
    tac <<< $(cat)
  else
    tail -r <<< $(cat)
  fi
}

_is_git_repo() {
  git rev-parse --is-inside-work-tree > /dev/null 2>&1
}

_git_status_select() {
  _is_git_repo \
    && git status --short \
    | _peco_select \
    | cut -c 4- \
    | tr '\n' ' '
}

_git_branch_select() {
  _is_git_repo \
    && git branch \
    | _peco_select \
    | cut -c 3- \
    | tr '\n' ' '
}


# ==== replace_multiple_dots  ================================================================

replace_multiple_dots() {
  local dots=$LBUFFER[-2,-1]
  if [ "$dots" = ".." ]; then
    LBUFFER=$LBUFFER[1,-3]'../.'
  fi
  zle self-insert
}

_register_keycommand '.' replace_multiple_dots


# ==== peco project ================================================================
peco_ghq_list() {
  ghq list -p \
    | _peco_select \
    | {
        local repo=$(cat)
        if [ -n "$repo" ]; then
          _buffer_replace <<< "cd $repo"
          zle accept-line
        fi
      }
}

_register_keycommand '^]' peco_ghq_list


# ==== tmux attach ================================================================
tmux_attach() {
  tmux list-sessions \
    | _peco_select \
    | awk -F: '{ print $1 }' \
    | {
        local session=$(cat)
        if [ -n "$session" ]; then
          title $session
          _buffer_replace <<< "tmux attach -t $session"
          zle accept-line
        fi
      }
}

_register_keycommand '^@' tmux_attach


# ==== git status ===============================================================
git_status() {
  if _is_git_repo; then
    echo git status -sb
    git status -sb
  fi
  zle reset-prompt
}

_register_keycommand '^gs' git_status


# ==== git patch ================================================================
git_patch() {
  _git_status_select \
    | {
        local target="$(cat)"
        if [ -n "$target" ]; then
          _buffer_replace <<< "git add -p $target"
          zle accept-line
        fi
      }
}

_register_keycommand '^gp' git_patch


# ==== git add ================================================================
git_add() {
  _git_status_select \
    | {
        local target="$(cat)"
        if [ -n "$target" ]; then
          _buffer_replace <<< "git add $target"
          zle accept-line
        fi
      }
}

_register_keycommand '^ga' git_add


# ==== git reset ================================================================
git_reset() {
  _git_status_select \
    | {
        local target="$(cat)"
        if [ -n "$target" ]; then
          _buffer_replace <<< "git reset HEAD --quiet $target"
          zle accept-line
        fi
      }
}

_register_keycommand '^gr' git_reset


# ==== git reset ================================================================
git_checkout() {
  _git_branch_select \
    | {
        local target="$(cat)"
        if [ -n "$target" ]; then
          _buffer_replace <<< "git checkout $target"
          zle accept-line
        fi
      }
}

_register_keycommand '^gc' git_checkout


# ==== peco history ===============================================================
peco_history() {
  \history -n 1 \
    | _reverse \
    | _peco_select "$LBUFFER" \
    | _buffer_replace
}

_register_keycommand '^r' peco_history


# ==== pvim ===============================================================
pvim() {
  local target
  _is_git_repo \
    && git grep -n $1 \
    | _peco_select \
    | awk -F: '{ print $1 " +" $2 }' \
    | sed -e 's/\+$//' \
    | { target="$(cat)" }
  if [ -n "$target" ]; then
    vim $target
  fi
}


# ==== fixup with peco ===============================================================
fixup_with_peco() {
  git log \
    --oneline \
    --no-merges \
    --no-color \
    --date=short \
    --pretty="format:%h %ad %an%x09%s %d" \
    | _peco_select \
    | awk '{ print $1 }' \
    | {
      local target="$(cat)"
      if [ -n "$target" ]; then
        _buffer_replace <<< "git commit --fixup $target"
        zle accept-line
      fi
    }
}

_register_keycommand '^gf' fixup_with_peco


# ==== gibo_with_peco ===============================================================
gibo_with_peco() {
  gibo --list \
    | sed "/=/d" \
    | tr "\t", "\n" \
    | grep -v "^\s*$" \
    | sort \
    | _peco_select \
    | xargs gibo \
    >> .gitignore
}

_register_keycommand '^gi' gibo_with_peco


# ==== conda activate ===============================================================
conda_activate() {
  conda info -e \
    | tail -n +3 \
    | _peco_select \
    | {
        local row=$(cat)
        local targetpath=$(echo $row | awk '{ print $NF }')
        local targetname=$(echo $row | awk '{ print $1 }')
        if [ -n "$targetpath" ] && [ -n "$targetname" ]; then
          _buffer_replace <<< "source $targetpath/bin/activate $targetname"
          zle accept-line
        fi
      }
}

_register_keycommand '^ve' conda_activate
