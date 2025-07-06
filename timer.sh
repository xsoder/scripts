#!/bin/bash
ART="
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⠤⣤⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⣶⠿⠉⠉⠉⠀⠉⠉⠿⣶⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣿⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠿⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠉⠀⠀⠀⠀⠶⣶⣶⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣿⠛⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣤⣤⣿⣿⣤⣀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠿⣿⣉⣉⠀⠀⠀⠀⠉⣶⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛⣿⣿⣤⣤⣤⠛⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⣀⣶⠶⠶⠿⠉⠉⠿⠿⣶⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⣤⣿⠉⠀⠀⠀⠀⠀⠀⠀⠛⣿⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⣿⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣿⣶⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⠛⣤⣤⠀⠀⠀⠀⠀
⠀⠀⠀⠀⣶⣿⠛⠛⠀⠛⠶⠶⣿⠶⠶⠶⠶⠶⠶⠶⠶⣛⣛⠛⠀⠀⠛⠿⣶⠀⠀⠀
⠀⠀⠀⠀⠉⠛⠒⣶⣤⣤⣶⠒⠛⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠒⣶⣤⣤⣶⠛⠀⠀⠀"

INTERVAL=0.1
WIDTH=60

DURATION=$1

if [[ -z "$DURATION" ]]; then
  echo "Usage: $0 <duration> (e.g., 5m, 30s, 1m30s)"
  exit 1
fi

function duration_to_seconds() {
  local time=$1
  local total=0
  [[ $time =~ ([0-9]+)h ]] && total=$((total + ${BASH_REMATCH[1]} * 3600))
  [[ $time =~ ([0-9]+)m ]] && total=$((total + ${BASH_REMATCH[1]} * 60))
  [[ $time =~ ([0-9]+)s ]] && total=$((total + ${BASH_REMATCH[1]}))
  echo $total
}

TOTAL_SECONDS=$(duration_to_seconds "$DURATION")
if [[ $TOTAL_SECONDS -eq 0 ]]; then
  echo "Invalid duration: $DURATION"
  exit 1
fi

START=$(date +%s)

direction=1
pos=0

while true; do
  NOW=$(date +%s)
  ELAPSED=$((NOW - START))
  REMAINING=$((TOTAL_SECONDS - ELAPSED))

  if (( REMAINING <= 0 )); then
    clear
    echo -e "\n\n Time's up! Let's start! "
    break
  fi

  MINS=$((REMAINING / 60))
  SECS=$((REMAINING % 60))
  TIME_STRING=$(printf "%02d:%02d" $MINS $SECS)

  clear

  for line in $ART; do
    printf "%*s%s\n" $pos "" "$line"
  done

  echo ""
  printf "%*s%s\n" $pos "" " Starting in $TIME_STRING..."

  sleep $INTERVAL

  if (( direction == 1 )); then
    ((pos++))
    if (( pos >= WIDTH )); then direction=-1; fi
  else
    ((pos--))
    if (( pos <= 0 )); then direction=1; fi
  fi
done
