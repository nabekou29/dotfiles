import unittest

from term_check import split_identifier, normalize_remote, extract_line


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


if __name__ == "__main__":
    unittest.main()
