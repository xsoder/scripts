#!/bin/bash

if pgrep -x "screenkey" > /dev/null; then
  pkill screenkey
else
  screenkey --position bottomright --opacity 0.7 --font-size large --no-modifier-mode &
fi

