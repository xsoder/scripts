#!/bin/bash

read -p "Enter your GitHub email address: " EMAIL

if [ -z "$EMAIL" ]; then
  echo "Error: No email provided. Exiting."
  exit 1
fi

KEY_NAME="$HOME/.ssh/id_rsa_github"

if [ -f "$KEY_NAME" ]; then
  echo "SSH key already exists. Skipping key generation."
else
  ssh-keygen -t rsa -b 4096 -C "$EMAIL" -f "$KEY_NAME" -N ""
  echo "SSH key generated!"
fi

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa_github

# Display the public key
if [[ "$(uname)" == "Darwin" ]]; then
  # macOS:
  cat "$KEY_NAME.pub" | pbcopy
  echo "SSH public key copied to clipboard (macOS)."
elif [[ "$(uname)" == "Linux" ]]; then
  # Linux:
  if ! command -v xclip &> /dev/null; then
    echo "xclip could not be found. Please install it using 'sudo apt-get install xclip'."
    exit 1
  fi
  cat "$KEY_NAME.pub" | xclip -selection clipboard
  echo "SSH public key copied to clipboard (Linux)."
else
  echo "Unsupported OS."
  exit 1
fi

if command -v firefox &> /dev/null; then
  echo "Opening GitHub SSH key settings page in Firefox..."
  firefox "https://github.com/settings/keys" &
else
  echo "Firefox not found. Please manually visit https://github.com/settings/keys."
fi

echo "Please add the SSH key to GitHub by pasting the key you just copied."

