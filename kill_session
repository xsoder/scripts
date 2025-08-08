#!/usr/bin/env bash

tmux list-sessions -F '#S' | fzf --preview 'tmux list-windows -t {}' | xargs -r tmux kill-session -t

