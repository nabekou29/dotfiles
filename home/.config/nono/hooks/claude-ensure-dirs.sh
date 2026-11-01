#!/usr/bin/env bash
# claude-base プロファイルの session_hooks.before。nono 公式の pack nolabs-ai/claude
# (v0.1.5 時点) の bin/ensure-dirs.sh から macOS 分を写したもの。
#
# プロファイルは TMPDIR を ~/.claude/tmp/claude-$UID に向けている。Claude Code は
# 自分の一時ディレクトリが symlink・他ユーザー所有・group/other から触れる状態だと
# 拒否するので、起動前に 700 で用意する。
# nono はこの hook より前に capability を解決するため、ここで作ったパスへの単独の
# 許可は今回のセッションには効かない。作るのは許可済みの ~/.claude の下に限る。
set -euo pipefail

ensure_private_dir() {
  local dir="$1"

  if [ -L "$dir" ]; then
    printf 'claude-ensure-dirs: refusing symlink: %s\n' "$dir" >&2
    return 1
  fi

  if [ ! -e "$dir" ]; then
    # 親は既にある前提。mkdir -p で想定外のツリーを作らない
    if ! mkdir -m 700 "$dir"; then
      # 別プロセスが先に作った場合は下の検査に任せる
      [ -e "$dir" ] || return 1
    fi
  fi

  if [ -L "$dir" ] || [ ! -d "$dir" ] || [ ! -O "$dir" ]; then
    printf 'claude-ensure-dirs: private directory must be a user-owned directory: %s\n' "$dir" >&2
    return 1
  fi

  # mkdir -m は既存ディレクトリのモードを直さない
  chmod 700 "$dir"
}

mkdir -p \
  "$HOME/.claude" \
  "$HOME/.cache/claude" \
  "$HOME/.local/state/claude/locks"

ensure_private_dir "$HOME/.claude/tmp"
ensure_private_dir "$HOME/.claude/tmp/claude-$UID"
