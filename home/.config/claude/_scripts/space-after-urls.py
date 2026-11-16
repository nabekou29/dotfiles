#!/usr/bin/env python3
"""MessageDisplay hook: URL の直後に全角の括弧・句読点が続くとき、間に半角空白を入れて表示する。

Claude Code の Markdown レンダラ (marked の GFM 拡張 autolink) も herdr の URL 判定も、
URL を空白の手前まで延ばし、末尾からは ASCII の記号しか削らない。そのため
「https://example.com）を参照」は「）を参照」までリンクに含まれる。

書き換わるのは画面表示だけで、保存される会話や Claude が読む内容は変わらない。

URL の終わりとみなすのは、URL に生のまま現れない全角の括弧・句読点だけ。
かなや漢字が直接続く場合は、日本語を含む URL と区別できないので書き換えない。
"""

import json
import os
import re
import sys
import tempfile
import time
from pathlib import Path

URL = re.compile(r"https?://\S+")
DELIMITER = re.compile("[（）「」『』【】〔〕〈〉《》［］｛｝、。，．！？：；]")
# 中身は書き換えないが、URL を含んでいれば直後に空白を入れる範囲:
# コードスパン・Markdown リンク・autolink (<https://...>)。
# いずれも描画後は記号が消え、URL と後続の文字がつながって見える
PROTECTED = re.compile(
    r"(`+).*?\1"
    r"|!?\[[^\]]*\]\([^)]*\)"
    r"|<[A-Za-z][A-Za-z0-9+.-]*:[^\s<>]*>"
)
FENCE = re.compile(r"^\s*(`{3,}|~{3,})")

STATE_DIR = Path(tempfile.gettempdir()) / "claude-space-after-urls"
# 同じメッセージの hook は最大3つ並行して走るため、前の index の結果を待つ上限
WAIT_SECONDS = 1.0
STALE_SECONDS = 24 * 60 * 60


def space_after_urls_in_text(text: str) -> str:
    out = []
    pos = 0
    search_from = 0
    while m := URL.search(text, search_from):
        d = DELIMITER.search(m.group(0))
        if d is None:
            search_from = m.end()
            continue
        cut = m.start() + d.start()
        # 区切り文字の後ろに続く URL も拾うため、区切り文字から探し直す
        search_from = cut
        if text[m.start() : cut].endswith("://"):
            continue
        out.append(text[pos:cut])
        out.append(" ")
        pos = cut
    out.append(text[pos:])
    return "".join(out)


def space_after_urls_in_line(line: str) -> str:
    out = []
    pos = 0
    for m in PROTECTED.finditer(line):
        out.append(space_after_urls_in_text(line[pos : m.start()]))
        out.append(m.group(0))
        if "://" in m.group(0) and DELIMITER.match(line, m.end()):
            out.append(" ")
        pos = m.end()
    out.append(space_after_urls_in_text(line[pos:]))
    return "".join(out)


def transform(delta: str, fence: str | None) -> tuple[str, str | None]:
    out = []
    for line in delta.splitlines(keepends=True):
        m = FENCE.match(line)
        if fence is None:
            if m:
                fence = m.group(1)
            else:
                line = space_after_urls_in_line(line)
        elif m and line.strip() == m.group(1) and m.group(1)[0] == fence[0] and len(m.group(1)) >= len(fence):
            fence = None
        out.append(line)
    return "".join(out), fence


def load_state(path: Path, index: int) -> dict:
    """index 番目の flush 開始時点の状態を返す。前の flush の書き込みを待つ。"""
    if index == 0:
        return {"fence": None}
    deadline = time.monotonic() + WAIT_SECONDS
    while True:
        try:
            state = json.loads(path.read_text())
            if state.get("next") == index:
                return state
        except (FileNotFoundError, ValueError):
            pass
        if time.monotonic() > deadline:
            return {"unknown": True}
        time.sleep(0.005)


def save_state(path: Path, state: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    tmp = path.with_suffix(f".{os.getpid()}.tmp")
    tmp.write_text(json.dumps(state))
    os.replace(tmp, path)


def remove_stale_states() -> None:
    # 中断されたメッセージは final が来ず、状態ファイルが残る
    now = time.time()
    for p in STATE_DIR.glob("*"):
        try:
            if now - p.stat().st_mtime > STALE_SECONDS:
                p.unlink()
        except OSError:
            pass


def main() -> None:
    data = json.load(sys.stdin)
    delta: str = data.get("delta", "")
    index: int = data.get("index", 0)
    final: bool = data.get("final", False)
    path = STATE_DIR / f"{data.get('message_id', 'unknown')}.json"

    state = load_state(path, index)
    if state.get("unknown"):
        # 前の flush の状態が分からない (コードブロックの中かもしれない) ので、
        # このメッセージの残りは書き換えない
        output = delta
    else:
        output, fence = transform(delta, state.get("fence"))
        state = {"fence": fence}

    if final:
        path.unlink(missing_ok=True)
        remove_stale_states()
    else:
        save_state(path, {**state, "next": index + 1})

    if output != delta:
        json.dump(
            {"hookSpecificOutput": {"hookEventName": "MessageDisplay", "displayContent": output}},
            sys.stdout,
            ensure_ascii=False,
        )


if __name__ == "__main__":
    main()
