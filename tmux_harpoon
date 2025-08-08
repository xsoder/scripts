#!/usr/bin/env bash

HARPOON_FILE="$HOME/.tmux-harpoon"
INDEX_FILE="$HOME/.tmux-harpoon.index"
FZF_SCRIPT="$HOME/scripts/tmux-harpoon-fzf.sh"

touch "$HARPOON_FILE"
[[ ! -f "$INDEX_FILE" ]] && echo 1 > "$INDEX_FILE"

# Source FZF helper if it exists
[[ -f "$FZF_SCRIPT" ]] && source "$FZF_SCRIPT"

get_index() { cat "$INDEX_FILE"; }
set_index() { echo "$1" > "$INDEX_FILE"; }

mark() {
  local current="$(tmux display-message -p '#S:#I')"
  grep -qxF "$current" "$HARPOON_FILE" || echo "$current" >> "$HARPOON_FILE"
  echo "Marked: $current"
}

list() {
  nl -w2 -s'. ' "$HARPOON_FILE"
}

go_indexed() {
  local lines=$(wc -l < "$HARPOON_FILE")
  local index=$(get_index)

  [[ $lines -eq 0 ]] && echo "No marks" && return

  index=$(( (index - 1 + lines) % lines + 1 ))
  set_index "$index"

  local target=$(sed -n "${index}p" "$HARPOON_FILE")
  tmux switch-client -t "$target"
}

go_next() {
  local index=$(get_index)
  local count=$(wc -l < "$HARPOON_FILE")
  (( index++ > count )) && index=1
  set_index "$index"
  go_indexed
}

go_prev() {
  local index=$(get_index)
  local count=$(wc -l < "$HARPOON_FILE")
  (( index-- < 1 )) && index=$count
  set_index "$index"
  go_indexed
}

clear_marks() {
  > "$HARPOON_FILE"
  echo 1 > "$INDEX_FILE"
  echo "Cleared all marks."
}

case $1 in
  mark) mark ;;
  list) list ;;
  go) fzf_jump ;;
  delete) fzf_delete ;;
  next) go_next ;;
  prev) go_prev ;;
  clear) clear_marks ;;
  *) echo "Usage: $0 {mark|go|next|prev|list|delete|clear}" ;;
esac

