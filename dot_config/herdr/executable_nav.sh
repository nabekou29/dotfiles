#!/usr/bin/env bash
# herdr ctrl+shift+{h,j,k,l} ディスパッチャ
#
# 現在 pane の foreground process が nvim 系なら、ctrl+shift+<key> を
# 当該 pane に送り返して nvim 側のキーマップに処理させる。
# それ以外なら herdr の pane focus を当該方向に動かす。
#
# Usage: nav.sh <left|down|up|right> <h|j|k|l>

set -u

dir="$1"
key="$2"

fg=$(herdr pane process-info --current 2>/dev/null \
  | jq -r '.result.process_info.foreground_processes[0].name // empty')

case "$fg" in
  nvim|neovim|vim)
    pane=$(herdr pane current --current 2>/dev/null | jq -r '.result.pane.pane_id')
    [ -n "$pane" ] && herdr pane send-keys "$pane" "ctrl+shift+$key"
    ;;
  *)
    herdr pane focus --direction "$dir" --current
    ;;
esac
