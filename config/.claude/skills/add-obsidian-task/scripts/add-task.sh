#!/bin/bash
set -euo pipefail

# Usage: add-task.sh <title> <project> <context> <status> <content>
#   title   : Task title (must not contain /\:*?"<>|)
#   project : Project slug (e.g. dotfiles)
#   context : Context slug (e.g. work)
#   status  : One of: icebox, planned, in-progress
#   content : Markdown body of the task note

title="$1"
project="$2"
context="$3"
status="$4"
content="$5"

file=$(obsidian unique name="tasks/${project} - ${title}" content="${content}")

existing_tags=$(obsidian tags file="${file}" 2>/dev/null || echo "")
if [ -n "${existing_tags}" ]; then
    new_tags="${existing_tags} #task/ctx/${context} #task/pj/${project} #task/status/${status}"
else
    new_tags="#task/ctx/${context} #task/pj/${project} #task/status/${status}"
fi
obsidian property:set name="tags" type="list" value="${new_tags}" file="${file}"

if [ "${status}" = "planned" ]; then
    review_date=$(date -v+7d +%Y-%m-%d)
    obsidian property:set name="task_review_date" type="date" value="${review_date}" file="${file}"
fi

echo "${file}"
