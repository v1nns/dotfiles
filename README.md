<h1 align="center">
  <br>
  dotfiles :rocket:
  <br>
</h1>

Surely, dotfiles are really personal, but yet it is something good to share and
check how others customize your own desktop.

Lately, I've been using i3 + polybar with my own custom theme, and there is one
thing I can tell you for sure: <b>ricing can be very addictive!</b>

![](screenshot/screenshot4.png?raw=true)

<p align="center"><sup>Current screenshot (check the older ones inside the <b>screenshot</b> folder)</sup></p>

## Motivation :monocle_face:

Using the GNOME as default GUI was getting really boring, and a few stutterings
were annoying me. So I also decided to move away from Ubuntu, I use Arch BTW =P

## Installation guide (WIP :construction_worker:)

Instead of manually configure everything, I created a draft of an installation script (install.sh).
It is not finished yet, neither did a fresh install with it, so be careful! At least, you may check
it to see all packages that I have installed currently or even to check how I configure all my stuff
(greeter screen, GTK style, custom icons, systemd services, neovim settings, etc).

### Possible modifications you may want to do

About polybar, there are a few things which can change on different computers:
* Change "**monitor**" value in *.config/polybar/cosmonaut/config.ini* to
match your own monitor which you want to show the bar;
* Change "**hwmon-path**" value in *.config/polybar/cosmonaut/modules.ini* to
  match your own CPU temperature.

And if you use *pulseaudio*, you can modify the last lines in
*.config/pulse/default.pa* to match your own sink and source.

### A journey into sound :musical_note:

We both know that sometimes it is not possible to code without any background
music, so I went on a quest in search of an alternative to Spotify client which
wouldn't be so hungry for RAM.

When I had no more hope searching it, I've found a good alternative*:
* **Music server**: Mopidy + Mopidy-MPD + Mopidy-Spotify;
* **Console client**:
    * mpc (global keybinds on i3 config)
    * ncmpcc (TUI/text-based user interface).

For more info about how to install Mopidy and its extensions, you can check
this: https://docs.mopidy.com/en/latest/running/service/

And for more options to use as MPD client, you can check this:
https://mpd.fandom.com/wiki/Clients

**I know it is a lot of tools for just one purpose, but I can tell you, it is
working really fine!*

## Final considerations :lotus_position:

Last but not least, a rice is never *done*.

## TODO list :memo:

- [x] Improve color palette on Cosmonaut's theme.
- [x] Find an alternative to Spotify client as a running service.
- [x] Improve installation guide;
- [x] Check all package dependencies;
- [ ] A good script to install these files automatically, including
  dependencies (in progress);
- [ ] Add global gitignore config;
