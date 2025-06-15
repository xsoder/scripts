#!/bin/bash
# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Detect package manager and set commands
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
    PKG_CLEAN="sudo pacman -Rns \$(pacman -Qdtq)"
    PKG_LIST="pacman -Q | awk '{print \$1}'"
    PKG_INFO="pacman -Si"
  else
    echo -e "${RED}Error:${NC} Supported package manager not found."
    exit 1
  fi
}

# Check required tools
check_dependencies() {
  command -v fzf >/dev/null 2>&1 || {
    echo -e "${RED}Error:${NC} 'fzf' not found. Please install it."
    exit 1
  }
}

# Print header
print_header() {
  clear
  echo -e "${BLUE}==============================="
  echo -e " Linux System Manager (${PKG_TYPE})"
  echo -e "===============================${NC}\n"
}

# System update
system_update() {
  print_header
  echo -e "${YELLOW}System Update${NC}\n"

  echo -e "${CYAN}[1/4]${NC} Updating repositories..."
  eval "$PKG_UPDATE"

  echo -e "\n${CYAN}[2/4]${NC} Upgrading packages..."
  eval "$PKG_UPGRADE"

  if command -v flatpak &>/dev/null; then
    echo -e "\n${CYAN}[3/4]${NC} Updating Flatpak apps..."
    flatpak update -y
  fi

  echo -e "\n${CYAN}[4/4]${NC} Cleaning unused packages..."
  eval "$PKG_CLEAN"

  echo -e "\n${GREEN}System update complete!${NC}"
  read -p "Press Enter to return to the menu..."
}

# Uninstall app
uninstall_app() {
  print_header
  echo -e "${YELLOW}Select an app to uninstall:${NC}"
  local app

  app=$(eval "$PKG_LIST" | sort | fzf --prompt="Search native or Flatpak apps: ")
  if [[ -z "$app" ]]; then
    echo -e "${YELLOW}No app selected.${NC}"
    read -p "Press Enter to return..."
    return
  fi

  echo -e "${YELLOW}Uninstall '${CYAN}$app${YELLOW}'?${NC}"
  read -p "Confirm (y/n): " confirm

  if [[ "$confirm" == [yY] ]]; then
    if eval "$PKG_LIST" | grep -qw "$app"; then
      echo -e "${CYAN}Uninstalling native package...${NC}"
      eval "$PKG_REMOVE $app"
    elif command -v flatpak &>/dev/null && flatpak list | grep -q "$app"; then
      echo -e "${CYAN}Uninstalling Flatpak app...${NC}"
      flatpak uninstall -y "$app"
    else
      echo -e "${RED}App not found in package list or Flatpak.${NC}"
    fi
  else
    echo -e "${YELLOW}Uninstall canceled.${NC}"
  fi

  read -p "Press Enter to return..."
}

# Show app info
show_app_info() {
  print_header
  echo -e "${YELLOW}Select an app to view info:${NC}"
  local app

  app=$(eval "$PKG_LIST" | sort | fzf --prompt="Search installed apps: ")
  if [[ -z "$app" ]]; then
    echo -e "${YELLOW}No app selected.${NC}"
    read -p "Press Enter to return..."
    return
  fi

  echo -e "${CYAN}\n== App Information: $app ==${NC}"

  if eval "$PKG_INFO $app" &>/dev/null; then
    eval "$PKG_INFO $app" | grep -E "^(Name:|Version:|Description:|URL:|Homepage:)" | sed 's/^/  /'
  elif command -v flatpak &>/dev/null && flatpak info "$app" &>/dev/null; then
    flatpak info "$app" | sed 's/^/  /'
  else
    echo -e "${RED}No information found for ${app}.${NC}"
  fi

  echo
  read -p "Press Enter to return..."
}

# Main menu
main_menu() {
  while true; do
    print_header
    echo -e "${CYAN}1.${NC} Update system"
    echo -e "${CYAN}2.${NC} Uninstall app"
    echo -e "${CYAN}3.${NC} Show app info"
    echo -e "${CYAN}0.${NC} Exit"
    echo
    read -p "Select an option: " choice

    case "$choice" in
      1) system_update ;;
      2) uninstall_app ;;
      3) show_app_info ;;
      0) clear; exit 0 ;;
      *) echo -e "${RED}Invalid option.${NC}"; sleep 1 ;;
    esac
  done
}

# Start the program
detect_package_manager
check_dependencies
main_menu

