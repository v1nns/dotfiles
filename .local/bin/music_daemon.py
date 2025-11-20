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
import dbus
import dbus.service
import fcntl
import gi
import os
import sys

from dbus.mainloop.glib import DBusGMainLoop
from threading import Timer

gi.require_version('Gtk', '3.0')
from gi.repository import Gtk  # noqa: E402

DBUS_SERVICE_NAME = 'org.vinns.musicdaemon'
DBUS_OBJECT_NAME = '/org/vinns/musicdaemon'


class SingleInstance:
    """
    Context manager to ensure only one instance of script runs at a time.
    Uses file locking (fcntl) to prevent multiple instances. If another instance
    is already running, the script will exit with code 1.

    Note:
        - The lock file is automatically created and removed
        - The lock is released even if the script crashes
        - Works on Linux/Unix systems (requires fcntl module)
    """

    def __init__(self, lockfile):
        self.lockfile = lockfile
        self.fp = None

    def __enter__(self):
        self.fp = open(self.lockfile, 'w')
        try:
            fcntl.flock(self.fp.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
        except IOError:
            print("Another instance is already running.", file=sys.stderr)
            sys.exit(1)

        # Write PID to file
        self.fp.write(str(os.getpid()))
        self.fp.flush()
        return self.fp

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.fp:
            fcntl.flock(self.fp.fileno(), fcntl.LOCK_UN)
            self.fp.close()
            try:
                os.unlink(self.lockfile)
            except Exception:
                pass

# ------------------------------------------------------------------------------------------------ #


class MusicEventDaemon(dbus.service.Object):

    MAX_ARTIST_LEN = 20
    MAX_TITLE_LEN = 25
    SYMBOLS = {"music": ' '}
    COLORS = {
        "active": "#B4F9F8",
        "inactive": "#8A8B9B",
        "text": "#C0CAF3"
    }

    def __init__(self, bar_type="polybar"):
        bus_name = dbus.service.BusName(DBUS_SERVICE_NAME,
                                        bus=dbus.SessionBus())
        dbus.service.Object.__init__(self, bus_name, DBUS_OBJECT_NAME)

        self.bar_type = bar_type
        self.tag_begin = "%{{F<hex>}}"if self.bar_type == "polybar" else "<span foreground='<hex>'>"
        self.tag_end = "%{{F-}}"if self.bar_type == "polybar" else "</span>"

    def __del__(self):
        self.print_with_flush("")
        self.Quit()

    def _set_timer(self):
        """ Enable timer with 10 seconds as default value"""
        self.timer = Timer(10.0, self.print_with_flush)
        self.timer.start()

    def _format_text(self, icon, artist, title, active):
        # Truncate artist and title if they exceed max length
        if len(artist) > self.MAX_ARTIST_LEN:
            artist = artist[:self.MAX_ARTIST_LEN - 3].rstrip() + "..."

        if len(title) > self.MAX_TITLE_LEN:
            title = title[:self.MAX_TITLE_LEN - 3].rstrip() + "..."

        icon_color = self.COLORS["active"] if active else self.COLORS["inactive"]
        formatted_icon = f"{self.tag_begin.replace("<hex>", icon_color)}{icon} {self.tag_end}"

        text_color = self.COLORS["text"] if active else self.COLORS["inactive"]
        formatted_song = f"{
            self.tag_begin.replace("<hex>", text_color)}{artist} - {title}{self.tag_end}"

        return f"{formatted_icon}{formatted_song}"

    @staticmethod
    def print_with_flush(message=""):
        """Print message to STDOUT and force to flush the buffer"""
        print(message, flush=True)

    @dbus.service.method(DBUS_SERVICE_NAME)
    def play(self, artist, title):
        """format information from current playing song to a string and print it to STDOUT"""
        string = self._format_text(icon=self.SYMBOLS["music"],
                                   artist=artist,
                                   title=title,
                                   active=True)
        self.print_with_flush(string)
        self.timer.cancel()

    @dbus.service.method(DBUS_SERVICE_NAME)
    def pause(self, artist, title):
        """format information from current paused song to a string and print it to STDOUT"""
        string = self._format_text(icon=self.SYMBOLS["music"],
                                   artist=artist,
                                   title=title,
                                   active=False)
        self.print_with_flush(string)
        self._set_timer()

    @dbus.service.method(DBUS_SERVICE_NAME)
    def stop(self):
        """clear formatted string previously printed to STDOUT"""
        self.print_with_flush("")
        self.timer.cancel()

    @dbus.service.method(DBUS_SERVICE_NAME)
    def Quit(self):
        """removes this object from the DBUS connection and exits"""
        self.timer.cancel()
        self.remove_from_connection()
        Gtk.main_quit()
        return


# ------------------------------------------ Main method ----------------------------------------- #


def main():
    import argparse

    parser = argparse.ArgumentParser(
        description='Music Event Daemon based on D-Bus protocol for status bars')
    parser.add_argument('--bar', choices=['polybar', 'waybar'],
                        default='polybar', help='Status bar type (default: polybar)')
    args = parser.parse_args()

    DBusGMainLoop(set_as_default=True)
    MusicEventDaemon(bar_type=args.bar)
    Gtk.main()


# ------------------------------------------------------------------------------------------------ #

if __name__ == '__main__':
    try:
        with SingleInstance("/tmp/music_daemon.lock"):
            main()
    except KeyboardInterrupt:
        # that's ok
        pass
