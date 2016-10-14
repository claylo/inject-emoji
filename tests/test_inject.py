import pytest
import tempfile
from inject_emoji import InjectEmoji
import sys

class TestInject:

    def test_lib_function(self):
        pattern = 'Initial Commit | <img class="tada"'
        tmp = tempfile.NamedTemporaryFile(mode='w+',delete=True)
        converted = False

        with open('tests/commit-message-emoji.md', 'r') as testin:
            InjectEmoji(testin, tmp).main()

        tmp.seek(0)
        for line in tmp:
            if line[:34] == pattern:
                converted = True

        assert converted == True

    def test_named_directory(self):
        pattern = 'Initial Commit | <img class="tada"'
        tmp = tempfile.NamedTemporaryFile(mode='w+',delete=True)
        converted = False

        with open('tests/commit-message-emoji.md', 'r') as testin:
            InjectEmoji(testin, tmp, 'emojis').main()

        tmp.seek(0)
        for line in tmp.file:
            if line[:34] == pattern:
                converted = True

        assert converted == True

    def test_stdout(self, capsys):
        pattern = 'Tooling | <img class="wrench"'
        converted = False

        with open('tests/commit-message-emoji.md', 'r') as testin:
            InjectEmoji(testin).main()

        stdout, err = capsys.readouterr()
        out = stdout.split("\n")
        for line in out:
            if line[:29] == pattern:
                converted = True

        assert converted == True

    def test_stdin(self, capsys):
        pattern = 'Tooling | <img class="wrench"'
        converted = False

        sys.stdin = open('tests/commit-message-emoji.md', 'r')
        InjectEmoji().main()

        stdout, err = capsys.readouterr()
        out = stdout.split("\n")
        for line in out:
            if line[:29] == pattern:
                converted = True

        assert converted == True
