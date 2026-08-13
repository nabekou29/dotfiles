#!/usr/bin/env bash
# 新マシンの初期セットアップ。brew と mise を用意して mise bootstrap に引き渡す。冪等。
set -euo pipefail
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"
command -v mise &>/dev/null || brew install mise

# profile (work/private) は mise の environments 機構で指定する。
# miserc.toml はマシン固有なので repo では管理しない (Brewfile もこの値を読む)。
MISERC="$HOME/.config/mise/miserc.toml"
if [ ! -s "$MISERC" ]; then
  read -rp "profile (work/private): " profile
  mkdir -p "$(dirname "$MISERC")"
  printf 'env = ["%s"]\n' "$profile" > "$MISERC"
fi

# mise bootstrap の最終ステップが ~/.zshenv を op inject で生成するため、
# 1Password CLI だけは Brewfile の適用を待たずに先に入れておく
command -v op &>/dev/null || brew install --cask 1password-cli

cd "$REPO_DIR"
# repo の設定を信頼しないと mise bootstrap が設定を読めない
mise trust
# dotfiles の配置・macOS 設定・ツール導入・[tasks.bootstrap] までを収束させる
mise bootstrap --yes

# Homebrew 6 以降はサードパーティ tap を明示的に信頼しないと formula を読み込めない
grep -oE '^tap "[^"]+"' "$HOME/.config/homebrew/Brewfile" | perl -pe 's/^tap "//; s/"$//' \
  | while read -r tap; do brew trust "$tap"; done
mise run packages

mise exec -- playwright install

echo "bootstrap: done"
# ツールの導入は ~/.zshenv 生成前に走るため MISE_GITHUB_TOKEN なしで GitHub API を叩く。
# レート制限で落ちたツールがあれば、トークンが載った新しいシェルで拾い直す。
echo "Note: 新しいターミナルを開いて 'mise install' を実行し、"
echo "      GitHub API のレート制限で入らなかったツールを回収する"
echo "Note: プロジェクトで nix dev shell を使う場合は Determinate Nix を入れる:"
echo "  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install"
