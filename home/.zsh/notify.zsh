
if [ -z "${SLACK_WEBHOOK_URL+x}" ]; then
  echo "SLACK_WEBHOOK_URL is empty !!!"
fi

if [ -z "${SLACK_USER_NAME+x}" ]; then
  echo "SLACK_USER_NAME is empty !!!"
fi

function notify_preexec {
  notif_prev_executed_at=`date`
  notif_prev_command=$2
}

function notify_precmd {
  notif_status=$?
  if [ -n "${SLACK_WEBHOOK_URL+x}" ] && [ -n "${SLACK_USER_NAME+x}" ] && [ $TTYIDLE -gt ${SLACK_NOTIF_THRESHOLD:-180} ]; then
    notif_title=$([ $notif_status -eq 0 ] && echo "Command succeeded :ok_woman:" || echo "Command failed :no_good:")
    notif_color=$([ $notif_status -eq 0 ] && echo "good" || echo "danger")
    notif_icon=$([ $notif_status -eq 0 ] && echo ":angel:" || echo ":smiling_imp:")
    payload=`cat << EOS
{
  "username": "command result",
  "icon_emoji": "$notif_icon",
  "text": "<@$SLACK_USER_NAME>",
  "attachments": [
    {
      "color": "$notif_color",
      "title": "$notif_title",
      "fields": [
        {
          "title": "command",
          "value": "$notif_prev_command",
          "short": false
        },
        {
          "title": "directory",
          "value": "$(pwd)",
          "short": false
        },
        {
          "title": "hostname",
          "value": "$(hostname)",
          "short": true
        },
        {
          "title": "user",
          "value": "$(whoami)",
          "short": true
        },
        {
          "title": "executed at",
          "value": "$notif_prev_executed_at",
          "short": true
        },
        {
          "title": "elapsed time",
          "value": "$TTYIDLE seconds",
          "short": true
        }
      ]
    }
  ]
}
EOS
`
    curl --request POST \
      --header 'Content-type: application/json' \
      --data "$(echo $payload | tr '\n' ' ' | tr -s ' ')" \
      $SLACK_WEBHOOK_URL
  fi
}

add-zsh-hook preexec notify_preexec
add-zsh-hook precmd notify_precmd
