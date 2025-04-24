#!/bin/bash

file="$1"

kitty +kitten icat --clear

if file --mime-type "$file" | grep -qE 'image/'; then
    kitty +kitten icat --transfer-mode=stream --place=0x0@0x0 "$file"
else
    bat --style=plain --color=always "$file" 2>/dev/null || cat "$file"
fi

