#!/bin/bash

# Use fzf to select a tmux session
SESSION=$(tmux ls | fzf --prompt="Select tmux session to kill: ")

# Check if a session was selected
if [[ -n "$SESSION" ]]; then
  # Extract the session name from the output of `tmux ls`
  SESSION_NAME=$(echo "$SESSION" | cut -d: -f1)

  # Kill the selected tmux session
  tmux kill-session -t "$SESSION_NAME"

  echo "Tmux session '$SESSION_NAME' has been killed."
else
  echo "No session selected. Exiting."
fi

