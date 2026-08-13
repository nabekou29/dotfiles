#!/usr/bin/env bash
# chezmoi から mise bootstrap への移行時に一度だけ実行する。
# 旧 chezmoi のソースディレクトリを指す symlink を外して、mise が新しいリンクを張れるようにする。
# 実ファイルには触らないので、失敗しても設定内容が失われることはない。
set -euo pipefail
CHEZMOI_SRC="$HOME/.local/share/chezmoi"

count=0
while IFS= read -r -d '' link; do
  case "$(readlink "$link")" in
    "$CHEZMOI_SRC"/*)
      rm "$link"
      count=$((count + 1))
      echo "removed: $link"
      ;;
  esac
done < <({ find "$HOME" -maxdepth 1 -type l -print0
           find "$HOME/.config" "$HOME/.local/bin" "$HOME/bin" -type l -print0 2>/dev/null; } || true)

echo "migrate: removed $count links"

# chezmoi はディレクトリを実体で作り、その中のファイルだけを symlink していた。
# 上でリンクを外した結果空になったディレクトリを消して、mise がディレクトリ単位で
# symlink を張れるようにする。空でないものは実ファイルが残っているので触らない。
find "$HOME/.config" "$HOME/bin" -mindepth 1 -depth -type d -empty -delete 2>/dev/null || true
echo "migrate: pruned empty directories"
