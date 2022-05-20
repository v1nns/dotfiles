#!/usr/bin/env python3
"""Music Event Daemon based on D-Bus protocol
Author: Vinicius M. Longaray

Music Event Daemon (MED) is a flexible, not-so powerful, server-side application
for listening to music events. Through a client-server architecture, it can take
any action whenever a song has started playing or even when it's paused/stopped.

# How to use

Currently, I'm using it with polybar as a "custom/script" module to keep running
and get its output printed directly to STDOUT.

For more details, check these files:
 'dotfiles/.config/polybar/modules.ini' (polybar setup)
 'dotfiles/.local/bin/librespot_listener' (client sending information to daemon)

"""
import gi
import dbus
import dbus.service

from dbus.mainloop.glib import DBusGMainLoop
from pid import PidFileError
from pid.decorator import pidfile

gi.require_version('Gtk', '3.0')
from gi.repository import Gtk

DBUS_SERVICE_NAME = 'org.vinns.musicdaemon'
DBUS_OBJECT_NAME = '/org/vinns/musicdaemon'


class MusicEventDaemon(dbus.service.Object):

    def __init__(self):
        bus_name = dbus.service.BusName(DBUS_SERVICE_NAME,
                                        bus=dbus.SessionBus())
        dbus.service.Object.__init__(self, bus_name, DBUS_OBJECT_NAME)
        self.symbols = {"music": ''}
        # these values are specially for polybar
        self.color_init = "%{F#8A8B9B}"
        self.color_finish = "%{F-}"

    def __del__(self):
        self.print_with_flush("")
        self.Quit()

    @staticmethod
    def _format_text(icon, artist, title, color_init="", color_finish=""):
        return f"{color_init}{icon} {artist} - {title}{color_finish}"

    @staticmethod
    def print_with_flush(message):
        """Print message to STDOUT and force to flush the buffer"""
        print(message, flush=True)

    @dbus.service.method(DBUS_SERVICE_NAME)
    def play(self, artist, title):
        """format information from current playing song to a string and print it to STDOUT"""
        string = self._format_text(icon=self.symbols["music"],
                                   artist=artist,
                                   title=title)
        self.print_with_flush(string)

    @dbus.service.method(DBUS_SERVICE_NAME)
    def pause(self, artist, title):
        """format information from current paused song to a string and print it to STDOUT"""
        string = self._format_text(icon=self.symbols["music"],
                                   artist=artist,
                                   title=title,
                                   color_init=self.color_init,
                                   color_finish=self.color_finish)
        self.print_with_flush(string)

    @dbus.service.method(DBUS_SERVICE_NAME)
    def stop(self):
        """clear formatted string previously printed to STDOUT"""
        self.print_with_flush("")

    @dbus.service.method(DBUS_SERVICE_NAME)
    def Quit(self):
        """removes this object from the DBUS connection and exits"""
        self.remove_from_connection()
        Gtk.main_quit()
        return


# ------------------------------------------ Main method ----------------------------------------- #


@pidfile()
def main():
    DBusGMainLoop(set_as_default=True)
    server = MusicEventDaemon()
    Gtk.main()


# ------------------------------------------------------------------------------------------------ #

if __name__ == '__main__':
    try:
        main()
    except PidFileError as e:
        # that's ok, you can have only one instance running simultaneously
        pass
    except KeyboardInterrupt as e:
        # that's also ok
        pass
