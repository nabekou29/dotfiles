#!/usr/bin/env python3
"""term-check 機械層: 用語の抽出・照合・インベントリ生成。

python3 標準ライブラリのみで動くこと(どの開発マシンでも追加インストール不要)。
"""
import argparse
import functools
import json
import os
import re
import subprocess
import sys
from collections import Counter
from datetime import datetime, timezone
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
# 日本語フレーズの抽出(inventory 生成と check で使う)
JA_RE = re.compile(r"[ぁ-んァ-ヶ一-龯々〆ー]+")

# ひらがな(助詞・送り仮名)で分割して漢字・カタカナの核を取り出すための部品
HIRAGANA_RE = re.compile(r"[ぁ-ん]+")
KANJI_KATA_RE = re.compile(r"[一-龯々〆ァ-ヶ]")


def _ja_terms_heuristic(run: str) -> list:
    """日本語の連続文字列 run からひらがな分割で漢字・カタカナ核を取り出す(近似)。

    「実長は」→「実長」、「としてカウントする」→「カウント」のように動く。
    核が取れない純ひらがな語(「ふりがな」等)は連続文字列をそのまま使う。
    既知の制限: 核が 1 文字しか取れない語(「超」「組み合わせ」等)は落ちる。
    """
    cores = [c for c in HIRAGANA_RE.split(run) if len(c) >= 2]
    if cores:
        return cores
    if len(run) >= 2 and not KANJI_KATA_RE.search(run):
        return [run]  # 純ひらがな語はそのまま
    return []


# 遅延シングルトン: False=未初期化 / None=利用不可 / それ以外=Tokenizer
_JA_TOKENIZER = False


def _ja_tokenizer():
    global _JA_TOKENIZER
    if _JA_TOKENIZER is False:
        try:
            from janome.tokenizer import Tokenizer
            _JA_TOKENIZER = Tokenizer()
        except ImportError:
            _JA_TOKENIZER = None
    return _JA_TOKENIZER


@functools.lru_cache(maxsize=100_000)
def _ja_terms_morph(run: str) -> tuple:
    """janome 形態素解析で run から名詞系用語を抽出する。

    連続する名詞系トークンを結合して複合語にする。品詞ルール(IPADIC):
    - バッファに積む:
        - 名詞(ただし 非自立・代名詞・数 は除く) — 一般・サ変接続・接尾・固有名詞 等を含む
        - 接頭詞(「生テキスト」の「生」等)
    - それ以外でバッファを flush: 結合文字列が 2 文字以上かつ名詞を 1 つ以上含む
      なら用語として採用する。接頭詞だけのバッファ(「超」単独 等)は落とす。
    戻り値は tuple(list → hashable にして lru_cache を使えるようにするため)。
    """
    tokenizer = _ja_tokenizer()
    if tokenizer is None:
        return tuple(_ja_terms_heuristic(run))

    # 積まない名詞の細分類
    NOUN_SKIP_SUB = {"非自立", "代名詞", "数"}

    terms = []
    buf = []       # (surface, is_noun) のリスト
    has_noun = False

    def flush():
        nonlocal has_noun
        if buf and has_noun:
            word = "".join(s for s, _ in buf)
            if len(word) >= 2:
                terms.append(word)
        buf.clear()
        has_noun = False

    for token in tokenizer.tokenize(run):
        pos_parts = token.part_of_speech.split(",")
        pos0 = pos_parts[0]
        pos1 = pos_parts[1] if len(pos_parts) > 1 else "*"

        if pos0 == "名詞" and pos1 not in NOUN_SKIP_SUB:
            buf.append((token.surface, True))
            has_noun = True
        elif pos0 == "接頭詞":
            # 接頭詞は次の名詞と結合するためバッファに積むが、名詞としてはカウントしない
            flush()  # 前のバッファを先に閉じる
            buf.append((token.surface, False))
        else:
            flush()

    flush()
    return tuple(terms)


def ja_terms(text: str) -> list:
    """テキストから日本語の用語候補を抽出するディスパッチャ。

    janome が利用可能なら形態素解析(_ja_terms_morph)で、
    そうでなければひらがな分割の近似(_ja_terms_heuristic)で各 run を処理する。
    """
    terms = []
    for run in JA_RE.findall(text):
        tokenizer = _ja_tokenizer()
        if tokenizer is not None:
            terms += list(_ja_terms_morph(run))
        else:
            terms += _ja_terms_heuristic(run)
    return terms

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
    """1 行からテストタイトル・コメント・識別子を抽出する(正規表現による近似)。

    既知の制限: 行中間の `/* ... */ コード` はコメント開始以降が全てコメント扱いに
    なる(後続コードの識別子を取りこぼす)。床除算 `a // b` もコメント扱いになる。
    """
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


def parse_diff(text: str) -> dict:
    """unified diff → {path: [(新ファイルでの行番号, 追加行の内容), ...]}。追加行のみ。"""
    files, current, lineno = {}, None, 0
    for raw in text.splitlines():
        if raw.startswith("+++ "):
            path = raw[4:].split("\t")[0].strip()
            current = None if path == "/dev/null" else re.sub(r"^b/", "", path)
            if current is not None:
                files.setdefault(current, [])
            lineno = 0  # 防御: hunk ヘッダなしで + 行が来ても前ファイルの行番号を引き継がない
        elif raw.startswith("@@"):
            m = re.search(r"\+(\d+)", raw)
            lineno = int(m.group(1)) if m else 0
        elif current is None:
            continue
        elif raw.startswith("+"):
            files[current].append((lineno, raw[1:]))
            lineno += 1
        elif raw.startswith(" "):
            lineno += 1
    return files


def filename_words(path: str) -> list:
    """ファイルパスの basename を単語化する。

    ドット区切りの末尾連続部分(.go / .test.ts / .min.js 等)は拡張子・
    種別マーカーとみなして丸ごと落とす。
    """
    stem = re.sub(r"(\.[A-Za-z0-9]+)+$", "", Path(path).name)
    words = []
    for part in re.split(r"[-._ ]+", stem):
        words += split_identifier(part)
    return words


def extract(files: dict) -> dict:
    """parse_diff の結果からチェック対象要素を位置つきで集約する。"""
    out = {
        "filenames": sorted(files),
        "identifiers": [],
        "comments": [],
        "test_titles": [],
    }
    for path, lines in files.items():
        for ln, content in lines:
            got = extract_line(content)
            for t in got["test_titles"]:
                out["test_titles"].append({"file": path, "line": ln, "text": t})
            if got["comment"]:
                out["comments"].append({"file": path, "line": ln, "text": got["comment"]})
            for ident in got["identifiers"]:
                out["identifiers"].append(
                    {"file": path, "line": ln, "ident": ident, "words": split_identifier(ident)}
                )
    return out


STATE_ROOT = (
    Path(os.environ.get("XDG_STATE_HOME", str(Path.home() / ".local/state")))
    / "claude"
    / "glossary"
)

SKIP_PARTS = {"node_modules", "vendor", "dist", "build", ".git", "generated", "__pycache__"}
SKIP_SUFFIXES = (
    ".png", ".jpg", ".jpeg", ".gif", ".svg", ".ico", ".woff", ".woff2",
    ".ttf", ".pdf", ".lock", ".sum", ".map", ".min.js", ".snap", ".csv", ".jsonl",
)


def _should_skip(path: str) -> bool:
    """ファイルパスをスキップすべきか判定する(純粋関数)。

    node_modules, vendor, dist などの特定ディレクトリ、
    およびバイナリ・メディア・ロック・ビルド生成物を対象外にする。
    """
    if SKIP_PARTS & set(Path(path).parts):
        return True
    return path.endswith(SKIP_SUFFIXES)


def glossary_dir() -> Path:
    return STATE_ROOT / repo_id()


def _load_json(path: Path, default):
    if not path.exists():
        return default
    try:
        return json.loads(path.read_text())
    except json.JSONDecodeError as e:
        sys.exit(f"error: {path} が不正な JSON: {e}")


def inventory_from_texts(texts) -> dict:
    """{path: 中身} の dict または (path, 中身) ペアの iterable から
    単語・日本語フレーズの出現カウントを作る(純粋関数)。
    """
    pairs = texts.items() if isinstance(texts, dict) else texts
    words, ja = Counter(), Counter()
    for path, text in pairs:
        for w in filename_words(path):
            words[w] += 1
        for line in text.splitlines():
            got = extract_line(line)
            for ident in got["identifiers"]:
                for w in split_identifier(ident):
                    words[w] += 1
            sources = got["test_titles"] + ([got["comment"]] if got["comment"] else [])
            for src in sources:
                for phrase in ja_terms(src):
                    ja[phrase] += 1
    return {"words": dict(words), "ja": dict(ja)}


def iter_repo_texts(ref=None):
    """git 管理下のテキストファイルを (相対path, 中身) で列挙する。

    ref=None: 作業ツリー(ls-files)から読む。
    ref が指定された場合は ref(ブランチ・コミット等)のファイル群を対象にする。
    diff チェックで自分の追加分を inventory に取り込んでしまい新出ワード判定から
    漏れる事故を防ぐため、base ブランチを指定する用途を想定している。

    cwd がリポジトリのサブディレクトリでも全体を対象にするため、
    ルートを解決してルート基準で読む。
    """
    r = _git("rev-parse", "--show-toplevel")
    if r.returncode != 0:
        sys.exit(f"error: git リポジトリ内で実行すること({r.stderr.strip()})")
    top = Path(r.stdout.strip())
    if ref is None:
        r = _git("-C", str(top), "ls-files")
        if r.returncode != 0:
            sys.exit(f"error: git ls-files 失敗({r.stderr.strip()})")
        for path in r.stdout.splitlines():
            if _should_skip(path):
                continue
            try:
                text = (top / path).read_text(errors="ignore")
            except OSError:
                continue
            if len(text) > 1_000_000 or "\0" in text[:1000]:
                continue
            yield path, text
    else:
        # ref のファイル群を 1 プロセスで取り出す。ファイルごとに git show を呼ぶと
        # 数万ファイル規模で著しく遅くなるため、git archive で tar に固めて stream 解凍する。
        import io
        import tarfile
        r = subprocess.run(
            ["git", "-C", str(top), "archive", "--format=tar", ref],
            capture_output=True,
        )
        if r.returncode != 0:
            sys.exit(f"error: git archive {ref} 失敗({r.stderr.decode(errors='ignore').strip()})")
        with tarfile.open(fileobj=io.BytesIO(r.stdout), mode="r|") as tar:
            for member in tar:
                if not member.isfile() or _should_skip(member.name):
                    continue
                f = tar.extractfile(member)
                if f is None:
                    continue
                try:
                    text = f.read().decode("utf-8", errors="ignore")
                except Exception:
                    continue
                if len(text) > 1_000_000 or "\0" in text[:1000]:
                    continue
                yield member.name, text


def run_check(ext: dict, glossary: dict, inventory: dict) -> dict:
    """抽出結果を glossary / inventory と照合する(純粋関数)。"""
    avoid_en, avoid_ja = {}, []
    for t in glossary.get("terms", []):
        for a in t.get("avoid", []):
            avoid_en[a.lower()] = t
        for a in t.get("avoid_ja", []):
            avoid_ja.append((a, t))

    violations = []

    def hit(words, file, line, src, kind):
        for w in words:
            t = avoid_en.get(w)
            if t:
                violations.append(
                    {"file": file, "line": line, "src": src, "kind": kind, "word": w, "term": t}
                )

    for it in ext["identifiers"]:
        hit(it["words"], it["file"], it["line"], it["ident"], "identifier")
    for sec, kind in (("comments", "comment"), ("test_titles", "test_title")):
        for it in ext[sec]:
            en = [w for i in IDENT_RE.findall(it["text"]) for w in split_identifier(i)]
            hit(en, it["file"], it["line"], it["text"], kind)
            for a, t in avoid_ja:
                if a in it["text"]:
                    violations.append(
                        {"file": it["file"], "line": it["line"], "src": it["text"],
                         "kind": kind, "word": a, "term": t}
                    )

    # glossary の term 構成語も既知扱い(term は snake_case 等の複合語でありうる)。
    # inventory にまだ無くても、glossary に正として登録済みの語を「新出」と騒がないため無条件に加える
    known = set(inventory.get("words", {}))
    for t in glossary.get("terms", []):
        if t.get("term"):
            known.update(split_identifier(t["term"]))
    new_words = {}

    def note_new(w, file, line):
        if w in known or w in avoid_en or len(w) < 3:
            return
        e = new_words.setdefault(w, {"count": 0, "first": f"{file}:{line}"})
        e["count"] += 1

    for it in ext["identifiers"]:
        for w in it["words"]:
            note_new(w, it["file"], it["line"])
    for path in ext["filenames"]:
        for w in filename_words(path):
            note_new(w, path, 0)

    known_ja = set(inventory.get("ja", {}))
    diff_ja = Counter()
    for sec in ("comments", "test_titles"):
        for it in ext[sec]:
            for ph in ja_terms(it["text"]):
                diff_ja[ph] += 1
    new_ja = {p: c for p, c in diff_ja.items() if p not in known_ja}

    return {
        "violations": violations,
        "new_words": new_words,
        "ja_phrases": dict(diff_ja),
        "new_ja": new_ja,
    }


def render_report(ext: dict, result: dict, meta: str) -> str:
    """check 結果をマークダウン形式でレポートする。"""
    lines = ["# term-check レポート", meta, ""]
    v = result["violations"]
    lines.append(f"## 1. 決定的違反 ({len(v)} 件)")
    for x in v:
        t = x["term"]
        canon = t.get("term") or t.get("ja", "")
        note = f" — {t['note']}" if t.get("note") else ""
        lines.append(
            f"- {x['file']}:{x['line']} [{x['kind']}] `{x['src']}` の「{x['word']}」 → 正: **{canon}**{note}"
        )
    lines.append("")
    nw = result["new_words"]
    lines.append(f"## 2. 新出ワード ({len(nw)} 件) — inventory/glossary に無い英単語")
    for w, e in sorted(nw.items(), key=lambda kv: -kv[1]["count"]):
        lines.append(f"- {w} ×{e['count']} (初出 {e['first']})")
    lines.append("")
    nj = result["new_ja"]
    lines.append(f"## 2b. 新出日本語フレーズ ({len(nj)} 件)")
    for p, c in sorted(nj.items(), key=lambda kv: -kv[1]):
        lines.append(f"- {p} ×{c}")
    lines.append("")
    lines.append("## 3. 抽出サマリ(概念一貫性チェック用)")
    lines.append("### 変更ファイル")
    lines += [f"- {f}" for f in ext["filenames"]]
    lines.append("### 識別子(追加行)")
    lines += [f"- {i['file']}:{i['line']} {i['ident']}" for i in ext["identifiers"]]
    lines.append("### コメント")
    lines += [f"- {c['file']}:{c['line']} {c['text']}" for c in ext["comments"]]
    lines.append("### テストタイトル")
    lines += [f"- {t['file']}:{t['line']} {t['text']}" for t in ext["test_titles"]]
    return "\n".join(lines)


def lookup_word(word: str, glossary: dict, inventory: dict) -> dict:
    """1 語について inventory での頻度・近い既存語・glossary ヒットを返す(純粋関数)。"""
    if JA_RE.fullmatch(word):
        count = inventory.get("ja", {}).get(word, 0)
        related = [
            (p, c) for p, c in inventory.get("ja", {}).items() if word in p and p != word
        ]
    else:
        w = word.lower()
        count = inventory.get("words", {}).get(w, 0)
        # 4 文字未満の語は語全体を前方一致に使う(4 文字フロアより広めに当たるが頻度上位 8 件で抑える)
        prefix = w[:4]
        related = [
            (p, c)
            for p, c in inventory.get("words", {}).items()
            if p != w and (p.startswith(prefix) or w.startswith(p[:4]))
        ]
    related = sorted(related, key=lambda x: -x[1])[:8]
    hits = []
    for t in glossary.get("terms", []):
        en = [t.get("term", "").lower()] + [a.lower() for a in t.get("avoid", [])]
        ja = [t.get("ja", "")] + t.get("avoid_ja", [])
        if word.lower() in en or word in ja:
            hits.append(t)
    return {"count": count, "related": related, "glossary_hits": hits}


def cmd_lookup(args):
    """語を inventory / glossary と突き合わせて表示する。"""
    d = glossary_dir()
    glossary = _load_json(d / "glossary.json", {"terms": []})
    inventory = _load_json(d / "inventory.json", {"words": {}, "ja": {}})
    for word in args.words:
        got = lookup_word(word, glossary, inventory)
        print(f"## {word}")
        print(f"inventory: {got['count']} 回")
        if got["related"]:
            print("近い既存語: " + ", ".join(f"{p}({c})" for p, c in got["related"]))
        for t in got["glossary_hits"]:
            print(f"glossary: {json.dumps(t, ensure_ascii=False)}")
        print()


def cmd_check(args):
    """stdin の diff をチェックしてレポートを出力する。"""
    diff = sys.stdin.read()
    if not diff.strip():
        sys.exit("error: stdin に diff を渡すこと(例: git diff main...HEAD | term_check.py check)")
    d = glossary_dir()
    glossary = _load_json(d / "glossary.json", {"terms": []})
    inventory = _load_json(d / "inventory.json", {"words": {}, "ja": {}})
    warn = "" if inventory.get("words") else "\n⚠ inventory が空。先に `term_check.py inventory` を実行すること"
    ext = extract(parse_diff(diff))
    result = run_check(ext, glossary, inventory)
    meta = (
        f"repo: {repo_id()} / glossary: {len(glossary.get('terms', []))} terms / "
        f"inventory: {len(inventory.get('words', {}))} words{warn}"
    )
    print(render_report(ext, result, meta))


def cmd_inventory(args):
    d = glossary_dir()
    d.mkdir(parents=True, exist_ok=True)
    inv = inventory_from_texts(iter_repo_texts(ref=args.ref))
    inv["generated_at"] = datetime.now(timezone.utc).astimezone().isoformat(timespec="seconds")
    if args.ref:
        inv["source_ref"] = args.ref
    out = d / "inventory.json"
    tmp = out.with_suffix(".json.tmp")
    tmp.write_text(json.dumps(inv, ensure_ascii=False))
    os.replace(tmp, out)
    src = f" (ref: {args.ref})" if args.ref else ""
    print(f"inventory: {len(inv['words'])} words / {len(inv['ja'])} ja phrases → {out}{src}")


def cmd_paths(args):
    d = glossary_dir()
    g, inv = d / "glossary.json", d / "inventory.json"
    print(f"repo_id: {repo_id()}")
    print(f"dir: {d}")
    print(f"glossary: {g if g.exists() else '(未作成)'}")
    print(f"inventory: {inv if inv.exists() else '(未作成)'}")


def main():
    ap = argparse.ArgumentParser(prog="term_check")
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("paths", help="repo-id とデータファイルの場所を表示")
    inv_p = sub.add_parser("inventory", help="リポジトリ全体から語彙インベントリを再生成")
    inv_p.add_argument(
        "--ref",
        default=None,
        help="作業ツリーではなく指定 ref のファイル群から抽出する (例: origin/main)。"
        "diff チェック時に現在ブランチの追加分が既存扱いされて新出ワード判定から漏れる事故を防ぐ。",
    )
    sub.add_parser("check", help="stdin の diff をチェックしてレポートを出力")
    lk = sub.add_parser("lookup", help="語を inventory / glossary と突き合わせる(計画時の命名確認)")
    lk.add_argument("words", nargs="+")
    args = ap.parse_args()
    {"paths": cmd_paths, "inventory": cmd_inventory, "check": cmd_check, "lookup": cmd_lookup}[args.cmd](args)


if __name__ == "__main__":
    main()
