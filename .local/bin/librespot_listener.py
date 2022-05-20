#!/usr/bin/env python3
"""Librespot Event Listener
Author: Vinicius M. Longaray

This script allows the user to receive events from librespot and save
information in a cache file. These events are sent from librespot, when its
daemon is acting as a device playing songs through Spotify Connect API.

In order to execute it, the script requires that you have an app created in
Developer's dashboard from Spotify account, otherwise, you won't be able to
retrieve information from the current song playing. After you have created the
app, set client_id and client_secret inside SpotifyWebApi class.

Also, it sends a Notification (using Libnotify) depending on the received player
event.

# How to use
Pass this script as argument to librespot initialization, for example:
    "librespot --onevent librespot_listener.py"

"""
import base64
import dbus
import gi
import json
import requests
import os

from dataclasses import dataclass, field
from pid import PidFileError
from pid.decorator import pidfile

gi.require_version('Notify', '0.7')

from gi.repository import GObject, Notify

# ----------------------------------- Cache from temporary file ---------------------------------- #

DEFAULT_TMP_FILE = "/home/vinicius/.cache/librespot/custom_cache.json"

CLIENT_ID = ""
CLIENT_SECRET = ""


@dataclass
class Cache():
    state: str = field(default="")
    access_token: str = field(default="", repr=False)
    artist: str = field(default="")
    song: str = field(default="")

    def __post_init__(self):
        self.load_from_file()

    def load_from_file(self):
        if os.path.exists(DEFAULT_TMP_FILE):
            with open(DEFAULT_TMP_FILE) as json_file:
                obj = json.load(json_file)
                if "state" in obj:
                    self.state = obj["state"]
                if "access_token" in obj:
                    self.access_token = obj["access_token"]
                if "artist" in obj:
                    self.artist = obj["artist"]
                if "song" in obj:
                    self.song = obj["song"]

    def save_to_file(self):
        with open(DEFAULT_TMP_FILE, 'w+') as out:
            json.dump(self.__dict__, out)


# ------------------------------- Util class to send notifications ------------------------------- #


class LibrespotNotifier(GObject.Object):

    def __init__(self):
        super(LibrespotNotifier, self).__init__()
        Notify.init("librespot_notifier")
        self.title = "Spotify"

    def send_notification(self, state, text, title="", error=False):
        curr_title = title if title else self.title
        icon_path = self._get_icon_path(state, error)

        notify = Notify.Notification.new(curr_title, text, icon_path)
        notify.show()

    # TODO: get a default path from somewhere
    def _get_icon_path(self, state, error):
        if error:
            icon = "/usr/share/icons/Humanity/status/48/error.svg"
            return icon

        icon = "/usr/share/icons/Humanity/actions/48/"

        if state == "playing":
            icon += "player_play"
        elif state == "paused":
            icon += "player_pause"
        elif state == "stopped":
            icon += "player_stop"

        icon += ".svg"
        return icon


# ---------------------------------------- Spotify Web API --------------------------------------- #


# Wrapper for Spotify Web API using Client Credential flow
class SpotifyWebApi:

    def __init__(self, client_id, client_secret):
        self.access_token = ""
        self.client_id = client_id
        self.client_secret = client_secret
        self.urls = {
            "authentication": "https://accounts.spotify.com/api/token",
            "track_info": "https://api.spotify.com/v1/tracks/{id}",
        }

    def _update_access_token(self, cache=None, forced=False):
        # Use token loaded from cache
        if cache is not None and cache.access_token and not forced:
            self.access_token = cache.access_token
            return

        url = self.urls["authentication"]
        headers = {}
        data = {}

        # Encode as Base64
        message = f"{self.client_id}:{self.client_secret}"
        messageBytes = message.encode('ascii')
        base64Bytes = base64.b64encode(messageBytes)
        base64Message = base64Bytes.decode('ascii')

        headers['Authorization'] = f"Basic {base64Message}"
        data['grant_type'] = "client_credentials"
        data['scope'] = "user-modify-playback-state"

        req = requests.post(url, headers=headers, data=data)

        token = req.json()['access_token']

        # Update both cache and inner data
        cache.access_token = self.access_token = token

    def get_track_info(self, track_uri, cache=None):
        # default values
        info = {"artist": "", "song": ""}

        if track_uri is None:
            return info

        if not self.access_token:
            self._update_access_token(cache)

        retry = True
        while retry:
            # HTTPS GET
            url = self.urls["track_info"].format(id=track_uri)
            headers = {
                "Accept": "application/json",
                "Content-Type": "application/json",
                "Authorization": "Bearer {}".format(self.access_token)
            }

            req = requests.get(url, headers=headers)
            data = req.json()

            # Only get info in case of success
            if req.status_code == 200:
                cache.artist = info["artist"] = data["artists"][0]["name"]
                cache.song = info["song"] = data["name"]
                retry = False

            # Check if token has expired
            elif req.status_code == 401:
                # Get new token and retry GET in the next loop
                self._update_access_token(cache, forced=True)

            # Otherwise, there is nothing we can do
            else:
                info = data
                retry = False

        return info


# ------------------------------------------- Notify OS ------------------------------------------ #


def notify_system(state, info, error):
    # Instantiate notifier object
    notifier = LibrespotNotifier()
    message = ""

    # Create message based on information
    if not error:
        message = f"ARTIST: {info['artist']}\nTRACK: {info['song']}"

    # Otherwise, show output from Spotify Web API request
    else:
        message = f"Error {info['error']['status']}: {info['error']['message']}"

    notifier.send_notification(state, message, error)


# -------------------------------------- Notify Music Daemon ------------------------------------- #


def notify_daemon(state, info, error):
    if error:
        pass

    try:
        # get the session bus
        bus = dbus.SessionBus()

        # get object
        object = bus.get_object("org.vinns.musicdaemon",
                                "/org/vinns/musicdaemon")

        # get the interface
        interface = dbus.Interface(object, "org.vinns.musicdaemon")

        artist = info["artist"]
        song = info["song"]

        if state == "playing":
            interface.play(artist, song)
        elif state == "paused":
            interface.pause(artist, song)
        else:
            interface.stop()

    except Exception as e:
        # just ignore the exception, possibly, it didn't find any running music daemon to notify
        pass


# ------------------------------------------ Main method ----------------------------------------- #


@pidfile()
def main():
    # filter event from librespot
    state = os.getenv("PLAYER_EVENT")

    # simply ignore this event
    ignored_states = ["volume_set", "started", "changed", "preloading"]
    if state is None or state in ignored_states:
        return

    # initialize cache and spotify
    cache = Cache()
    spotify = SpotifyWebApi(CLIENT_ID, CLIENT_SECRET)

    # Update state in cache
    cache.state = state

    # Get song info using Spotify API
    track_uri = os.getenv("TRACK_ID")
    info = spotify.get_track_info(track_uri, cache)

    error = True if "error" in info else False

    # send a notification to show in OS as a popup
    notify_system(state, info, error)

    # and finally, notify the custom music daemon
    notify_daemon(state, info, error)

    cache.save_to_file()


# ------------------------------------------------------------------------------------------------ #

if __name__ == '__main__':
    try:
        main()
    except PidFileError as e:
        # that's ok, you can have only one instance running simultaneously
        pass
