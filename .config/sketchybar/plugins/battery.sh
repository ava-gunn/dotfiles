#!/usr/bin/env bash
PERCENT=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

if [ -z "$PERCENT" ]; then
  exit 0
fi

if [ -n "$CHARGING" ]; then
  icon=󰂄
else
  case "$PERCENT" in
    100|9[0-9]) icon=󰁹 ;;
    8[0-9])     icon=󰂁 ;;
    7[0-9])     icon=󰂀 ;;
    6[0-9])     icon=󰁿 ;;
    5[0-9])     icon=󰁾 ;;
    4[0-9])     icon=󰁽 ;;
    3[0-9])     icon=󰁼 ;;
    2[0-9])     icon=󰁻 ;;
    1[0-9])     icon=󰁺 ;;
    *)          icon=󰂃 ;;
  esac
fi

sketchybar --set "$NAME" icon="$icon" label="${PERCENT}%"
