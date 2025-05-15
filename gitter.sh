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

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)

# Prompt for commit message
echo -e "${YELLOW}Enter your Git commit message:${RESET}"
read -p "❯ " COMMIT

# Git commands with feedback
echo -e "${CYAN}Staging all changes...${RESET}"
git add .

echo -e "${CYAN}Committing with message: ${BOLD}$COMMIT${RESET}"
git commit -m "$COMMIT"

# List all branches and let the user select which one to push to
echo -e "${YELLOW}Available branches:${RESET}"
git branch | sed 's/^..//' | nl

echo -e "${YELLOW}Enter the number of the branch you want to push to (default is current branch: ${BOLD}$CURRENT_BRANCH${RESET}${YELLOW}):${RESET}"
read -p "> " BRANCH_NUM

if [ -n "$BRANCH_NUM" ]; then
    SELECTED_BRANCH=$(git branch | sed 's/^..//' | sed -n "${BRANCH_NUM}p")
    if [ -n "$SELECTED_BRANCH" ]; then
        echo -e "${CYAN}Pushing to ${BOLD}$SELECTED_BRANCH${RESET}${CYAN}...${RESET}"
        git push origin "$SELECTED_BRANCH"
    else
        echo -e "${RED}Invalid branch number. Pushing to current branch ${BOLD}$CURRENT_BRANCH${RESET}${RED} instead.${RESET}"
        git push origin "$CURRENT_BRANCH"
    fi
else
    echo -e "${CYAN}Pushing to current branch ${BOLD}$CURRENT_BRANCH${RESET}${CYAN}...${RESET}"
    git push origin "$CURRENT_BRANCH"
fi

# Done message
echo -e "${GREEN}Done!${RESET} ${BOLD}Press any key to exit.${RESET}"
read -n 1 -s
clear
