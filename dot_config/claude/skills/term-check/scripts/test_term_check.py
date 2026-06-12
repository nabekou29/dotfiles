import unittest

from term_check import split_identifier


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


if __name__ == "__main__":
    unittest.main()
