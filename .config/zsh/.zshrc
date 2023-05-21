# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# PowerLevel10k - to customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.npm-global/bin:$PATH

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
    fast-syntax-highlighting
    zsh-autosuggestions
    docker
    docker-compose
)

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Plugins - BGNotify
function bgnotify_formatted {
    elapsed="$(( $3 % 60 ))s"
    (( $3 >= 60 )) && elapsed="$((( $3 % 3600) / 60 ))m $elapsed"
    (( $3 >= 3600 )) && elapsed="$(( $3 / 3600 ))h $elapsed"
    [ $1 -eq 0 ] && bgnotify "#success 👍 ($elapsed)" "$2" || bgnotify "#fail 👎 ($elapsed)" "$2"
#   fi
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

# Development
dev() {
  if [ -z "$@" ]; then
    cd ~/projects/;
  else
    cd ~/projects/$@;
  fi
}
compctl -/ -W ~/projects dev

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
unsetopt beep

# Use ssh with this alias
alias s="TERM=xterm-256color kitty +kitten ssh"
alias clear-nvim="rm -rf ~/.local/share/nvim/ ~/.cache/nvim ~/.local/state/nvim"

# Enable gtest color by default
# (read this: https://github.com/kovidgoyal/kitty/issues/4400#issuecomment-1002518875)
export GTEST_COLOR=yes

# Number format convertors
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
