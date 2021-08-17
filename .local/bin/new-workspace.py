#!/usr/bin/env python3
# Author: Vinicius M Longaray
# Github: @v1nns
import argparse
import json
import subprocess


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

    # get next workspace number
    number = (max(workspace["num"] for workspace in workspaces)) + 1

    if args.create:
        # just create a new workspace
        create = subprocess.run(["i3-msg", "workspace", str(number)])
    elif args.move:
        # move current container to a new workspace and go there
        move = subprocess.run(
            ["i3-msg", "move", "container", "to", "workspace", "number", str(number)]
        )
        goto = subprocess.run(
            ["i3-msg", "workspace", str(number)]
        )


main()
