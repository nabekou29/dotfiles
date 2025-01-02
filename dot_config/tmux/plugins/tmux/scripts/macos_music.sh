#!/usr/bin/env bash

str=$(osascript -e 'tell application "Music" to if player state is playing then name of current track & " - " & artist of current track')

if [ -n "$str" ]; then
    echo " $str"
else
    echo "󰝛"
fi
