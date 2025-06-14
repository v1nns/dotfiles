# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# PowerLevel10k - to customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.npm-global/bin:/opt/flutter/bin:$PATH

# Export config to use it later by flutter
export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable

# Path to oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Standard themes can be found in ~/.oh-my-zsh/themes/*
# Custom themes may be added to ~/.oh-my-zsh/custom/themes/
ZSH_THEME="powerlevel10k/powerlevel10k"

# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    bgnotify
    git
    sudo
    #fast-syntax-highlighting
    #zsh-autosuggestions
    docker
    docker-compose
    tmux
)

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Enable TMUX by default on start
# export ZSH_TMUX_AUTOSTART=true

# Use neovim as to read manpage
export MANPAGER='nvim +Man!'

# Plugins - BGNotify
function bgnotify_formatted {
    elapsed="$(( $3 % 60 ))s"
    (( $3 >= 60 )) && elapsed="$((( $3 % 3600) / 60 ))m $elapsed"
    (( $3 >= 3600 )) && elapsed="$(( $3 / 3600 ))h $elapsed"
    [ $1 -eq 0 ] && bgnotify "#success 👍 ($elapsed)" "$2" || bgnotify "#fail 👎 ($elapsed)" "$2"
}
source $HOME/.oh-my-zsh/plugins/bgnotify/bgnotify.plugin.zsh

# enable fzf keybindings
source /usr/share/fzf/key-bindings.zsh
# enable fuzzy auto-completion
source /usr/share/fzf/completion.zsh

# Do not enter command lines into the history list if they are duplicates of the
# previous one.
setopt histignorealldups

# Bindkeys - Backward delete word
#bindkey -M emacs '^[[3;5~' kill-word
#bindkey -M emacs '^H' backward-kill-word
#bindkey -M emacs '^[[3;6~' kill-line

# Git related
alias amend='git commit --amend'
alias pullclean='git checkout develop && git reset --hard origin/develop && git pull'

# Generate completion files
compinit

# Development (directory navigation)
dev() {
  if [ -z "$@" ]; then
    cd ~/projects/;
  else
    # Do nothing when dir do not exist
    if [ ! -d ~/projects/$@ ]; then
      return
    fi

    cd ~/projects/$@;

    # Check which tiling manager is running
    if pgrep -x i3 > /dev/null; then
      # Filter index and name (if existing) from focused workspace (with i3)
      local index="$(i3-msg -t get_workspaces | jq -r 'map(select(.focused))[0].num')"
      local name="$(i3-msg -t get_workspaces | jq -r 'map(select(.focused))[0].name' | cut -d ':' -f 2 -s | xargs)"
      local count_nodes="$(i3-msg -t get_tree | jq -r 'recurse(.nodes[];.nodes!=null)|select(.nodes[].focused)|.nodes[]|.name' | wc -l)"

      # Only rename if workspace name is empty and it is the only window on it
      if [ -z "$name" ] && [ $count_nodes -eq 1 ]
      then
          # $input is empty, set workspace to "<number>:<dir>"
          i3-msg rename workspace to "$index:$*" > /dev/null
      fi
    elif pgrep -x Hyprland > /dev/null; then
      # Filter index and name (if existing) from focused workspace (with hyprland)
      local index="$(hyprctl activeworkspace -j | jq -r .id)"
      local name="$(hyprctl activeworkspace -j | jq -r .name | cut -d ':' -f 2 -s)"
      local count_nodes="$(hyprctl activeworkspace -j | jq -r .windows)"

      # Only rename if workspace name is empty and it is the only window on it
      if [ -z "$name" ] && [ $count_nodes -eq 1 ]; then
          hyprctl dispatch renameworkspace $index "$index:$*" > /dev/null
      fi
    fi
  fi
}
compctl -/ -W ~/projects dev

# Utility for say_this.py
say() {
  local msg
  msg="$*"
  say_this.py -t "$msg"
}

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt autocd
unsetopt beep

# Use ssh with this alias
alias s="TERM=xterm-256color kitty +kitten ssh"
alias clear-nvim="rm -rf ~/.local/share/nvim/ ~/.cache/nvim ~/.local/state/nvim"

# Enable gtest color by default
# (read this: https://github.com/kovidgoyal/kitty/issues/4400#issuecomment-1002518875)
export GTEST_COLOR=yes

# Base converters
bin2dec() {
   echo "obase=10; ibase=2; $1" | bc
}

bin2hex() {
   echo "obase=16; ibase=2; $1" | bc
}

dec2bin() {
   echo "obase=2; ibase=10; $1" | bc
}

dec2hex() {
   echo "obase=16; ibase=10; $1" | bc
}

hex2bin() {
   echo "obase=2; ibase=16; $1" | bc
}

hex2dec() {
   echo "obase=10; ibase=16; $1" | bc
}

oct2dec() {
   echo "obase=10; ibase=8; $1" | bc
}

dec2oct() {
   echo "obase=8; ibase=10; $1" | bc
}

# For plugins installed via pacman
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

eval "$(atuin init zsh)"
