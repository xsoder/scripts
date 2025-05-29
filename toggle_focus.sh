#!/bin/bash

floating_status=$(i3-msg -t get_tree | grep -Po '"focused":true.*?"floating":"\K[^"]+')

if [[ "$floating_status" == "auto_on" || "$floating_status" == "user_on" ]]; then
  i3-msg focus tiling > /dev/null
  new_floating=$(i3-msg -t get_tree | grep -Po '"focused":true.*?"floating":"\K[^"]+')
  if [[ "$new_floating" == "auto_on" || "$new_floating" == "user_on" ]]; then
    notify-send "No tiled window to focus in this workspace"
  fi
else
  i3-msg focus floating > /dev/null
  new_floating=$(i3-msg -t get_tree | grep -Po '"focused":true.*?"floating":"\K[^"]+')
  if [[ "$new_floating" != "auto_on" && "$new_floating" != "user_on" ]]; then
    notify-send "No floating window to focus in this workspace"
  fi
fi

