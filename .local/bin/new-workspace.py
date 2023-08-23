#!/usr/bin/env python3
# Author: Vinicius M Longaray
# Github: @v1nns
import argparse
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


# Contains workspace attributes based on window information retrieved from i3_tree
class Workspace:

    def __init__(self, name, number):
        self.name = name
        self.number = number


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


def move_and_rename(i3: i3ipc.Connection, previous_name: str, new_number: int,
                    workspaces: list[Workspace]):
    # move current container to a new workspace
    i3.command("move container to workspace number {}".format(new_number))

    # check if new workspace already exists
    wk = next((w for w in workspaces if w.number == new_number), None)

    # go to new workspace
    i3.command("workspace {}".format(wk.name if wk is not None else new_number))

    if wk is None:
        # check if this is the last window in workspace
        if sum(1 for w in workspaces if w.name == previous_name) == 1:
            # rename new workspace with name from the previous one
            new_name = define_new_name(previous_name, new_number)
            i3.command("rename workspace to {}".format(new_name))


# ************************************************************************************************ #


def main():
    # parse given arguments
    args = get_args_parsed()

    # create a connection to i3 IPC
    i3 = i3ipc.Connection()

    # auxiliary variables
    active = Workspace("", 0)
    workspaces = []
    greater_numbers = []

    # list all open windows in i3
    for con in i3.get_tree():
        if con.window and con.parent.type != 'dockarea':
            # print("id = {} class = {} focused = {} name = {} workspace = {}".
            #       format(con.window, con.window_class, con.focused, con.name,
            #              con.workspace().name))
            if con.focused:
                active.name = con.workspace().name
                active.number = con.workspace().num

            # append only workspaces with a greater number than the active one
            if con.workspace().num >= active.number:
                greater_numbers.append(con.workspace().num)

            # append all existent workspaces
            workspaces.append(
                Workspace(con.workspace().name,
                          con.workspace().num))

    # determine next number available to use as workspace index
    number = define_next_number(greater_numbers)

    # determine which command should run based on the given argument
    if args.create:
        # just create a new workspace
        i3.command("workspace {}".format(number))
        return

    elif args.new:
        # move current container to a new workspace and go there
        move_and_rename(i3, active.name, number, workspaces)
        return

    elif args.move:
        # move current container to given workspace and go there
        # TODO: get name from targeted workspace
        # for example, move to 1:web, it will create a 1 workspace
        move_and_rename(i3, active.name, args.move, workspaces)
        return


main()
