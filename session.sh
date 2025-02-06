#!/usr/bin/env bash

# Function to switch to a tmux session
switch_to() {
    if [[ -z "$TMUX" ]]; then
        tmux attach-session -t "$1" 2>/dev/null || {
            echo "Error: Could not attach to session '$1'."
            exit 1
        }
    else
        tmux switch-client -t "$1" 2>/dev/null || {
            echo "Error: Could not switch to session '$1'."
            exit 1
        }
    fi
}

# Function to preview windows inside a tmux session
preview_windows() {
    session_name="$1"
    windows=$(tmux list-windows -t "$session_name" -F '#{window_index}: #{window_name}')

    if [[ -n "$windows" ]]; then
        echo "Windows in session '$session_name':"
        echo "$windows"
    else
        echo "No windows found in session '$session_name'."
    fi
}

# Function to list and select tmux sessions
select_session_and_preview() {
    sessions=$(tmux list-sessions -F '#{session_name}' 2>/dev/null)

    if [[ -z "$sessions" ]]; then
        echo "No tmux sessions found."
        exit 1
    fi

    selected_session=$(echo "$sessions" | fzf --ansi --prompt="Select a session: " --height=10 --border --reverse)

    if [[ -n "$selected_session" ]]; then
        preview_windows "$selected_session"
        switch_to "$selected_session"
    else
        echo "No session selected. Exiting."
        exit 1
    fi
}

# Main interactive menu
main() {
    # Get the list of tmux sessions
    sessions=$(tmux list-sessions -F '#{session_name}' 2>/dev/null)
    if [[ -z "$sessions" ]]; then
        echo "No tmux sessions found. Exiting."
        exit 0
    fi

    # Select a session and preview its windows
    select_session_and_preview
}

# Run the main function
main

