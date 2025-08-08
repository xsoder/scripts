#!/bin/bash

# Get the list of processes with PID, User, and Command
process=$(ps -ef | sed 1d | fzf --header="Select a process to kill" --preview="echo {}" | awk '{print $2}')

# Check if a process was selected
if [[ -n "$process" ]]; then
    echo "Killing process: $process"
    kill -9 "$process"
else
    echo "No process selected."
fi

