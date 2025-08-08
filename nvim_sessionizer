#!/usr/bin/env bash

# Search all tmux sessions for any running instance of nvim
session=$(tmux list-sessions -F '#{session_name}' | while read -r session_name; do
    # Check if 'nvim' is running in any pane of the session
    tmux list-panes -t "$session_name" -F '#{pane_pid} #{pane_current_command}' | grep -q 'nvim' && echo "$session_name" && break
done)

# If a session containing nvim was found, switch to it
if [[ -n "$session" ]]; then
    tmux switch-client -t "$session"
else
    echo "No tmux session with Neovim found."
fi

