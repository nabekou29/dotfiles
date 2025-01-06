#!/usr/bin/env bash

truncate() {
    local input="$1"
    local max_length="$2"
    if [[ ${#input} -gt $max_length ]]; then
        echo "${input:0:max_length}…"
    else
        echo "$input"
    fi
}

title=$(nowplaying-cli get title)
artist=$(nowplaying-cli get artist)

title=$(truncate "$title" 20)
artist=$(truncate "$artist" 10)

if [[ -n "$title" && "$title" != "null" ]]; then
    result=" $title"
else
    result="󰝛"
fi

# 余裕があればアーティスト名も表示
if [[ ${#result} -lt 20 && -n "$artist" && "$artist" != "null" ]]; then
    result="$result - $artist"
fi

echo "$result"
