#!/usr/bin/env bash

tmux list-sessions | fzf | cut -d: -f1 | xargs -r tmux switch-client -t


