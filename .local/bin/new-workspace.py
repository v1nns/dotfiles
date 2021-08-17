#!/usr/bin/env python3
# Author: Vinicius M Longaray
# Github: @v1nns
import subprocess
import json

def main():
    # get all existent workspaces
    output = subprocess.check_output("i3-msg -t get_workspaces", shell=True, universal_newlines=True)

    # convert into dict
    workspaces = json.loads(output)

    # get next workspace number
    number = (max(workspace['num'] for workspace in workspaces)) + 1

    # create new workspace
    create = subprocess.run(["i3-msg","workspace", str(number) ])

main()
