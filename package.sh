#!/bin/bash
#
# Cross-Distro Linux System Manager

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Global package manager commands
detect_package_manager() {
  if command -v apt &>/dev/null; then
    PKG_TYPE="apt"
    PKG_UPDATE="sudo apt update"
    PKG_UPGRADE="sudo apt upgrade -y"
    PKG_REMOVE="sudo apt remove --purge -y"
    PKG_CLEAN="sudo apt autoremove -y"
    PKG_LIST="dpkg-query -W -f='\${binary:Package}\n'"
    PKG_INFO="apt-cache show"
  elif command -v dnf &>/dev/null; then
    PKG_TYPE="dnf"
    PKG_UPDATE="sudo dnf check-update"
    PKG_UPGRADE="sudo dnf upgrade -y"
    PKG_REMOVE="sudo dnf remove -y"
    PKG_CLEAN="sudo dnf autoremove -y"
    PKG_LIST="dnf list installed | awk '{print \$1}'"
    PKG_INFO="dnf info"
  elif command -v pacman &>/dev/null; then
    PKG_TYPE="pacman"
    PKG_UPDATE="sudo pacman -Sy"
    PKG_UPGRADE="sudo pacman -Su --noconfirm"
    PKG_REMOVE="sudo pacman -Rns --noconfirm"
    PKG_CLEAN="sudo pacman -Rns $(pacman -Qdtq)"
    PKG_LIST="pacman -Q | awk '{print \$1}'"
    PKG_INFO="pacman -Si"
  else
    echo -e "${RED}Error:${NC} Supported package manager not found."
    exit 1
  fi
}

# Dependency check
check_dependencies() {
  command -v fzf >/dev/null 2>&1 || {
    echo -e "${RED}Error:${NC} 'fzf' not found. Please install it."
    exit 1
  }
}

# UI and menus (same as original)...

# Override system_update
system_update() {
  print_header
  echo -e "${YELLOW}System Update${NC}\n"

  echo -e "${CYAN}[1/4]${NC} Updating system..."
  eval "$PKG_UPDATE"

  echo -e "\n${CYAN}[2/4]${NC} Upgrading packages..."
  eval "$PKG_UPGRADE"

  if command -v flatpak &>/dev/null; then
    echo -e "\n${CYAN}[3/4]${NC} Updating Flatpak apps..."
    flatpak update -y
  fi

  echo -e "\n${CYAN}[4/4]${NC} Cleaning up..."
  eval "$PKG_CLEAN"

  echo -e "\n${GREEN}System update complete!${NC}"
  read -p "Press Enter to continue..."
}

# Override uninstall_app
uninstall_app() {
  local app="$1"
  print_header

  if eval "$PKG_LIST" | grep -qw "$app"; then
    echo -e "${YELLOW}Uninstall native package '${CYAN}$app${YELLOW}'?${NC}"
    read -p "Confirm (y/n): " confirm
    if [[ "$confirm" == [yY] ]]; then
      echo -e "${CYAN}Uninstalling $app...${NC}"
      eval "$PKG_REMOVE $app"
      echo -e "\n${GREEN}Uninstall complete!${NC}"
    else
      echo -e "${YELLOW}Uninstall canceled.${NC}"
    fi
  elif command -v flatpak &>/dev/null && flatpak list | grep -q "$app"; then
    echo -e "${YELLOW}Uninstall Flatpak app '${CYAN}$app${YELLOW}'?${NC}"
    read -p "Confirm (y/n): " confirm
    if [[ "$confirm" == [yY] ]]; then
      echo -e "${CYAN}Uninstalling $app...${NC}"
      flatpak uninstall -y "$app"
      echo -e "\n${GREEN}Uninstall complete!${NC}"
    else
      echo -e "${YELLOW}Uninstall canceled.${NC}"
    fi
  else
    echo -e "${RED}App not found via package manager or Flatpak.${NC}"
  fi

  read -p "Press Enter to continue..."
}

# Override show_app_info
show_app_info() {
  local app="$1"
  print_header
  echo -e "${YELLOW}Information for:${NC} $app\n"

  if eval "$PKG_INFO $app" &>/dev/null; then
    echo -e "${CYAN}== Native Package Info ==${NC}\n"
    eval "$PKG_INFO $app" | grep -E "^(Name:|Version:|Description:|URL:|Homepage:)" | sed 's/^/  /'
  elif command -v flatpak &>/dev/null && flatpak info "$app" &>/dev/null; then
    echo -e "${CYAN}== Flatpak App Info ==${NC}\n"
    flatpak info "$app" | sed 's/^/  /'
  else
    echo -e "${RED}No information available for $app.${NC}"
  fi

  echo
  read -p "Press Enter to continue..."
}

# Start
detect_package_manager
check_dependencies
main_menu

