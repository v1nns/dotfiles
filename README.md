# Dotfiles

Surely, dotfiles are really personal, but yet it is something good to share and
check how others customize your own desktop.

Lately, I've been using i3-gaps + polybar with my own custom theme, and there is
one thing I can tell you for sure: ricing can be very addictive!

### Screenshot :star_struck:

![](screenshot/screenshot3.png?raw=true)

**You can check the older ones inside the **screenshot** folder.*

## Motivation :monocle_face:

Using the GNOME as default GUI was getting really boring, and a few stutterings
were annoying me.

## Package dependencies :link:

* zsh
* oh-my-zsh
* powerlevel10k theme for zsh
* rofi
* dunst
* jq
* feh *~OR~* nitrogen (used this to set a different background for each monitor)
* imwheel
* i3-gaps
* polybar
* picom
* spotify
* yad
* maim
* pasystray
* numlockx
* lxappearance

Also, I've installed Hack font.

**I'm using Ubuntu distro and some of these packages are not available by
default. In order for you to install it using your default package manager, the
easiest way is to add PPA from Regolith.*
## Installation guide (still fixing it :construction_worker:)

```bash
git clone (...)
cd ./dotfiles
cp ./wallpaper/* ~/Pictures/Wallpapers/
cp -sR .../full/path/dotfiles/.config/* ~/.config/
cp -sR .../full/path/dotfiles/.local/* ~/.local/
```

**GNU **cp** has an option to create symlinks instead of copying (-s).*


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

## TODO :memo:

There a few things missing, like:

- [x] Improve color palette on Cosmonaut's theme.
- [x] Find an alternative to Spotify client as a running service.
- [ ] Improve installation guide;
- [ ] Check all package dependencies;
- [ ] A good script to install these files automatically, including
  dependencies;
- [ ] Add global gitignore config;
