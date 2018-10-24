autoload -Uz colors; colors

_update_prompt() {
    LANG=en_US.UTF-8 vcs_info

    local cwd=$(pwd | sed -e "s,^$HOME,~,")
    local p_cwd

    if git rev-parse 2> /dev/null; then
      local repo=$(git rev-parse --show-toplevel | sed -e "s,^$HOME,~," | sed -e "s,^~/src/\(github.com/\)\?,,")
      local path=$(git rev-parse --show-prefix | sed -e "s,/$,,")
      p_cwd="%{$fg_bold[yellow]%}${repo}%{$reset_color%} %{$fg[blue]%}/${path}%{$reset_color%}"
    else
      p_cwd="%{$fg[blue]%}${cwd}%{$reset_color%}"
    fi

    local p_st="%(?.%{$fg_bold[green]%}:).%{$fg_bold[red]%}:()%{$reset_color%} %# "
    local p_job="%(1j,%{$fg[red]%}%j job%(2j,s,)%{$reset_color%},)"

    PROMPT=$'\n'${p_cwd}\ ${p_job}$'\n'${p_st}
}

add-zsh-hook precmd _update_prompt
