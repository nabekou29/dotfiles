#!/usr/bin/env bash

# Claude Code が Edit/Write したファイルを、別ウィンドウの trev で reveal する
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# cwd から trev インスタンスを特定して reveal する
trev ctl --workspace "${CWD:-$CLAUDE_PROJECT_DIR}" reveal "$FILE_PATH" 2>/dev/null &

exit 0
