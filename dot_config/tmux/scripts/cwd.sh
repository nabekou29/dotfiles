#!/usr/bin/env bash
cwd="$1"
cwd="${cwd/#$HOME/\~}"

IFS='/' read -ra parts <<< "$cwd"
if [ "${#parts[@]}" -gt 3 ]; then
  echo "…/${parts[-2]}/${parts[-1]}"
else
  echo "$cwd"
fi
