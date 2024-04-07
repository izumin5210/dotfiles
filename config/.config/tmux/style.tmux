#!/usr/bin/env bash

set -eu

main() {
  # from https://github.com/catppuccin/tmux/blob/5ed4e8a/catppuccin-frappe.tmuxtheme#L4-L17
  # --> Catppuccin (Frappe)
  thm_bg="#303446"
  thm_fg="#c6d0f5"
  thm_cyan="#99d1db"
  thm_black="#292c3c"
  thm_gray="#414559"
  thm_magenta="#ca9ee6"
  thm_pink="#f4b8e4"
  thm_red="#e78284"
  thm_green="#a6d189"
  thm_yellow="#e5c890"
  thm_blue="#8caaee"
  thm_orange="#ef9f76"
  thm_black4="#626880"

  separator="#[fg=${thm_gray},bg=default,none]▕#[default]"

  tmux set -g message-command-style "align=right,fg=${thm_blue}"
  tmux set -g message-style "align=right,fg=${thm_blue},align=centre"
  tmux set -g pane-active-border-style "fg=${thm_black4}"
  tmux set -g pane-border-style "fg=${thm_black}"

  # status bar
  # ================================================
  tmux set -g status "on"
  tmux set -g status-position "top"
  tmux set -g status-justify "right"
  tmux set -g status-style "none"

  # left panel
  tmux set -g status-left-length 100
  tmux set -g status-left-style "none,fg=${thm_black4},align=right"

  show_git_repo_and_branch="cd #{pane_current_path} && git rev-parse --is-inside-work-tree >/dev/null 2>&1 && echo \"  \$(git info slug -s) ${separator}   \$(git info branch --max-len 24 --short) ${separator}\""
  #
  tmux set -g status-left " #S ${separator} #(${show_git_repo_and_branch})"

  # right panel
  tmux set -g status-right-style "none"
  tmux set -g status-right ""

  # window
  # ================================================
  tmux setw -g window-status-current-style "bold,fg=${thm_fg}"
  tmux setw -g window-status-activity-style "none,fg=${thm_black4}"
  tmux setw -g window-status-style "none,fg=${thm_black4}"
  tmux setw -g window-status-current-format "  #I #W ${separator}"
  tmux setw -g window-status-format "  #I #W ${separator}"
  tmux setw -g window-status-separator ""
}

main
