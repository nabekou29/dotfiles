#!/usr/bin/env sh
filename=$1

$CURRENT_PROGPATH --server $CURRENT_SERVERNAME --remote "$filename"
