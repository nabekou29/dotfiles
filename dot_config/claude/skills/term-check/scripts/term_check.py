#!/usr/bin/env python3
"""term-check 機械層: 用語の抽出・照合・インベントリ生成。

python3 標準ライブラリのみで動くこと(どの開発マシンでも追加インストール不要)。
"""
import re

# camelCase / PascalCase / SNAKE / 連続大文字(HTTPServer)を単語に分解する
WORD_RE = re.compile(r"[A-Z]+(?![a-z])|[A-Z][a-z]+|[a-z]+|\d+")


def split_identifier(ident):
    return [w.lower() for w in WORD_RE.findall(ident) if not w.isdigit()]
