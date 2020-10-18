autoload -Uz colors; colors

_prompt_git_info() {
  # ref: https://joshdick.net/2017/06/08/my_git_prompt_for_zsh_revisited.html

  # Exit if not inside a Git repository
  ! git rev-parse --is-inside-work-tree > /dev/null 2>&1 && return

  # Git branch/tag, or name-rev if on detached head
  local GIT_LOCATION=${$(git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD)#(refs/heads/|tags/)}

  local AHEAD="%{$fg[red]%}⇡NUM%{$reset_color%}"
  local BEHIND="%{$fg[cyan]%}⇣NUM%{$reset_color%}"
  local MERGING="%{$fg[magenta]%}✖ %{$reset_color%}"
  local UNTRACKED="%{$fg[red]%}… %{$reset_color%}"
  local MODIFIED="%{$fg[yellow]%}✚ %{$reset_color%}"
  local STAGED="%{$fg[green]%}● %{$reset_color%}"
  local STASHED="%{$fg[cyan]%}⚑ %{$reset_color%}"

  local -a DIVERGENCES
  local -a FLAGS

  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
    DIVERGENCES+=( "${AHEAD//NUM/$NUM_AHEAD}" )
  fi

  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_BEHIND" -gt 0 ]; then
    DIVERGENCES+=( "${BEHIND//NUM/$NUM_BEHIND}" )
  fi

  local NUM_STASHED="$(git stash list 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_STASHED" -gt 0 ]; then
    FLAGS+=( "$STASHED" )
  fi

  if ! git diff --cached --quiet 2> /dev/null; then
    FLAGS+=( "$STAGED" )
  fi

  if ! git diff --quiet 2> /dev/null; then
    FLAGS+=( "$MODIFIED" )
  fi

  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    FLAGS+=( "$UNTRACKED" )
  fi

  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    FLAGS+=( "$MERGING" )
  fi

  local -a GIT_INFO
  GIT_INFO+=( "%{$fg[grey]%}-" )
  [ -n "$GIT_STATUS" ] && GIT_INFO+=( "$GIT_STATUS" )
  [[ ${#DIVERGENCES[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)DIVERGENCES}" )
  [[ ${#FLAGS[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)FLAGS}" )
  GIT_INFO+=( "%{$fg_bold[grey]%}$GIT_LOCATION%{$reset_color%}" )
  echo "${(j: :)GIT_INFO}"
}

_update_prompt() {
    local exitCode=$?
    if [ -z "${LAST_EXECUTED_COMMAND}" ]; then
      exitCode=0
    fi

    local cwd=$(pwd | sed -e "s,^$HOME,~,")
    local gitinfo=$(_prompt_git_info)

    local line_1
    local line_2

    if git rev-parse 2> /dev/null; then
      local repo=$(git rev-parse --show-toplevel | sed -e "s,^$HOME,~," | sed -e "s,^~/src/\(github.com/\)\?,,")
      local path=$(git rev-parse --show-prefix | sed -e "s,/$,,")
      line_1="%{$fg_bold[blue]%}${repo}%{$reset_color%} %{$fg[blue]%}/${path}%{$reset_color%} ${gitinfo}"
    else
      line_1="%{$fg[blue]%}${cwd}%{$reset_color%}"
    fi

    if [ -n "$(jobs)" ]; then
      line_1="${line_1} %{$fg[grey]%}- %(1j,%{$fg[red]%}%j job%(2j,s,)%{$reset_color%},)"
    fi

    # Wantedly
    if [ -n "${KUBE_FORK_TARGET_ENV}" ]; then
      line_1="${line_1} %{$fg[grey]%}- %{$fg[yellow]%}(fork: ${KUBE_FORK_TARGET_ENV})%{$reset_color%}"
    fi

    # signal
    if [ $exitCode -ne 0 ]; then
      local sig="SIG$(kill -l $exitCode)"
      if [[ $sig =~ "^SIG[0-9]*$" ]]; then
        sig="$exitCode"
      fi
      line_1="${line_1} %{$fg[grey]%}- $(printf "\e[31;2m%s\e[m" "$sig")"
    fi

    line_2="$([ $exitCode -eq 0 ] && echo "%{$fg[green]%}:)" || echo "%{$fg[red]%}:(")%{$reset_color%} %# "

    PROMPT=$'\n'${line_1}$'\n'${line_2}

    if [ -n "${LAST_EXECUTED_COMMAND}" ]; then
      unset LAST_EXECUTED_COMMAND
    fi
}

_prepare_prompt() {
  LAST_EXECUTED_COMMAND="${1}"
}

add-zsh-hook precmd _update_prompt
add-zsh-hook preexec _prepare_prompt
