#!/usr/bin/env python3
# Author: Vinicius M Longaray
# Github: @v1nns
import argparse
import json
import i3ipc


def get_args_parsed():
    parser = argparse.ArgumentParser(
        description="Move your stuff between i3 workspaces.")
    group = parser.add_mutually_exclusive_group(required=True)

    group.add_argument("--create",
                       action="store_true",
                       help="create a new workspace")
    group.add_argument("--new",
                       action="store_true",
                       help="move current container to a new workspace")
    group.add_argument("--move",
                       type=int,
                       choices=range(1, 20),
                       help="move current container to the given workspace")

    args = parser.parse_args()
    return args


# ************************************************************************************************ #


def define_next_number(numbers):
    # extract a sorted sub-list with values starting from the active workspace number
    numbers = sorted(numbers)

    # generate a new set containing only the non-existent values based on the previous list
    missing = sorted(set(range(numbers[0], numbers[-1])) - set(numbers))

    # define number for the new workspace
    number = next(iter(missing)) if len(missing) > 0 else (numbers[-1] + 1)

    return number


# ************************************************************************************************ #


def define_new_name(previous_name, new_number):
    name = ""
    index = previous_name.find(":")

    if index != -1:
        subname = previous_name[index:]
        name = "{}{}".format(new_number, subname)

    return name


# ************************************************************************************************ #


def move_and_rename(i3, previous_name, new_number, count_windows):
    # move current container to a new workspace and go there
    i3.command("move container to workspace number {}".format(new_number))
    i3.command("workspace {}".format(new_number))

    # in case it was the last window, rename new workspace with same name from the previous one
    if count_windows == 1:
        new_name = define_new_name(previous_name, new_number)
        i3.command("rename workspace to {}".format(new_name))


# ************************************************************************************************ #


def main():
    args = get_args_parsed()

    # create a connection to i3 IPC
    i3 = i3ipc.Connection()

    # active workspace number and name
    active = 0
    name = ""

    # auxiliary variables
    count_windows = 0
    greater_numbers = []

    # list all open windows in i3
    for con in i3.get_tree():
        if con.window and con.parent.type != 'dockarea':
            # print("id = {} class = {} focused = {} name = {} workspace = {}".
            #       format(con.window, con.window_class, con.focused, con.name,
            #              con.workspace().name))
            if con.focused:
                active = con.workspace().num
                name = con.workspace().name

            if con.workspace().name == name:
                count_windows += 1

            if con.workspace().num >= active:
                greater_numbers.append(con.workspace().num)

    # determine next number available to use as workspace index
    number = define_next_number(greater_numbers)

    # determine which command should run based on the given argument
    if args.create:
        # just create a new workspace
        i3.command("workspace {}".format(number))
        return

    elif args.new:
        # move current container to a new workspace and go there
        move_and_rename(i3, name, number, count_windows)
        return

    elif args.move:
        # move current container to given workspace and go there
        move_and_rename(i3, name, args.move, count_windows)
        return


main()
