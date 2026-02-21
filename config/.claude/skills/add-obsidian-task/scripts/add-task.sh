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

path="tasks"

tmpfile=$(obsidian unique name="${project} - ${title}")

obsidian move path="${tmpfile}" to="${path}"

file="${path}/$(basename "${tmpfile}")"

new_tags_json=$(obsidian properties file="${file}" format=json |
  jq -c --arg ctx "task/ctx/${context}" --arg pj "task/pj/${project}" --arg st "task/status/${status}" '
      def as_array:
        if . == null then []
        elif type == "array" then .
        elif type == "string" then [.]
        else []
        end;
      (.tags | as_array) + [$ctx, $pj, $st] | unique
    ')
obsidian property:set name="tags" type="list" value="${new_tags_json}" file="${file}"

if [ "${status}" = "planned" ]; then
  review_date=$(date -v+7d +%Y-%m-%d)
  obsidian property:set name="task_review_date" type="date" value="${review_date}" file="${file}"
fi

obsidian append file="${file}" content="# ${title}\n\nproject: [[${project}]]\n\n${content}"

echo "${file}"
