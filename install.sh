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
  'wget'                     # Download files
  'alsa-firmware'            # For audio
  # 'sof-firmware'  # For audio on notebook
  'docker' # Container virtualization

  # CLI Power Basics
  'ack'       # Yet another better grep
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
  "feh"       # Image viewer

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
  'python-gi'
  'python-gobject'
  'python-pip'
  'python-lsp-server'
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

  # Video
  'vlc'
  'mpv'

  # Misc
  'brightnessctl' # Control screen brightness
  'gnome-keyring' # Store security credentials
  'dunst'         # Notification daemon
  'firefox'       # Internet browser
  'qalculate-gtk' # Calculator

  # CLI Fun
  'lolcat'   # Rainbow colored terminal output
  'neofetch' # Show system info

  # Utils
  'unzip'     # File archiver
  'net-tools' # ifconfig command
  'man-pages' # man database
  'man-db'    # man command
  'zathura'   # PDF viewer
  'zathura-cb'
  'zathura-pdf-mupdf'
  'yazi'      # TUI file browser

  # User-interface
  'noto-fonts-emoji'     # Support for emojis
  'qt5'                  # Dependency for sddm
  'qt5-quickcontrols'    # Dependency for sddm
  'qt5-graphicaleffects' # Dependency for sddm
  #'sddm'                 # Display manager (greeter)
)

# Packages to use within Wayland (considering archinstall already installed Hyprland)
pacman_wayland=(
  'hyprpaper'    # Set wallpaper
  'nwg-look'     # Customize GTK settings
  'swayidle'     # Idle management daemon
  'waybar'       # Status bar
  'wl-clipboard' # Copy/paste utilities
  'fcitx5'       # For compatibility with keyboard using US intl layout (i.e. microsoft edge)
  'socat'        # Listen for socket events
  'hyprlock'     # Screen locker
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
)

# Base packages from AUR
yay_default=(
  'zplug'         # zsh plugin manager
  'google-chrome' # Internet browser
  'iwgtk'         # Wi-Fi manager

  'dracula-cursors-git'    # GTK cursor
  'papirus-icon-theme-git' # GTK icons

  'python-pid'

  # Fonts (Nerd Font)
  'ttf-hack-nerd'
  'ttf-iosevka'
  'ttf-jetbrains-mono-nerd'
  'ttf-jetbrains-nerd'

  # for battery save
  # 'auto-cpufreq'
)

yay_wayland=(
  'rofi-lbonn-wayland-git' # Dialog utilities (menu/launcher/etc)
  'wlogout'                # Logout menu
  'hyprpolkitagent'        # Polkit authentication daemon
  'hyprswitch'             # Switch between windows in hyprland
  'pwvucontrol'            # Pipewire volume control

  # TODO: create installer
  'sysc-greet-hyprland'    # TUI greeter

  # TODO: create installer section including extensions
  'vicinae-bin'
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
    echo "${RED}Pacman doesn't seem to be present on your system. Exiting...${RESET}"
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
  sudo usermod -aG input,realtime,docker "$(logname)"
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

  cp -sR ${DOTFILES}/.config/* $HOME/.config/
}

# TODO: maybe use install script from theme
install_gtk_theme() {
  echo -e "${GREEN}Installing GTK theme...${RESET}"
  rm -rf /tmp/tokyogtk
  git clone https://github.com/Fausto-Korpsvart/Tokyo-Night-GTK-Theme.git /tmp/tokyogtk

  mkdir -p "$HOME/.themes/"
  cp -r /tmp/tokyogtk/themes/Tokyonight-Dark-BL "$HOME/.themes/"
  # TODO: install gtk-4 also
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

install_custom_icons() {
  echo -e "${GREEN}Installing custom icons...${RESET}"
  mkdir -p $HOME/.local/share
  cp -sR ${DOTFILES}/.local/share/icons $HOME/.local/share/
}

install_custom_scripts() {
  echo -e "${GREEN}Installing custom scripts...${RESET}"
  mkdir -p $HOME/.local
  cp -sR ${DOTFILES}/.local/bin $HOME/.local/
}

install_desktop_apps() {
  echo -e "${GREEN}Installing custom desktop applications...${RESET}"
  mkdir -p $HOME/.local/share
  cp -sR ${DOTFILES}/.local/share/applications $HOME/.local/share/
}

install_systemd_services() {
  echo -e "${GREEN}Installing custom systemd services...${RESET}"
  mkdir -p "$HOME/.local/share"
  cp -sR "${DOTFILES}/.local/share/systemd" "$HOME/.local/share/"
  systemctl --user daemon-reload
}

install_ohmyzsh() {
  echo -e "${GREEN}Installing oh-my-zsh, power10k theme and custom plugins...${RESET}"
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

  rm -f "$HOME/.zshrc"
  ln -sf "${DOTFILES}/.config/zsh/.zshrc" "$HOME/.zshrc"
  ln -sf "${DOTFILES}/.config/zsh/.zshenv" "$HOME/.zshenv"
  ln -sf "${DOTFILES}/.config/zsh/.p10k.zsh" "$HOME/.p10k.zsh"

  git clone https://github.com/z-shell/F-Sy-H.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/F-Sy-H"

  chsh -s /usr/bin/zsh
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

  echo -e "${GREEN}Installing Wayland configs...${RESET}"
  ln -sf "${DOTFILES}/x11/shutdown.desktop" "$HOME/.local/share/applications/shutdown.desktop"

  echo -e "${GREEN}Installing Wayland scripts...${RESET}"
  cp -s "${DOTFILES}"/wayland/*.sh "$HOME/.local/bin/"

  install_wayland_plugins
}

install_wayland_plugins() {
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
install_gtk_theme
install_wallpaper
install_greeter
# update README with new stuff
install_custom_icons
install_custom_scripts
install_desktop_apps
install_systemd_services
install_ohmyzsh
pick_display_server
outro
