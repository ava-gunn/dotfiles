#!/usr/bin/env bash
# $INFO is the new volume percentage (0–100) from the volume_change event.
if [ "$SENDER" = "volume_change" ]; then
  vol="$INFO"
  case "$vol" in
    [6-9][0-9]|100) icon=󰕾 ;;
    [3-5][0-9])     icon=󰖀 ;;
    [1-9]|[1-2][0-9]) icon=󰕿 ;;
    *)              icon=󰝟 ;;
  esac
  sketchybar --set "$NAME" icon="$icon" label="${vol}%"
fi
