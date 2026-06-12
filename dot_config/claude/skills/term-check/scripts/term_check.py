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
    # ポートは repo-id の一意性に寄与しないので捨てる。scp 形式(git@host:path)の
    # 「:」区切りと区別するため、ポートとみなすのは「:数字 + /」が続く場合のみ
    m = re.match(r"(?:ssh://)?git@([^:/]+)(?::\d+(?=/))?[:/](.+)", url)
    if m:
        return f"{m.group(1)}/{m.group(2)}"
    m = re.match(r"https?://(?:[^/@]+@)?([^/:]+)(?::\d+)?/(.+)", url)
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
        sys.exit(f"error: git リポジトリ内で実行すること({r.stderr.strip()})")
    return "local/" + Path(r.stdout.strip()).resolve().parent.name


# 文字列リテラル(" ' `)。エスケープ対応
STRING_RE = re.compile(r"([\"'`])(?:\\.|(?!\1).)*?\1")
# 行コメント・ブロックコメント開始(近似。行頭または空白の後のマーカーのみ)
COMMENT_RE = re.compile(r"(?:^|\s)(?://+|#+|--|/\*+|<!--)\s?(.*?)\s*(?:\*/|-->)?\s*$")
IDENT_RE = re.compile(r"[A-Za-z_][A-Za-z0-9_]*")
JA_RE = re.compile(r"[ぁ-んァ-ヶ一-龯々〆ー]+")

TEST_TITLE_RES = [
    re.compile(r"\b(?:it|test|describe|context)(?:\.\w+)?\s*\(\s*[\"'`](.+?)[\"'`]"),
    re.compile(r"\bt\.Run\(\s*\"(.+?)\""),
    re.compile(r"\bdef\s+(test_\w+)\s*\("),
    re.compile(r"\bfunc\s+(Test\w+)\s*\("),
]

# 言語横断のよくある予約語・組み込み型。用語としての価値が低いノイズを落とす
STOPWORDS = set(
    """
    if else elif end for while do done then fi return break continue switch case default
    func def fn function class struct interface enum type var let const val mut
    import from package namespace use using module export extern require include
    public private protected internal static final abstract override virtual
    async await yield new try catch finally throw throws raise except with as in of
    not and or is true false nil null none undefined void this self super
    int uint int32 int64 float float64 double bool boolean string str char byte rune
    any object map list dict set vec testing
    """.split()
)


def _mask_strings(line: str) -> str:
    """文字列リテラルの中身を同じ長さの '·' で潰す(位置を保つため同長)。"""
    return STRING_RE.sub(
        lambda m: m.group(1) + "·" * (len(m.group(0)) - 2) + m.group(1), line
    )


def extract_line(content: str) -> dict:
    """1 行からテストタイトル・コメント・識別子を抽出する(正規表現による近似)。"""
    titles = [t for pat in TEST_TITLE_RES for t in pat.findall(content)]
    masked = _mask_strings(content)
    comment = None
    code = masked
    m = COMMENT_RE.search(masked)
    if m:
        # マスクは同長なので、コメント本文は元の行の同じ位置から取れる
        text = re.sub(r"\s*(?:\*/|-->)\s*$", "", content[m.start(1):]).strip()
        comment = text or None
        code = masked[: m.start()]
    idents = [
        i
        for i in IDENT_RE.findall(code)
        if len(i) > 1 and i.strip("_") and i.lower() not in STOPWORDS
    ]
    return {"test_titles": titles, "comment": comment, "identifiers": idents}
