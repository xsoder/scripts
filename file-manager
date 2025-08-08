#!/usr/bin/env bash
SELECT=$(fzf -i --preview "bat --style=numbers --color=always {}" --scheme=path \
--read0 --style=minimal --header-label -prompt
)
EDITOR="vim"

while :
do
    "$SELECT"
done
