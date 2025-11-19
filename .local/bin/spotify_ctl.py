#!/usr/bin/env python3
"""Spotify Media Controller
Author: Vinicius M. Longaray

This script allows the user to control media using Spotify Web API (through
spotipy library, of course). It is based on the idea of having a default device,
so you can simply play/pause song, or even change its volume. Currently, I'm
using it with the device created by librespot (based on Spotify Connect API).

In order to execute it, the script requires that you have an app created in
Developer's dashboard from Spotify account, otherwise, you won't be able to
retrieve information from the current song playing. After you have created the
app, set CLIENT_ID and CLIENT_SECRET properly. You must also set DEFAULT_DEVICE
and DEFAULT_CACHE_PATH.

Usage example:
> spotify_ctl.py --toggle-play

"""
import argparse
import dbus
import spotipy
import sys
import os

from pathlib import Path
from spotipy.oauth2 import SpotifyOAuth
from time import sleep

CLIENT_ID = ""
CLIENT_SECRET = ""

REDIRECT_URI = "http://127.0.0.1:8888/callback"

DEFAULT_DEVICE = "vinicius@cookie"

DEFAULT_CACHE_PATH = "/home/vinicius/.cache/spotipy/.credential"

# --------------------------------------- Argument parsing --------------------------------------- #


# Available commands to control media from Spotify
def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Media controller for Spotify.")

    media_group = parser.add_mutually_exclusive_group()

    media_group.add_argument('--toggle-play',
                             help="Start/Pause playback",
                             action="store_true")
    media_group.add_argument('--stop',
                             help="Stop playback",
                             action="store_true")
    media_group.add_argument('--next',
                             help="Skip to next track",
                             action="store_true")
    media_group.add_argument('--previous',
                             help="Skip to previous track",
                             action="store_true")
    media_group.add_argument('--inc-volume',
                             help="Increment playback volume",
                             action="store_true")
    media_group.add_argument('--dec-volume',
                             help="Decrement playback volume",
                             action="store_true")

    args = parser.parse_args()

    if not any(vars(args).values()):
        parser.print_help()
        sys.exit()

    return args


# --------------------------------- Spotify OAuth Authentication --------------------------------- #


def authenticate_on_spotify(client_id, client_secret) -> spotipy.Spotify:
    # in case of an inexistent parent directory, create manually
    cache_dir = Path(DEFAULT_CACHE_PATH).parent.absolute()
    if not os.path.exists(cache_dir):
        os.mkdir(cache_dir)

    scope = "user-read-playback-state,user-modify-playback-state"
    spotify = spotipy.Spotify(
        auth_manager=SpotifyOAuth(client_id=client_id,
                                  client_secret=client_secret,
                                  scope=scope,
                                  redirect_uri=REDIRECT_URI,
                                  cache_handler=spotipy.CacheFileHandler(
                                      cache_path=DEFAULT_CACHE_PATH),
                                  open_browser=True), requests_timeout=2)

    return spotify


# -------------------------------------- Notify Music Daemon ------------------------------------- #


def notify_daemon_music_stopped():
    """
    This is the multiverse of MEDness, as Spotify doesn't have an API method
    to stop the music (other than 'pause'), we do what we gotta do to notify
    to daemon that music has stopped
    """
    try:
        # Get published interface methods by Music Event Daemon (MED)
        bus = dbus.SessionBus()
        object = bus.get_object("org.vinns.musicdaemon",
                                "/org/vinns/musicdaemon")
        interface = dbus.Interface(object, "org.vinns.musicdaemon")

        # Wait for librespot to receive the event
        sleep(1)
        interface.stop()

    except Exception:
        # Just ignore the exception, possibly, it didn't find any running music daemon to notify
        pass


# ------------------------------------------ Main method ----------------------------------------- #


def main():
    # evaluate command arguments
    args = parse_arguments()

    spotify = authenticate_on_spotify(CLIENT_ID, CLIENT_SECRET)

    # Get playing devices and find for ID from default device
    device_id = ""
    volume = 0
    devices = spotify.devices()["devices"]

    for device in devices:
        if device["name"] == DEFAULT_DEVICE:
            device_id = device["id"]
            volume = device["volume_percent"]
            break

    if not device_id:
        sys.exit("Did not find default device")

    # Simulate a toggle event to play/pause current track
    if args.toggle_play:
        # Parse information from playback state to proceed with proper operation
        curr_state = spotify.current_playback()

        # If it's the first time you are trying to play some music, it won't
        # have a valid curr_state. So, in order to get track context from
        # before, must use "transfer_playback" function from Spotipy API
        if curr_state is None:
            spotify.transfer_playback(device_id=device_id)
        elif not curr_state["is_playing"]:
            spotify.start_playback(device_id=device_id)
        else:
            spotify.pause_playback(device_id=device_id)

    # Simply pause playback
    if args.stop:
        spotify.pause_playback(device_id=device_id)
        notify_daemon_music_stopped()

    # Skip to next song
    if args.next:
        spotify.next_track(device_id=device_id)

    # Skip to previous song
    if args.previous:
        spotify.previous_track(device_id=device_id)

    # Increment volume percent
    if args.inc_volume:
        def increase(a, b):
            return a + b if a + b <= 100 else 100
        volume = increase(volume, 5)
        spotify.volume(device_id=device_id, volume_percent=volume)

    # Decrement volume percent
    if args.dec_volume:
        def decrease(a, b):
            return a - b if a - b >= 0 else 0
        volume = decrease(volume, 5)
        spotify.volume(device_id=device_id, volume_percent=volume)


# ------------------------------------------------------------------------------------------------ #

if __name__ == '__main__':
    main()