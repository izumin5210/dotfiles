#!/usr/bin/env bash

set -e

dir=$(dirname "$0")

SLACK_BOT_TOKEN=${CLAUDE_CODE_HOOK_SLACK_BOT_TOKEN:-""}
SLACK_CHANNEL_ID=${CLAUDE_CODE_HOOK_SLACK_CHANNEL_ID:-""}
SLACK_POST_MESSAGE_URL="https://slack.com/api/chat.postMessage"

THREAD_TS_FILE="${dir}/tmp/thread_ts.txt"
LOG_FILE="${dir}/tmp/notify-slack.jsonl"

input=$(cat)
transcriptPath=$(echo $input | jq -r '.transcript_path')
sessionId=$(echo $input | jq -r '.session_id')
eventName=$(echo $input | jq -r '.hook_event_name')

threadTs=""

# get the thread timestamp if it exists
if [ -e "${THREAD_TS_FILE}" ]; then
  threadTs=$(cat "${THREAD_TS_FILE}" | grep "${sessionId}" | awk '{print $2}')
fi

# Log the input and transcript to a JSONL file
jq -r -n "{
  input: ${input},
  transcript: $(jq -n . ${transcriptPath}),
  thread_ts: \"${threadTs}\"
} | tostring" >>"${LOG_FILE}"

# create a new thread if it doesn't exist
if [[ -z "${threadTs}" ]]; then
  payload=$(jq -r -s ".[-1] | {
    channel: \"${SLACK_CHANNEL_ID}\",
    username: \"Claude Code\",
    icon_emoji: \":claude:\",
    blocks: [
      {
        type: \"section\",
        text: {
          type: \"mrkdwn\",
          text: \"New session started: ${sessionId}\"
        }
      },
      {
        type: \"context\",
        elements: [
          {
            type: \"plain_text\",
            text: .cwd | ltrimstr(\"$(ghq root)/\") | ltrimstr(\"github.com/\")
          },
          {
            type: \"plain_text\",
            text: \"session_id: ${sessionId}\"
          }
        ]
      }
    ]
  } | tostring" ${transcriptPath})
  res=$(curl -sfL \
    -H 'Content-Type: application/json' \
    -H "Authorization: Bearer ${SLACK_BOT_TOKEN}" \
    -d "${payload}" \
    -X POST \
    "${SLACK_POST_MESSAGE_URL}")
  threadTs=$(echo "${res}" | jq -r ".message.ts")
  echo "${sessionId} ${threadTs}" >>"${THREAD_TS_FILE}"
fi

payload=$(jq -r -s ".[-1] | {
  channel: \"${SLACK_CHANNEL_ID}\",
  thread_ts: \"${threadTs}\",
  username: \"Claude Code\",
  icon_emoji: \":claude:\",
  blocks: [
    {
      type: \"section\",
      text: {
        type: \"mrkdwn\",
        text: if .message.content[0].type == \"text\" then
                .message.content[0].text | gsub(\"(?<c>\`[^\`]*\`)\"; \" \\(.c) \")
              elif .message.content[0].type == \"tool_use\" and .message.content[0].name == \"exit_plan_mode\" then
                .message.content[0].input.plan | gsub(\"(?<c>\`[^\`]+\`)\"; \" \\(.c) \")
              else
                .message.content[0] | tostring | \"\`\`\`\n\" + . + \"\n\`\`\`\"
              end
      }
    },
    {
      type: \"context\",
      elements: [
        {
          type: \"mrkdwn\",
          text: \"\`\`\`\n\" + $(echo "$input" | jq ". | tostring") + \"\n\`\`\`\"
        }
      ]
    }
  ]
} | tostring" ${transcriptPath})

curl -sfL \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer ${SLACK_BOT_TOKEN}" \
  -d "${payload}" \
  -X POST \
  "${SLACK_POST_MESSAGE_URL}"
