#!/usr/bin/env python3
# Author: Vinicius M Longaray
# Github: @v1nns
import argparse
import json
import subprocess

from numpy import empty


def get_args_parsed():
    parser = argparse.ArgumentParser(
        description="Move your stuff between i3 workspaces."
    )
    parser.add_argument("--create", action="store_true", help="create a new workspace")
    parser.add_argument(
        "--move", action="store_true", help="move current container to a new workspace"
    )
    args = parser.parse_args()
    return args


def main():
    args = get_args_parsed()

    # TODO: inform some kind of message, maybe?
    if args.create is False and args.move is False:
        return

    # get all existent workspaces
    output = subprocess.check_output(
        "i3-msg -t get_workspaces", shell=True, universal_newlines=True
    )

    # convert into dict
    workspaces = json.loads(output)

    # get next workspace number (using list comprehension)
    active = next(workspace["num"] for workspace in workspaces if workspace["focused"] == True)
    # extract a sorted sub-list with values starting from the active workspace number
    numbers = sorted([workspace["num"] for workspace in workspaces if workspace["num"] >= active])
    # generate a new set containing only the non-existent values based on the previous list
    missing_numbers = sorted(set(range(numbers[0], numbers[-1])) - set(numbers))

    # define number for the new workspace
    number = next(iter(missing_numbers)) if len(missing_numbers) > 0 else (numbers[-1] + 1)

    if args.create:
        # just create a new workspace
        create = subprocess.run(["i3-msg", "workspace", str(number)])
    elif args.move:
        # move current container to a new workspace and go there
        move = subprocess.run(
            ["i3-msg", "move", "container", "to", "workspace", "number", str(number)]
        )
        goto = subprocess.run(["i3-msg", "workspace", str(number)])


main()
