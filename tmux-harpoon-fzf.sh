#!/usr/bin/env bash

fzf_jump() {
  local target
  target=$(cat "$HARPOON_FILE" | fzf --prompt="Harpoon > " --height=10 --reverse)
  [[ -n "$target" ]] && tmux switch-client -t "$target"
}
fzf_delete() {
  local target
  target=$(cat "$HARPOON_FILE" | fzf --prompt="Delete > " --height=10 --reverse)

  if [[ -n "$target" ]]; then
    grep -vFx "$target" "$HARPOON_FILE" > "${HARPOON_FILE}.tmp" && mv "${HARPOON_FILE}.tmp" "$HARPOON_FILE"
    echo "Deleted: $target"
  else
    echo "No selection made."
  fi
}

