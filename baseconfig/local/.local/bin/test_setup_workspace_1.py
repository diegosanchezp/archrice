import unittest
from datetime import time
from setup_workspace_1 import (
    get_webpages, Webpages, open_webpages,
    parse_args,
)


class TestSetupWorkspace1(unittest.TestCase):

    # python -m unittest test_setup_workspace_1.TestSetupWorkspace1.test_get_webpages
    def test_get_webpages(self):

        # Should open shimoku webpages
        self.assertEqual(
            # Monday 5:30am
            get_webpages(0, time(hour=5,minute=30)),
            Webpages.shimokujob,
        )

        self.assertEqual(
            # Friday 12m
            get_webpages(4, time(hour=12,minute=0)),
            Webpages.shimokujob,
        )

        # Should open tesis webpages
        self.assertEqual(
            # Friday 2:30pm
            get_webpages(4, time(hour=14,minute=30)),
            Webpages.tesis,
        )

        # On weekends doesn't opens any webpage
        self.assertEqual(
            # Friday 2:30pm
            get_webpages(6, time(hour=14,minute=30)),
            [],
        )


    # python -m unittest test_setup_workspace_1.TestSetupWorkspace1.test_open_webpage
    def test_open_webpage(self):

        # it opens the python docs in a new tab
        self.assertTrue(
            open_webpages(["https://docs.python.org/3/library/index.html"])
        )

        # it opens a new window
        self.assertTrue(
            open_webpages([])
        )
    # python -m unittest test_setup_workspace_1.TestSetupWorkspace1.test_parse_args
    def test_parse_args(self):
        args = parse_args(["--webpages", "shimokujob"])

        self.assertEqual(
            "shimokujob",
            args.webpages,
        )
