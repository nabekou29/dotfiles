import unittest

from term_check import split_identifier, normalize_remote, extract_line, extract, filename_words, parse_diff, inventory_from_texts


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
        got = extract_line("const rawLength = countRunes(message)")
        self.assertEqual(got["identifiers"], ["rawLength", "countRunes", "message"])

    def test_string_contents_excluded(self):
        got = extract_line('setMessage("ようこそ retrieveUser さん")')
        self.assertEqual(got["identifiers"], ["setMessage"])

    def test_comment_extracted(self):
        got = extract_line("x = 1  # 実効文字数を数える")
        self.assertEqual(got["comment"], "実効文字数を数える")

    def test_slash_comment(self):
        got = extract_line("return n // 実長を返す")
        self.assertEqual(got["comment"], "実長を返す")
        self.assertEqual(got["identifiers"], [])

    def test_no_comment(self):
        self.assertIsNone(extract_line("const a = b")["comment"])

    def test_test_title_js(self):
        got = extract_line('it("URL を固定長としてカウントする", () => {')
        self.assertEqual(got["test_titles"], ["URL を固定長としてカウントする"])

    def test_test_title_go(self):
        got = extract_line('func TestEffectiveMessageLength(t *testing.T) {')
        self.assertEqual(got["test_titles"], ["TestEffectiveMessageLength"])

    def test_test_title_go_subtest(self):
        got = extract_line('t.Run("URL を含む場合", func(t *testing.T) {')
        self.assertEqual(got["test_titles"], ["URL を含む場合"])

    def test_test_title_pytest(self):
        got = extract_line("def test_effective_length_with_url():")
        self.assertEqual(got["test_titles"], ["test_effective_length_with_url"])

    def test_stopwords_filtered(self):
        got = extract_line("if err != nil { return err }")
        self.assertEqual(got["identifiers"], ["err", "err"])


SAMPLE_DIFF = """\
diff --git a/internal/validator/validator.go b/internal/validator/validator.go
index 1234567..89abcde 100644
--- a/internal/validator/validator.go
+++ b/internal/validator/validator.go
@@ -10,2 +10,3 @@ func Validate(msg string) error {
 \tif msg == "" {
+\t\trawLength := countRunes(msg) // 実長を数える
 \t\treturn nil
diff --git a/internal/validator/length_test.go b/internal/validator/length_test.go
new file mode 100644
--- /dev/null
+++ b/internal/validator/length_test.go
@@ -0,0 +1,2 @@
+func TestRawLength(t *testing.T) {
+\tt.Run("URL を含む場合", func(t *testing.T) {})
"""


class ParseDiffTest(unittest.TestCase):
    def test_added_lines_with_numbers(self):
        files = parse_diff(SAMPLE_DIFF)
        self.assertEqual(
            files["internal/validator/validator.go"],
            [(11, "\t\trawLength := countRunes(msg) // 実長を数える")],
        )

    def test_new_file(self):
        files = parse_diff(SAMPLE_DIFF)
        self.assertEqual(len(files["internal/validator/length_test.go"]), 2)


class ExtractTest(unittest.TestCase):
    def test_aggregates_with_locations(self):
        got = extract(parse_diff(SAMPLE_DIFF))
        idents = [(i["file"], i["line"], i["ident"]) for i in got["identifiers"]]
        self.assertIn(
            ("internal/validator/validator.go", 11, "rawLength"), idents
        )
        comments = [(c["line"], c["text"]) for c in got["comments"]]
        self.assertIn((11, "実長を数える"), comments)
        titles = [t["text"] for t in got["test_titles"]]
        self.assertIn("TestRawLength", titles)
        self.assertIn("URL を含む場合", titles)
        self.assertIn("internal/validator/length_test.go", got["filenames"])


class FilenameWordsTest(unittest.TestCase):
    def test_kebab_and_multi_extension(self):
        # .test.ts のような多段拡張子は丸ごと落とす(test はファイル種別マーカーで用語でない)
        self.assertEqual(
            filename_words("src/effective-message_length.test.ts"),
            ["effective", "message", "length"],
        )

    def test_no_extension_keeps_short_words(self):
        self.assertEqual(filename_words("docs/user-api"), ["user", "api"])


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
        # 日本語はコメント・テストタイトルからのみ拾う
        self.assertIn("ユーザーを取得する", inv["ja"])

    def test_string_literals_not_counted(self):
        inv = inventory_from_texts({"a.ts": 'const x = "retrieveUser ログイン"'})
        self.assertNotIn("retrieve", inv["words"])
        self.assertEqual(inv["ja"], {})


if __name__ == "__main__":
    unittest.main()
