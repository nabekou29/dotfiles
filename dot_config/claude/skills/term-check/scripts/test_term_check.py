import tempfile
import unittest
from pathlib import Path

try:
    import janome  # noqa: F401
    HAS_JANOME = True
except ImportError:
    HAS_JANOME = False

from term_check import (
    _ja_terms_heuristic,
    _resolve_state_dir,
    extract,
    extract_line,
    filename_words,
    inventory_from_texts,
    ja_terms,
    lookup_word,
    normalize_remote,
    parse_diff,
    run_check,
    split_identifier,
    _should_skip,
)


class JaTermsHeuristicTest(unittest.TestCase):
    """_ja_terms_heuristic は run(JA_RE でマッチした連続日本語文字列)単位で動く。"""

    def test_strips_particles(self):
        self.assertEqual(_ja_terms_heuristic("送料は"), ["送料"])

    def test_extracts_cores_from_mixed_run(self):
        # run 単位なので「// 生データの最大件数は10,000レコード」は複数 run に分かれる
        self.assertEqual(_ja_terms_heuristic("生データの最大件数は"), ["生データ", "最大件数"])
        self.assertEqual(_ja_terms_heuristic("レコード"), ["レコード"])

    def test_katakana_core_in_hiragana_context(self):
        self.assertEqual(_ja_terms_heuristic("としてカウントする"), ["カウント"])

    def test_pure_hiragana_word_kept(self):
        self.assertEqual(_ja_terms_heuristic("ふりがな"), ["ふりがな"])

    def test_one_char_core_fragments_dropped(self):
        # 核が 1 文字しか取れない断片(「超」等)は用語にしない
        self.assertEqual(_ja_terms_heuristic("超でも"), [])


@unittest.skipUnless(HAS_JANOME, "janome がインストールされていない環境ではスキップ")
class JaTermsMorphTest(unittest.TestCase):
    def test_okurigana_compounds_survive(self):
        got = ja_terms("ファイルの読み込みと書き込み")
        self.assertIn("読み込み", got)
        self.assertIn("書き込み", got)
        self.assertIn("ファイル", got)

    def test_compound_with_prefix(self):
        got = ja_terms("生データの最大件数")
        self.assertIn("生データ", got)
        self.assertIn("最大件数", got)

    def test_consecutive_nouns_joined(self):
        got = ja_terms("送料は 500 超でも注文合計金額 5000 以内なら OK")
        self.assertIn("送料", got)
        self.assertIn("注文合計金額", got)

    def test_verbs_and_connectives_dropped(self):
        got = ja_terms("そこで先読みを使う")
        self.assertIn("先読み", got)
        self.assertNotIn("そこで", got)
        self.assertNotIn("使う", got)

    def test_kanji_compound(self):
        got = ja_terms("権限の組み合わせを検証")
        self.assertIn("組み合わせ", got)
        self.assertIn("権限", got)
        self.assertIn("検証", got)

    def test_cancel_compound(self):
        got = ja_terms("予約の取り消し")
        self.assertIn("予約", got)
        self.assertIn("取り消し", got)

    def test_verb_not_extracted(self):
        got = ja_terms("在庫数を数える")
        self.assertIn("在庫数", got)
        self.assertNotIn("数える", got)


class SplitIdentifierTest(unittest.TestCase):
    def test_camel_case(self):
        self.assertEqual(
            split_identifier("EffectiveMessageLength"),
            ["effective", "message", "length"],
        )

    def test_snake_case(self):
        self.assertEqual(split_identifier("sign_up_user"), ["sign", "up", "user"])

    def test_consecutive_upper(self):
        self.assertEqual(split_identifier("HTTPServer"), ["http", "server"])

    def test_trailing_upper(self):
        self.assertEqual(split_identifier("userID"), ["user", "id"])

    def test_digits_dropped(self):
        self.assertEqual(split_identifier("base64Encode"), ["base", "encode"])

    def test_screaming_snake_case(self):
        self.assertEqual(split_identifier("MAX_RETRY_COUNT"), ["max", "retry", "count"])

    def test_single_letter_fragments_dropped(self):
        self.assertEqual(split_identifier("getV2User"), ["get", "user"])


class NormalizeRemoteTest(unittest.TestCase):
    def test_scp_style_ssh(self):
        self.assertEqual(
            normalize_remote("git@github.com:org/repo.git"), "github.com/org/repo"
        )

    def test_https(self):
        self.assertEqual(
            normalize_remote("https://github.com/org/repo.git"), "github.com/org/repo"
        )

    def test_https_without_dot_git(self):
        self.assertEqual(
            normalize_remote("https://github.com/org/repo"), "github.com/org/repo"
        )

    def test_ssh_protocol(self):
        self.assertEqual(
            normalize_remote("ssh://git@github.com/org/repo.git"),
            "github.com/org/repo",
        )

    def test_https_with_port(self):
        self.assertEqual(
            normalize_remote("https://github.example.com:8443/org/repo.git"),
            "github.example.com/org/repo",
        )

    def test_ssh_with_port(self):
        self.assertEqual(
            normalize_remote("ssh://git@github.com:22/org/repo.git"),
            "github.com/org/repo",
        )


class ExtractLineTest(unittest.TestCase):
    def test_identifiers_from_code(self):
        got = extract_line("const itemCount = countItems(order)")
        self.assertEqual(got["identifiers"], ["itemCount", "countItems", "order"])

    def test_string_contents_excluded(self):
        got = extract_line('setMessage("ようこそ retrieveUser さん")')
        self.assertEqual(got["identifiers"], ["setMessage"])

    def test_comment_extracted(self):
        got = extract_line("x = 1  # 在庫数を数える")
        self.assertEqual(got["comment"], "在庫数を数える")

    def test_slash_comment(self):
        got = extract_line("return n // 送料を返す")
        self.assertEqual(got["comment"], "送料を返す")
        self.assertEqual(got["identifiers"], [])

    def test_no_comment(self):
        self.assertIsNone(extract_line("const a = b")["comment"])

    def test_test_title_js(self):
        got = extract_line('it("送料を合計金額に加算する", () => {')
        self.assertEqual(got["test_titles"], ["送料を合計金額に加算する"])

    def test_test_title_go(self):
        got = extract_line('func TestOrderTotal(t *testing.T) {')
        self.assertEqual(got["test_titles"], ["TestOrderTotal"])

    def test_test_title_go_subtest(self):
        got = extract_line('t.Run("クーポンを含む場合", func(t *testing.T) {')
        self.assertEqual(got["test_titles"], ["クーポンを含む場合"])

    def test_test_title_pytest(self):
        got = extract_line("def test_order_total_with_coupon():")
        self.assertEqual(got["test_titles"], ["test_order_total_with_coupon"])

    def test_stopwords_filtered(self):
        got = extract_line("if err != nil { return err }")
        self.assertEqual(got["identifiers"], ["err", "err"])


SAMPLE_DIFF = """\
diff --git a/internal/order/validator.go b/internal/order/validator.go
index 1234567..89abcde 100644
--- a/internal/order/validator.go
+++ b/internal/order/validator.go
@@ -10,2 +10,3 @@ func Validate(order string) error {
 \tif order == "" {
+\t\titemCount := countItems(order) // 商品数を数える
 \t\treturn nil
diff --git a/internal/order/total_test.go b/internal/order/total_test.go
new file mode 100644
--- /dev/null
+++ b/internal/order/total_test.go
@@ -0,0 +1,2 @@
+func TestItemCount(t *testing.T) {
+\tt.Run("クーポンを含む場合", func(t *testing.T) {})
"""


class ParseDiffTest(unittest.TestCase):
    def test_added_lines_with_numbers(self):
        files = parse_diff(SAMPLE_DIFF)
        self.assertEqual(
            files["internal/order/validator.go"],
            [(11, "\t\titemCount := countItems(order) // 商品数を数える")],
        )

    def test_new_file(self):
        files = parse_diff(SAMPLE_DIFF)
        self.assertEqual(len(files["internal/order/total_test.go"]), 2)


class ExtractTest(unittest.TestCase):
    def test_aggregates_with_locations(self):
        got = extract(parse_diff(SAMPLE_DIFF))
        idents = [(i["file"], i["line"], i["ident"]) for i in got["identifiers"]]
        self.assertIn(
            ("internal/order/validator.go", 11, "itemCount"), idents
        )
        comments = [(c["line"], c["text"]) for c in got["comments"]]
        self.assertIn((11, "商品数を数える"), comments)
        titles = [t["text"] for t in got["test_titles"]]
        self.assertIn("TestItemCount", titles)
        self.assertIn("クーポンを含む場合", titles)
        self.assertIn("internal/order/total_test.go", got["filenames"])


class FilenameWordsTest(unittest.TestCase):
    def test_kebab_and_multi_extension(self):
        # .test.ts のような多段拡張子は丸ごと落とす(test はファイル種別マーカーで用語でない)
        self.assertEqual(
            filename_words("src/shipping-fee_calculator.test.ts"),
            ["shipping", "fee", "calculator"],
        )

    def test_no_extension_keeps_short_words(self):
        self.assertEqual(filename_words("docs/user-api"), ["user", "api"])


class ResolveStateDirTest(unittest.TestCase):
    RID = "github.com/org/repo"

    def test_migrates_legacy_dir(self):
        with tempfile.TemporaryDirectory() as tmp:
            root, legacy_root = Path(tmp) / "term-check", Path(tmp) / "claude" / "glossary"
            (legacy_root / self.RID).mkdir(parents=True)
            (legacy_root / self.RID / "glossary.json").write_text("{}")
            got = _resolve_state_dir(root, legacy_root, self.RID)
            self.assertEqual(got, root / self.RID)
            self.assertTrue((got / "glossary.json").exists())
            self.assertFalse((legacy_root / self.RID).exists())

    def test_new_location_wins_when_both_exist(self):
        with tempfile.TemporaryDirectory() as tmp:
            root, legacy_root = Path(tmp) / "term-check", Path(tmp) / "claude" / "glossary"
            (root / self.RID).mkdir(parents=True)
            (root / self.RID / "glossary.json").write_text('{"terms": []}')
            (legacy_root / self.RID).mkdir(parents=True)
            (legacy_root / self.RID / "glossary.json").write_text("{}")
            got = _resolve_state_dir(root, legacy_root, self.RID)
            self.assertEqual((got / "glossary.json").read_text(), '{"terms": []}')
            self.assertTrue((legacy_root / self.RID / "glossary.json").exists())

    def test_no_legacy_returns_path_without_creating(self):
        with tempfile.TemporaryDirectory() as tmp:
            root, legacy_root = Path(tmp) / "term-check", Path(tmp) / "claude" / "glossary"
            got = _resolve_state_dir(root, legacy_root, self.RID)
            self.assertEqual(got, root / self.RID)
            self.assertFalse(got.exists())


class ShouldSkipTest(unittest.TestCase):
    def test_skip_dirs_and_suffixes(self):
        self.assertTrue(_should_skip("node_modules/foo/index.js"))
        self.assertTrue(_should_skip("vendor/github.com/lib.go"))
        self.assertTrue(_should_skip("assets/logo.png"))
        self.assertTrue(_should_skip("data/records.csv"))
        self.assertTrue(_should_skip("logs/events.jsonl"))

    def test_keep_normal_sources(self):
        self.assertFalse(_should_skip("internal/validator/validator.go"))
        self.assertFalse(_should_skip("src/main.py"))
        self.assertFalse(_should_skip("README.md"))


class InventoryStreamingTest(unittest.TestCase):
    def test_accepts_dict_of_texts(self):
        """inventory_from_texts は dict を受け付ける"""
        texts = {
            "fetch_user.go": "func FetchUser() {}\n// ユーザーを取得する\n",
            "fetch_team.go": "func FetchTeam() {}\n",
        }
        inv = inventory_from_texts(texts)
        self.assertEqual(inv["words"]["fetch"], 4)
        self.assertEqual(inv["words"]["user"], 2)

    def test_accepts_iterable_of_pairs(self):
        """inventory_from_texts は (path, 中身) の iterable も受け付ける"""
        pairs = iter([
            ("fetch_user.go", "func FetchUser() {}\n// ユーザーを取得する\n"),
            ("fetch_team.go", "func FetchTeam() {}\n"),
        ])
        inv = inventory_from_texts(pairs)
        self.assertEqual(inv["words"]["fetch"], 4)
        self.assertEqual(inv["words"]["user"], 2)


class InventoryTest(unittest.TestCase):
    def test_counts_words_and_ja(self):
        texts = {
            "fetch_user.go": "func FetchUser() {}\n// ユーザーを取得する\n",
            "fetch_team.go": "func FetchTeam() {}\n",
        }
        inv = inventory_from_texts(texts)
        # 識別子由来 (FetchUser, FetchTeam) + ファイル名由来 (fetch_user, fetch_team)
        self.assertEqual(inv["words"]["fetch"], 4)
        self.assertEqual(inv["words"]["user"], 2)
        # 日本語はコメント・テストタイトルから名詞単位で拾う
        self.assertIn("ユーザー", inv["ja"])
        self.assertIn("取得", inv["ja"])
        self.assertNotIn("ユーザーを取得する", inv["ja"])

    def test_string_literals_not_counted(self):
        inv = inventory_from_texts({"a.ts": 'const x = "retrieveUser ログイン"'})
        self.assertNotIn("retrieve", inv["words"])
        self.assertEqual(inv["ja"], {})


GLOSSARY = {
    "terms": [
        {"term": "fetch", "ja": "取得", "avoid": ["retrieve"], "note": "外部 API からの取得"},
        {"term": "shipping_fee", "ja": "送料", "avoid_ja": ["配送料", "配送費"]},
    ]
}
INVENTORY = {"words": {"fetch": 10, "user": 5, "shipping": 2, "fee": 8}, "ja": {"取得": 3}}


class LookupWordTest(unittest.TestCase):
    def test_english_word(self):
        got = lookup_word("fetch", GLOSSARY, INVENTORY)
        self.assertEqual(got["count"], 10)
        self.assertEqual(got["glossary_hits"][0]["term"], "fetch")

    def test_avoid_word_hits_glossary(self):
        got = lookup_word("retrieve", GLOSSARY, INVENTORY)
        self.assertEqual(got["count"], 0)
        self.assertEqual(got["glossary_hits"][0]["term"], "fetch")

    def test_japanese_word(self):
        got = lookup_word("送料", GLOSSARY, INVENTORY)
        self.assertEqual(got["glossary_hits"][0]["ja"], "送料")

    def test_related_words_by_prefix(self):
        inv = {"words": {"valid": 3, "validate": 9, "validator": 4}, "ja": {}}
        got = lookup_word("validation", {"terms": []}, inv)
        self.assertEqual(
            [w for w, _ in got["related"]], ["validate", "validator", "valid"]
        )


class RunCheckTest(unittest.TestCase):
    def _ext(self, **over):
        base = {"filenames": [], "identifiers": [], "comments": [], "test_titles": []}
        base.update(over)
        return base

    def test_avoid_word_in_identifier(self):
        ext = self._ext(
            identifiers=[{"file": "a.go", "line": 3, "ident": "retrieveUser",
                          "words": ["retrieve", "user"]}]
        )
        got = run_check(ext, GLOSSARY, INVENTORY)
        self.assertEqual(len(got["violations"]), 1)
        v = got["violations"][0]
        self.assertEqual((v["file"], v["line"], v["word"]), ("a.go", 3, "retrieve"))
        self.assertEqual(v["term"]["term"], "fetch")

    def test_avoid_ja_in_comment(self):
        ext = self._ext(comments=[{"file": "a.go", "line": 7, "text": "配送料を計算する"}])
        got = run_check(ext, GLOSSARY, INVENTORY)
        self.assertEqual(got["violations"][0]["word"], "配送料")

    def test_avoid_word_in_test_title(self):
        ext = self._ext(
            test_titles=[{"file": "a_test.go", "line": 1, "text": "test_retrieve_user"}]
        )
        got = run_check(ext, GLOSSARY, INVENTORY)
        self.assertEqual(got["violations"][0]["word"], "retrieve")

    def test_new_words(self):
        ext = self._ext(
            identifiers=[{"file": "a.go", "line": 3, "ident": "newFetch",
                          "words": ["new", "fetch"]}],
            filenames=["new_fetch.go"],
        )
        got = run_check(ext, GLOSSARY, INVENTORY)
        self.assertIn("new", got["new_words"])  # inventory に無い
        self.assertNotIn("fetch", got["new_words"])  # inventory に有る

    def test_glossary_term_is_not_new_word(self):
        ext = self._ext(
            identifiers=[{"file": "a.go", "line": 1, "ident": "shipping_fee",
                          "words": ["shipping", "fee"]}]
        )
        inv = {"words": {}, "ja": {}}
        got = run_check(ext, GLOSSARY, inv)
        # glossary の term に登録済みの語の構成語は新出扱いしない
        self.assertNotIn("shipping", got["new_words"])

    def test_glossary_term_words_known_even_in_compound(self):
        # glossary term の構成語は、term と完全一致しない複合識別子の中でも既知扱い
        ext = self._ext(
            identifiers=[{"file": "a.go", "line": 1, "ident": "shippingFeeLimit",
                          "words": ["shipping", "fee", "limit"]}]
        )
        got = run_check(ext, GLOSSARY, {"words": {"limit": 1}, "ja": {}})
        self.assertEqual(got["new_words"], {})

    def test_new_ja_phrases(self):
        ext = self._ext(comments=[{"file": "a.go", "line": 7, "text": "注文合計金額を検証"}])
        got = run_check(ext, GLOSSARY, INVENTORY)
        self.assertIn("注文合計金額", got["new_ja"])
        self.assertNotIn("注文合計金額を検証", got["new_ja"])

    def test_single_char_ja_not_reported_as_new(self):
        # 助詞など 1 文字の日本語はフレーズとして報告しない
        ext = self._ext(comments=[{"file": "a.go", "line": 1, "text": "値 は 上限"}])
        got = run_check(ext, GLOSSARY, INVENTORY)
        self.assertNotIn("は", got["new_ja"])
        self.assertNotIn("値", got["ja_phrases"])
        self.assertIn("上限", got["new_ja"])


if __name__ == "__main__":
    unittest.main()
