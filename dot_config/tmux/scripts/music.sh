#!/usr/bin/env bash
media_control="/opt/homebrew/bin/media-control"
jq="/opt/homebrew/bin/jq"

if [[ ! -x "$media_control" || ! -x "$jq" ]]; then
  echo "󰝛"
  exit 0
fi

jq_format='
def truncate(n): if length > n then .[0:(n-3)] + "..." else . end;

if .playing then
  " \(.title) - \(.artist)" | truncate(35)
else
  "󰝛"
end
'

result=$("$media_control" get -h | "$jq" -r "$jq_format" 2>/dev/null)

if [[ -n "$result" ]]; then
  echo "$result" | tr -s ' '
else
  echo "󰝛"
fi
