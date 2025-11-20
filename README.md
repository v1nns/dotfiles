<h1 align="center">
  <br>
  dotfiles :rocket:
  <br>
</h1>

Surely, dotfiles are really personal, but yet it is something good to share and
check how others customize your own desktop.

Lately, I've been using hyprland + waybar with my own custom theme based on Tokyo Night color palette,
and there is one thing I can tell you for sure: <b>ricing can be very addictive!</b>

![](screenshot/screenshot5.png?raw=true)

<p align="center"><sup>Current screenshot (check the older ones inside the <b>screenshot</b> folder)</sup></p>

## Motivation :monocle_face:

Using the GNOME as default GUI was boring, and since I've started using a tiling window manager,
there was no turning back. So when I started ricing my desktop, I saw a lot of unmaintained packages
in the official Ubuntu Package Archive and that's why I also decided to move away from Ubuntu,
I use Arch BTW :stuck_out_tongue:

## Installation guide (WIP :construction_worker:)

Instead of manually configure everything, I created a draft of an installation script (install.sh).
It is not finished yet, so be careful! At least, you may check it to see all packages that I have
installed currently or even to check how I configure all my stuff (greeter screen, GTK style,
custom icons, systemd services, neovim settings, etc).

### A journey into sound :musical_note:

We both know that sometimes it is not possible to code without any background
music, so I went on a quest in search of an alternative to Spotify client which
wouldn't be so hungry for RAM.

When I had no more hope searching it, I've found a good alternative (no longer fully working):
- ~~**Music server**: Mopidy + Mopidy-MPD + Mopidy-Spotify;~~
- ~~**Console client**: mpc (global keybinds on i3 config) + ncmpcc (TUI/text-based user interface).~~

I'm currently using librespot to play songs from Spotify, and sometimes I use my own personal project
called [spectrum](https://github.com/v1nns/spectrum), which can play any local song and exists an
open PR to support YouTube songs.

## Final considerations :lotus_position:

Last but not least, a rice is never *done*.

## TODO list :memo:

- [x] Improve color palette on Cosmonaut's theme.
- [x] Find an alternative to Spotify client as a running service.
- [x] Improve installation guide;
- [x] Check all package dependencies;
- [x] A good script to install these files automatically, including dependencies;
- [ ] Add global gitignore config;
- [ ] Update all new configs in the install.sh;
