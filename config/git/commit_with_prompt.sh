#! usr/bin/env zsh

# git commit をプロンプト用のテンプレを使って行うスクリプト
set -e

tmpfile=$(mktemp /tmp/git-commit-with-prompt.XXXXXX)

echo \
'# **Examples**\n'\
'# The following are the last 10 commit messages.'\
>> "$tmpfile"
# 過去10回のコミットメッセージをテンプレートに追加
git log -n 10 --pretty=format:"%s" | awk '{print "# - " $0}' >> "$tmpfile"
echo '' >> "$tmpfile"

# テンプレのテンプレ
template_path="$HOME/.config/git/commit_template_with_prompt.txt"

# テンプレが存在しない場合はエラー
if [ ! -f "$template_path" ]; then
  echo "Template file not found: $template_path"
  exit 1
fi

# テンプレートを一時ファイルにコピー
cat "$template_path" >> "$tmpfile"

# 終了時にテンプレートファイルを削除
trap 'rm -f "$tmpfile"' EXIT

# start commit
git commit -e -t "$tmpfile" -v

