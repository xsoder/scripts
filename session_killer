#!/bin/bash

# Get the name of the currently attached tmux session (if any)
ATTACHED_SESSION=$(tmux display-message -p '#S')

# Use fzf to select a tmux session
SESSION=$(tmux ls | fzf --prompt="Select tmux session to kill: ")

# Check if a session was selected
if [[ -n "$SESSION" ]]; then
  # Extract the session name from the output of `tmux ls`
  SESSION_NAME=$(echo "$SESSION" | cut -d: -f1)

  # If the selected session is the currently attached session, switch to another one
  if [[ "$SESSION_NAME" == "$ATTACHED_SESSION" ]]; then
    # Get the name of another session to switch to (ignores the current session)
    NEXT_SESSION=$(tmux ls | grep -v "$SESSION_NAME" | fzf --prompt="Select a session to switch to: ")

    if [[ -n "$NEXT_SESSION" ]]; then
      NEXT_SESSION_NAME=$(echo "$NEXT_SESSION" | cut -d: -f1)
      tmux switch-client -t "$NEXT_SESSION_NAME"
      echo "Switched to session '$NEXT_SESSION_NAME'."
    else
      echo "No other session available, staying attached."
    fi
  fi

  # Kill the selected tmux session
  tmux kill-session -t "$SESSION_NAME"
  echo "Tmux session '$SESSION_NAME' has been killed."

  # After killing, update the attached session and check if we're still attached to a session
  ATTACHED_SESSION=$(tmux display-message -p '#S')

  # If we're still attached to a session, print a message; otherwise, print an error
  if [[ -n "$ATTACHED_SESSION" ]]; then
    echo "Now attached to session '$ATTACHED_SESSION'."
  else
    echo "No sessions are currently attached."
  fi
else
  echo "No session selected. Exiting."
fi

