import unittest

from term_check import split_identifier, normalize_remote


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


if __name__ == "__main__":
    unittest.main()
