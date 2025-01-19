#!/usr/bin/env bash

CACHE_DIR="/tmp/.zellij-cache"
mkdir -p "$CACHE_DIR"

# 引数のチェック
if [ $# -ne 2 ]; then
    echo "Usage: $0 <command> <duration>"
    exit 1
fi

COMMAND="$1"
CACHE_DURATION="$2"

HASH=$(echo -n "$COMMAND" | md5sum | awk '{print $1}')
CACHE_FILE="$CACHE_DIR/$HASH"
LAST_EXEC_FILE="$CACHE_FILE.last"

TIME_NOW=$(date +%s)
TIME_LAST=$(cat "$LAST_EXEC_FILE" 2>/dev/null || echo "0")

# キャッシュ期間が有効であればキャッシュを返す
if [ "$((TIME_LAST + CACHE_DURATION))" -gt "$TIME_NOW" ]; then
    cat "$CACHE_FILE"
    exit 0
fi

# コマンドを実行して結果をキャッシュ
RESULT=$($COMMAND)
echo "$RESULT" >"$CACHE_FILE"
echo "$TIME_NOW" >"$LAST_EXEC_FILE"

# 実行結果を出力
echo "$RESULT"
