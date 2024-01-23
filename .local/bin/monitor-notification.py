#!/usr/bin/env python3
"""Monitor notification messages sent through D-Bus protocol
Author: Vinicius M. Longaray

Monitor-notification is a flexible, not-so powerful, script to listen for
notifications sent by any program that uses the D-Bus protocol. The main idea
here is to filter these received notifications and save it in a file (default
path is /tmp/notifications.log), thus making it possible to display this info in
a cool way (like using a dialog with rofi).

# How to use

For my personal use, I'm running it detached in the beginning of i3 session, for
example:

  monitor-notification.py &> /dev/null

"""
import dbus
from dbus.mainloop.glib import DBusGMainLoop
from gi.repository import GLib
import pid
import re
import time

# default path
log_file = "/tmp/notifications.log"

# store last string wrote to file
last_string = "dummy"


# utility
def remove_html_tags(text):
    """Remove html tags from a string"""
    TAG_RE = re.compile(r"<[^>]+>(.|\n)*?<[^>]+>")
    return TAG_RE.sub("", text)


# Callback for any notification received from D-BUS
def notifications(bus, message):
    # before doing any kind of magic,
    # check docs: https://developer.gnome.org/notification-spec/#command-notify
    if message.get_interface() != 'org.freedesktop.Notifications' or message.get_member() != 'Notify':
        return

    # parse arguments from MethodCallMessage
    args = message.get_args_list()

    # do nothing if message is empty
    if len(args) == 0:
        return

    app_name = args[0]
    if len(app_name) > 0:
        global last_string
        summary = args[3].replace("\n", "")
        body = args[4].replace("\n", "")

        # strip any HTML tag from summary and body
        summary = remove_html_tags(summary)
        body = remove_html_tags(body)

        # get current timestamp
        timestamp = time.strftime("%Y/%m/%d %H:%M")

        # format string
        body_string = " - " + body if len(body) > 0 else ""
        string = "{0} - [{1:.15}] - {2}{3}\n".format(
            timestamp, app_name, summary, body_string
        )

        if string != last_string:
            # sometimes a blank line would appear out of nowhere, in order to
            # prevent this, get file object in binary mode
            file = open(log_file, "a")

            # write string to log file
            print(string, file=file, end="")
            file.close()

            # save it
            last_string = string


def main():
    DBusGMainLoop(set_as_default=True)
    bus = dbus.SessionBus()

    obj_dbus = bus.get_object('org.freedesktop.DBus',
                              '/org/freedesktop/DBus')
    obj_dbus.BecomeMonitor(["interface='org.freedesktop.Notifications'"],
                           dbus.UInt32(0),
                           interface='org.freedesktop.Notifications')

    bus.add_message_filter(notifications)

    main_loop = GLib.MainLoop()
    main_loop.run()


# ensure there is only one instance of this script
with pid.PidFile():
    main()
