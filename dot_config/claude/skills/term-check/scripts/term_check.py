#!/usr/bin/env python3
"""term-check 機械層: 用語の抽出・照合・インベントリ生成。

python3 標準ライブラリのみで動くこと(どの開発マシンでも追加インストール不要)。
"""
import re
import subprocess
import sys
from pathlib import Path

# camelCase / PascalCase / snake_case / SCREAMING_SNAKE / 連続大文字(HTTPServer)を
# 単語に分解する。\d+ は数字を独立トークンとして切り出すためにあり、後段で捨てる
WORD_RE = re.compile(r"[A-Z]+(?![a-z])|[A-Z][a-z]+|[a-z]+|\d+")


def split_identifier(ident: str) -> list[str]:
    # 数字(v2 の 2 等)と 1 文字断片(getV2User の V 等)は用語にならないので捨てる
    return [w.lower() for w in WORD_RE.findall(ident) if not w.isdigit() and len(w) > 1]


def _git(*args):
    return subprocess.run(["git", *args], capture_output=True, text=True)


def normalize_remote(url: str) -> str:
    url = re.sub(r"\.git$", "", url.strip())
    m = re.match(r"(?:ssh://)?git@([^:/]+)[:/](.+)", url)
    if m:
        return f"{m.group(1)}/{m.group(2)}"
    m = re.match(r"https?://(?:[^/@]+@)?([^/]+)/(.+)", url)
    if m:
        return f"{m.group(1)}/{m.group(2)}"
    return "local/" + re.sub(r"[^\w.-]+", "_", url)


def repo_id() -> str:
    """worktree のどこから実行しても同一になるリポジトリ識別子。

    cwd パスは worktree ごとに変わるため使わない。origin が無ければ
    --git-common-dir(worktree でも main リポジトリの .git に解決される)から導出。
    """
    r = _git("remote", "get-url", "origin")
    if r.returncode == 0 and r.stdout.strip():
        return normalize_remote(r.stdout.strip())
    r = _git("rev-parse", "--git-common-dir")
    if r.returncode != 0:
        sys.exit("error: git リポジトリ内で実行すること")
    return "local/" + Path(r.stdout.strip()).resolve().parent.name
