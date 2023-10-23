#!/usr/bin/env python3
"""Say this
Author: Vinicius M. Longaray

This script allows the user to generate audio based on the given text passed through command
argument (usually known as text-to-speech or TTS). The main difference is that in addition to
generating the audio, it will redirect the playback to a specific audio input. In other words,
you may use the "Google" voice to say anything and redirect that into any communication app.

P.S.: you must change DEFAULT_INPUT for the desired program

Usage example:
> say_this.py -t "Olá, estou testando isso"

Dependencies:
- Pipewire as audio server
- mpv
- Python 3rd-party libraries (gTTS and jaseg/python-mpv)

"""
import argparse
import os
import sys
import time

from gtts import gTTS
from mpv import MPV

DEFAULT_FILE_PATH = "/tmp/tts.mp3"
DEFAULT_INPUT = "<INSERT-HERE>"  # use "pw-link -i" to determine which input you wanna use it
DEFAULT_PLAYER = "mpv"

# --------------------------------------- Argument parsing --------------------------------------- #


# Available commands
def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Convert text-to-speech and play it directly on input source.")

    media_group = parser.add_mutually_exclusive_group()

    media_group.add_argument('-t', '--text',
                             help="Text to convert into spoken audio",
                             type=str)

    args = parser.parse_args()

    if not any(vars(args).values()):
        parser.print_help()
        sys.exit()

    return args


# ------------------------------------------ Main method ----------------------------------------- #


def main():
    # evaluate command arguments
    args = parse_arguments()

    # generate text-to-speech
    tts = gTTS(args.text, lang='pt', slow=False)
    tts.save(DEFAULT_FILE_PATH)

    # create mpv instance to play the generated audio
    player = MPV()

    # load the generated audio file and pause mpv
    player.play(DEFAULT_FILE_PATH)
    player.pause = not player.pause

    # wait for a bit before trying to link audio in pipewire
    time.sleep(1)

    # link output from player to input from desired program
    os.system("pw-link \"{0}:output_FL\" \"{1}:input_FL\"".format(DEFAULT_PLAYER, DEFAULT_INPUT))
    os.system("pw-link \"{0}:output_FR\" \"{1}:input_FR\"".format(DEFAULT_PLAYER, DEFAULT_INPUT))

    # start playing
    player.pause = not player.pause
    player.wait_for_playback()

    # undo link between player and input
    os.system("pw-link -d \"{0}:output_FL\" \"{1}:input_FL\"".format(DEFAULT_PLAYER, DEFAULT_INPUT))
    os.system("pw-link -d \"{0}:output_FR\" \"{1}:input_FR\"".format(DEFAULT_PLAYER, DEFAULT_INPUT))


# ------------------------------------------------------------------------------------------------ #

if __name__ == '__main__':
    main()
