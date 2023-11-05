#!/bin/python3

from datetime import datetime, time
import calendar
import subprocess
import json
import argparse
from typing import Optional

def i3msg(*command):
    """
    Wrapped i3 command
    """

    base_command = ["i3-msg", "--raw"]
    base_command.extend(command)
    print(base_command)

    cp = subprocess.run(
        base_command,
        capture_output=True,
        encoding="utf-8",
        check=True,
    )

    # Parse json output
    json_output = json.loads(cp.stdout)
    success = json_output[0]["success"]
    # Todo exception if success is not true
    return success

class Webpages:
    """
    Collection of web pages urls
    """

    shimokujob = [
        "https://shimoku.io/",
        "https://shimoku.slack.com/",
        "https://mail.google.com/mail/u/3/",
        "https://calendar.google.com/u/3",
        "https://trello.com/",
    ]

    tesis = [
        "https://github.com/users/diegosanchezp/projects/5/views/2",
        "https://www.figma.com/file/nH47dX9I5kzjjIdfjAGqMO/Tesis-Wireframe",
        "~/Documents/django-docs-4.2/index.html",
    ]

def get_webpages(weekday_num: int, today: time, webpages: Optional[str] = None):
    """
    Get the url webpages for the week
    """
    if webpages != None:
        return Webpages.__dict__[webpages]

    # Empty array represents a new opened window
    web_pages = []

    its_monday_to_friday = (weekday_num >= 0 and weekday_num <=4)

    # If today is monday to friday, and it's 5am to 2pm
    if its_monday_to_friday and (today.hour >=5 and today.hour <= 14):
        web_pages = Webpages.shimokujob

    # If today is monday to friday, and it's past 2:30pm
    # open tesis webpages
    if its_monday_to_friday and (today.hour >= 14 and today.minute >=30):
        web_pages = Webpages.tesis

    return web_pages

def open_webpages(web_pages: list[str]):
    """
    Open webpages in workspace 1
    """

    # Go to workspace 1
    i3msg("workspace 1")

    # Open web_pages in browser

    # return is useful for unit tests
    return i3msg(
        "exec gtk-launch $(xdg-settings get default-web-browser)",
        *web_pages,
    )

def parse_args(args = None):
    """
    Parse command line arguments
    """

    parser = argparse.ArgumentParser(
        description="Plot the Super admin workspace"
    )

    choices = set(Webpages.__dict__.keys()) - {'__module__', '__doc__', '__dict__', '__weakref__'}
    parser.add_argument(
        "--webpages",
        choices=choices,
        help="Skips logic for getting webpages and opens the specified set of webpages",
    )

    args = parser.parse_args(args=args)

    return args

if __name__ == "__main__":

    # week_names = list(calendar.day_name)
    args = parse_args()

    # Get todays date
    today = datetime.now()

    # Get week day number, 0 is Monday
    weekday_num = calendar.weekday(today.year,today.month,today.day)

    # Get webpages for todays time
    web_pages = get_webpages(
        weekday_num, today.time(), args.webpages
    )

    # Open the webpages in the browser
    open_webpages(web_pages)


