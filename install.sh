#!/usr/bin/env bash
#
# Install @v1nns/dotfiles on Arch-based systems
# Author: Vinicius M. Longaray
#

set -euo pipefail

# Base packages to be installed using pacman
pacman_default=('base-devel' # Basic tools to build packages
  'git'                      # Version control
  'neovim'                   # Code editor
  'nemo'                     # File browser
  'tmux'                     # Term multiplexer
  'zellij'                   # Another term multiplexer
  'kitty'                    # Terminal emulator
  'wget'                     # Download files
  'alsa-firmware'            # For audio
  # 'sof-firmware'  # For audio on notebook
  'docker' # Container virtualization

  # CLI Power Basics
  'bat'       # Better cat
  'bc'        # Calculator
  'broot'     # Dir navigation
  'duf'       # Better df
  'eza'       # Better ls
  'fd'        # Better find
  'fzf'       # Fuzzy-finder
  'hyperfine' # Benchmarking for commands
  'jq'        # JSON parser
  'most'      # Better less
  'procs'     # Better ps
  'ripgrep'   # Better grep
  'tokei'     # Count total lines of code
  'termdown'  # Timer
  'feh'       # Image viewer

  # z-shell
  'zsh'

  # Development
  'cmake'
  'clang'

  'rustup'

  'nodejs'
  'npm'

  'python'
  'python-dbus'
  'python-gobject'
  'python-pip'
  'python-lsp-server'
  'python-requests'
  'python-systemd'
  'python-gtts'
  'python-mpv'
  'autopep8'

  # Monitoring, management and stats
  'btop'          # System resource monitoring
  'ctop'          # Container resource monitoring
  'gping'         # Interactive ping tool
  'speedtest-cli' # Command line speed test utility

  # Audio-related (considering pipewire+wireplumber are already installed)
  'pipewire-libcamera'
  'realtime-privileges'
  'pavucontrol'
  'pasystray'
  'pamixer'
  'qpwgraph'
  'lsp-plugins-lv2'
  'calf'
  'easyeffects'
  'playerctl' # Control media players via MPRIS
  'ncspot'    # TUI Spotify client

  # Video
  'vlc'
  'mpv'
  'ffmpeg' # ffplay

  # Misc
  'brightnessctl' # Control screen brightness
  'gnome-keyring' # Store security credentials
  'dunst'         # Notification daemon
  'firefox'       # Internet browser
  'qalculate-gtk' # Calculator
  'yt-dlp'        # YouTube downloader
  'obsidian'      # Notes
  'libnotify'     # notify-send command
  'xdg-user-dirs' # Manage user directories

  # CLI Fun
  'lolcat'   # Rainbow colored terminal output
  'fastfetch' # Show system info

  # Utils
  'unzip'     # File archiver
  'net-tools' # ifconfig command
  'man-pages' # man database
  'man-db'    # man command
  'zathura'   # PDF viewer
  'zathura-cb'
  'zathura-pdf-mupdf'
  'yazi'      # TUI file browser
  'grim'      # Screenshot

  # User-interface
  'noto-fonts'           # GTK default font
  'noto-fonts-emoji'     # Support for emojis
  #'sddm'                 # Display manager (greeter)

  'atuin'                # Shell history
)

# Packages to use within Wayland
pacman_wayland=(
  'hyprland'     # Compositor (hyprland.lua requires a recent version)
  'waybar'       # Status bar (used by hyprland.conf)
  'hyprpaper'    # Set wallpaper
  'nwg-look'     # Customize GTK settings
  'swayidle'     # Idle management daemon
  'wl-clipboard' # Copy/paste utilities
  'fcitx5'       # For compatibility with keyboard using US intl layout (i.e. microsoft edge)
  'socat'        # Listen for socket events
  'hyprlock'     # Screen locker
  'hypridle'     # Idle management daemon
  'rofi'         # Dialog utilities (menu/launcher/etc)
  'cliphist'     # Clipboard history
  'qt5ct'        # Qt5 theme settings
  'fcitx5-gtk'   # fcitx5 GTK input module
  'fcitx5-qt'    # fcitx5 Qt input module
  'slurp'        # Get screen region on wayland
)

# Packages to use within X11 (considering archinstall already installed i3wm)
pacman_x11=(
  'lxappearance' # Customize GTK settings
  'picom'        # Compositor
  'polybar'      # Status bar
  'rofi'         # Dialog utilities (menu/launcher/etc)
  'xclip'        # Copy/paste utilities
  'xdotool'      # Fake keyboard/mouse input, window management
  'xsel'         # Manage contents of the X selection
  'xss-lock'     # Idle screen lock utility
  'yad'          # GTK calendar
  'python-i3ipc' # i3 IPC for custom scripts
)

# Base packages from AUR
yay_default=(
  'zplug'         # zsh plugin manager
  'google-chrome' # Internet browser
  'brave-bin'     # Another good browser
  'microsoft-edge-stable-bin' # Browser used on work mode
  'iwgtk'         # Wi-Fi manager

  'dracula-cursors-git'      # GTK cursor
  'papirus-icon-theme-git'   # GTK icons
  'tokyonight-gtk-theme-git' # GTK theme

  'python-pid'
  'python-spotipy'

  # Fonts (Nerd Font)
  'ttf-hack-nerd'
  'ttf-iosevka-nerd'
  'ttf-jetbrains-mono-nerd'

  # for battery save
  # 'auto-cpufreq'
)

yay_wayland=(
  'wlogout'                # Logout menu
  'hyprpolkitagent'        # Polkit authentication daemon
  'hyprswitch'             # Switch between windows in hyprland
  'pwvucontrol'            # Pipewire volume control
  'xembedsniproxy'         # Tray support for XEmbed applications
  'noctalia-git'           # Desktop shell (used by hyprland.lua)

  'sysc-greet-hyprland'    # TUI greeter
)

# ANSI color codes
PURPLE='\033[0;35m'
RED='\033[0;91m'
GREEN='\033[0;92m'
YELLOW='\033[0;93m'
CYAN_B='\033[1;96m'
LIGHT='\x1b[2m'
RESET='\033[0m'

# Directory where this script lives
declare -r DOTFILES=$(dirname "$(realpath "$0")")

intro() {
  echo -e "\n${PURPLE}"
  echo -e "\t██████╗░░█████╗░████████╗███████╗██╗██╗░░░░░███████╗░██████╗"
  echo -e "\t██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██║██║░░░░░██╔════╝██╔════╝"
  echo -e "\t██║░░██║██║░░██║░░░██║░░░█████╗░░██║██║░░░░░█████╗░░╚█████╗░"
  echo -e "\t██║░░██║██║░░██║░░░██║░░░██╔══╝░░██║██║░░░░░██╔══╝░░░╚═══██╗"
  echo -e "\t██████╔╝╚█████╔╝░░░██║░░░██║░░░░░██║███████╗███████╗██████╔╝"
  echo -e "\t╚═════╝░░╚════╝░░░░╚═╝░░░╚═╝░░░░░╚═╝╚══════╝╚══════╝╚═════╝░"
  echo -e "\n\t   >>> Starting script to install dotfiles from @v1nns <<<${RESET}"
}

outro() {
  echo -e "${PURPLE}Finished installing dotfiles. Have fun! =)${RESET}"
}

check_requirements() {
  # Check pacman actually installed
  if ! hash pacman 2>/dev/null; then
    echo -e "${RED}Pacman doesn't seem to be present on your system. Exiting...${RESET}"
    exit 1
  fi

  # Check if running as root, and prompt for password if not
  if [ "$EUID" -ne 0 ]; then
    echo -e "${YELLOW}Elevated permissions are required to adjust system settings."
    echo -e "${CYAN_B}Please enter your password...${RESET}"
    if ! sudo -v; then
      echo -e "${RED}Exiting, as not being run as sudo...${RESET}"
      exit 1
    fi
  fi
}

update_database() {
  echo -e "${GREEN}Updating database...${RESET}"
  sudo pacman -Syu --noconfirm
}

set_timezone() {
  echo -e "" >&2
  read -n 1 -r -s -p "Do you want to change timezone to America/Sao_Paulo? (y/N)" answer
  echo -e "" >&2

  case $answer in
  y)
    echo -e "${GREEN}Changing timezone and updating hwclock...${RESET}"
    sudo timedatectl set-timezone America/Sao_Paulo
    sudo timedatectl set-local-rtc 1
    sudo hwclock --systohc
    ;;
  *) : ;;
  esac
}

install_pacman_packages() {
  local arr=("$@")
  for package in "${arr[@]}"; do
    if [[ $(pacman -Qk "${package,,}" 2>/dev/null) == *"total files"* ]]; then
      echo -e "${YELLOW}[Skipping]${LIGHT} ${package} is already installed${RESET}"
    else
      echo -e "${PURPLE}[Installing]${LIGHT} Downloading ${package}...${RESET}"
      sudo pacman -S "${package}" --needed --noconfirm
    fi
  done
}

install_yay_packages() {
  local arr=("$@")
  for package in "${arr[@]}"; do
    if [[ $(pacman -Qk "${package,,}" 2>/dev/null) == *"total files"* ]]; then
      echo -e "${YELLOW}[Skipping]${LIGHT} ${package} is already installed via yay${RESET}"
    else
      echo -e "${PURPLE}[Installing]${LIGHT} Downloading ${package}...${RESET}"
      yay -S "${package}" --noconfirm --answerdiff None --answerclean None
    fi
  done
}

install_base() {
  echo -e "${GREEN}Installing base packages...${RESET}"
  install_pacman_packages "${pacman_default[@]}"
}

install_yay() {
  if ! command -v yay &>/dev/null; then
    echo -e "${GREEN}Installing yay...${RESET}"
    rm -rf /tmp/yay
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd "${DOTFILES}"
  fi

  echo -e "${GREEN}Installing yay packages...${RESET}"
  install_yay_packages "${yay_default[@]}"
}

add_user_to_groups() {
  echo -e "${GREEN}Adding logged user to some required groups...${RESET}"
  sudo groupadd -f docker
  sudo usermod -aG input,realtime,docker "$USER"
  sudo systemctl enable --now docker
}

disable_login_lock() {
  echo -e "${GREEN}Disabling access lock after consecutive authentication failures...${RESET}"
  sudo sed -i 's/# deny.*$/deny = 0/' /etc/security/faillock.conf
}

copy_configs() {
  echo -e "${GREEN}Copying all programs configs...${RESET}"
  shopt -s extglob
  mkdir -p $HOME/.config

  cp -sRf ${DOTFILES}/.config/* $HOME/.config/
}

install_wallpaper() {
  echo -e "${GREEN}Installing wallpapers...${RESET}"
  mkdir -p $HOME/Pictures/Wallpapers/

  cp ${DOTFILES}/wallpaper/* $HOME/Pictures/Wallpapers/
}

install_greeter() {
  echo -e "${GREEN}Installing greeter for SDDM (arcade theme)...${RESET}"
  git clone https://github.com/v1nns/sddm-arcade /tmp/arcade
  sudo mv /tmp/arcade /usr/share/sddm/themes/arcade

  sudo mkdir -p /etc/sddm.conf.d/
  sudo tee /etc/sddm.conf.d/theme.conf <<EOF
[Theme]
# Current theme name
Current=arcade
EOF
}

# Package sysc-greet-hyprland already creates the greeter user and its home dir
install_sysc_greet() {
  echo -e "${GREEN}Installing greeter for greetd (sysc-greet)...${RESET}"
  sudo install -m 644 "${DOTFILES}/.config/sysc-greet/hyprland-greeter-install.conf" /etc/greetd/hyprland-greeter-config.conf

  sudo tee /etc/greetd/config.toml <<EOF
[terminal]
vt = 1

[default_session]
command = "start-hyprland -- -c /etc/greetd/hyprland-greeter-config.conf"
user = "greeter"
EOF

  # Avoid greeter session messing with audio
  local greeter_units="/var/lib/greeter/.config/systemd/user"
  sudo mkdir -p "${greeter_units}"
  for unit in pipewire pipewire-pulse wireplumber; do
    sudo ln -sf /dev/null "${greeter_units}/${unit}.service"
  done
  sudo chown -R greeter:greeter /var/lib/greeter/.config

  # Replace any other display manager already enabled
  sudo systemctl enable --force greetd.service
}

install_custom_icons() {
  echo -e "${GREEN}Installing custom icons...${RESET}"
  mkdir -p $HOME/.local/share
  cp -sRf ${DOTFILES}/.local/share/icons $HOME/.local/share/
}

install_custom_scripts() {
  echo -e "${GREEN}Installing custom scripts...${RESET}"
  mkdir -p $HOME/.local
  cp -sRf ${DOTFILES}/.local/bin $HOME/.local/
}

install_desktop_apps() {
  echo -e "${GREEN}Installing custom desktop applications...${RESET}"
  mkdir -p $HOME/.local/share
  cp -sRf ${DOTFILES}/.local/share/applications $HOME/.local/share/
}

install_systemd_services() {
  echo -e "${GREEN}Installing custom systemd services...${RESET}"
  mkdir -p "$HOME/.local/share"
  cp -sRf "${DOTFILES}/.local/share/systemd" "$HOME/.local/share/"
  systemctl --user daemon-reload
  systemctl --user enable easyeffects.service
}

install_git_config() {
  echo -e "${GREEN}Installing git config...${RESET}"
  ln -sf "${DOTFILES}/.config/git/.gitconfig" "$HOME/.gitconfig"
  ln -sf "${DOTFILES}/.config/git/.gitignore_global" "$HOME/.gitignore_global"
}

install_ohmyzsh() {
  echo -e "${GREEN}Installing oh-my-zsh, power10k theme and custom plugins...${RESET}"
  local custom_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi

  if [ ! -d "${custom_dir}/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${custom_dir}/themes/powerlevel10k"
  fi

  rm -f "$HOME/.zshrc"
  ln -sf "${DOTFILES}/.config/zsh/.zshrc" "$HOME/.zshrc"
  ln -sf "${DOTFILES}/.config/zsh/.zshenv" "$HOME/.zshenv"
  ln -sf "${DOTFILES}/.config/zsh/.p10k.zsh" "$HOME/.p10k.zsh"

  if [ ! -d "${custom_dir}/plugins/F-Sy-H" ]; then
    git clone https://github.com/z-shell/F-Sy-H.git "${custom_dir}/plugins/F-Sy-H"
  fi

  if [ "$(getent passwd "$USER" | cut -d: -f7)" != "/usr/bin/zsh" ]; then
    chsh -s /usr/bin/zsh
  fi
}

install_x11() {
  echo -e "${GREEN}Installing X11 packages...${RESET}"
  install_pacman_packages "${pacman_x11[@]}"

  # TODO: This copy should also be done for wayland
  echo -e "${GREEN}Installing X11 configs...${RESET}"
  cp ${DOTFILES}/x11/xprofile $HOME/.xprofile
  cp ${DOTFILES}/x11/xresources $HOME/.xresources

  ln -sf "${DOTFILES}/x11/shutdown.desktop" "$HOME/.local/share/applications/shutdown.desktop"

  # TODO: include /etc/profile with PATH dir
}

install_wayland() {
  echo -e "${GREEN}Installing Wayland packages...${RESET}"
  install_pacman_packages "${pacman_wayland[@]}"
  install_yay_packages "${yay_wayland[@]}"

  echo -e "${GREEN}Installing Wayland scripts...${RESET}"
  cp -sf "${DOTFILES}"/wayland/*.sh "$HOME/.local/bin/"

  install_sysc_greet

  install_wayland_plugins
}

install_wayland_plugins() {
  if ! command -v hyprpm &>/dev/null; then
    echo -e "${YELLOW}[Skipping]${LIGHT} hyprpm not found, no plugins installed${RESET}"
    return
  fi

  echo -e "${GREEN}Installing Wayland plugins...${RESET}"
  hyprpm update
  hyprpm add https://github.com/outfoxxed/hy3
  hyprpm enable hy3
  hyprpm update
  hyprpm add https://github.com/zakk4223/hyprland-easymotion
  hyprpm enable hyprEasymotion
  hyprpm update
}

pick_display_server() {
  echo -e "\nSelect an installation option:\n" >&2
  echo -e "  1) Wayland;" >&2
  echo -e "  2) X11;" >&2
  echo -e "  3) Skip this step;\n" >&2

  read -n 1 -r -p "Enter a number:" choice
  echo -e "" >&2

  case $choice in
  1) install_wayland ;;
  2) install_x11 ;;
  *) : ;;
  esac
}

setup_rust() {
  if command -v rustup &>/dev/null; then
    echo -e "${GREEN}Setting up Rust toolchain...${RESET}"
    rustup default stable
  fi
}

# TODO: create fancontrol settings (ask if user wants it)
# 1. copy fancontrol file to /etc
# 2. echo "blacklist nct6683" | sudo tee /etc/modprobe.d/nct6683.conf
# 3. Force remove nct6683 and load nct6687:
# sudo modprobe -r nct6683
# sudo modprobe nct6687
# 4. Ensure nct6687 loads at boot:
# echo "nct6687" | sudo tee /etc/modules-load.d/nct6687.conf

####################################################################################################

# TODO:
# create list picker
#
#zenity  --list --checklist \
#   --title="Dotfiles installation"\
#   --column="Select"  \
#   --column="Option"  \
#   --column="Description"  \
#TRUE "teste1" "um teste elaborado"\
#FALSE "teste2" "um teste elaborado"\
#TRUE "teste3" "um teste elaborado"

intro
check_requirements
update_database
set_timezone
install_base
setup_rust
install_yay
add_user_to_groups
disable_login_lock
copy_configs
install_wallpaper
# install_greeter
# update README with new stuff
install_custom_icons
install_custom_scripts
install_desktop_apps
install_systemd_services
install_git_config
install_ohmyzsh
pick_display_server
outro
