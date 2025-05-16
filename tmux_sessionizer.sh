#!/usr/bin/env bash

has_session() {
    tmux has-session -t "$1" 2>/dev/null
}

hydrate() {
    if [ -f "$2/.tmux-sessionizer" ]; then
        tmux send-keys -t "$1:1" "source $2/.tmux-sessionizer" C-m
    elif [ -f "$HOME/.tmux-sessionizer" ]; then
        tmux send-keys -t "$1:1" "source $HOME/.tmux-sessionizer" C-m
    fi
}

if [[ $# -eq 1 ]]; then
    selected="$1"
else
    selected=$(find ~/  ~/dopi ~/Programming/ ~/devenv -mindepth 1 -maxdepth 1 -type d | \
    fzf --height=15 --layout=reverse --border --prompt="Select project ❯ ")

fi

[[ -z $selected ]] && exit 0

selected_name=$(basename "$selected" | tr . _)

if ! has_session "$selected_name"; then
    tmux new-session -s "$selected_name" -c "$selected" -n "vim" -d "vim ."
    tmux new-window -t "$selected_name:" -n "shell" -c "$selected"
    hydrate "$selected_name" "$selected"
fi

if [[ -z $TMUX ]]; then
    tmux attach-session -t "$selected_name" \; select-window -t "$selected_name:0"
else
    tmux switch-client -t "$selected_name"
    tmux select-window -t "$selected_name:0"
fi

