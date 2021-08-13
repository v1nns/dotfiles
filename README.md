# Dotfiles

Surely, dotfiles are really personal, but yet it is something good to share and check how others customize your own desktop.

Lately, I've been using i3-gaps + polybar with my own custom theme, and there is one thing I can tell you for sure: ricing can be very addictive!

### TODO

There a few things missing, like:

* Improve installation guide;
* Check all package dependencies;
* A good script to install these files automatically, including dependencies;
* Add global gitignore config;
* Improve color palette on Cosmonaut's theme.

### Screenshot

![](screenshot/screenshot2.png?raw=true)

## Motivation

Using the GNOME as default GUI was getting really boring, and a few stutterings were annoying me.

## Package dependencies

* zsh
* oh-my-zsh
* powerlevel10k theme for zsh
* feh
* imwheel
* i3-gaps
* polybar
* picom
* spotify
* yad

Also, I've installed Hack font.

**I'm using Ubuntu distro and some of these packages are not available by default. In order for you to install it using your default package manager, the easiest way is to add PPA from Regolith.*
## Installation guide (still fixing it)

```bash
git clone (...)
cd ./dotfiles
cp ./wallpaper/* ~/Pictures/Wallpapers/
cp -rs ./.config/* ~/.config/
cp -rs ./.local/* ~/.config/
```

* GNU **cp** has an option to create symlinks instead of copying (-s).

## Final considerations

Last but not least, a rice is never *done*.