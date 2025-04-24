#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
RESET='\033[0m'

# Get current directory
DIR=$(pwd)

# Display current directory
echo -e "${CYAN}Working directory: ${BOLD}$DIR${RESET}"

# Prompt for commit message
echo -e "${YELLOW}Enter your Git commit message:${RESET}"
read -p "> " COMMIT

# Git commands with feedback
echo -e "${CYAN}Staging all changes...${RESET}"
git add .

echo -e "${CYAN}Committing with message: ${BOLD}$COMMIT${RESET}"
git commit -m "$COMMIT"

echo -e "${CYAN}Pushing to remote...${RESET}"
git push

# Done message
echo -e "${GREEN}Done!${RESET} ${BOLD}Press any key to exit.${RESET}"
read -n 1 -s
clear
