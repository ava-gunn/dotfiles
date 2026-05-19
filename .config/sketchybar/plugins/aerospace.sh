#!/usr/bin/env bash
# Workspace pill: digit + focused app on that workspace.
# Three states: focused / has windows / empty.

# Plugin scripts inherit launchd's PATH, which lacks the nix profile.
export PATH="/etc/profiles/per-user/ava/bin:/run/current-system/sw/bin:$PATH"

SID="$1"

if [ -z "$FOCUSED_WORKSPACE" ]; then
  FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
fi

# First window on the workspace — good enough as a label.
APP=$(aerospace list-windows --workspace "$SID" --format '%{app-name}' 2>/dev/null | head -n1)

if [ -n "$APP" ]; then
  LABEL_DRAW=on
else
  LABEL_DRAW=off
fi

if [ -n "$APP" ]; then
  ICON_PAD_R=4
else
  ICON_PAD_R=10
fi

if [ "$SID" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" \
    background.color=0xff82aaff \
    background.drawing=on \
    icon.color=0xff222334 \
    icon.padding_right=$ICON_PAD_R \
    label.color=0xff222334 \
    label="$APP" \
    label.drawing=$LABEL_DRAW
elif [ -n "$APP" ]; then
  sketchybar --set "$NAME" \
    background.color=0x33c8d3f5 \
    background.drawing=on \
    icon.color=0xffc8d3f5 \
    icon.padding_right=4 \
    label.color=0xffc8d3f5 \
    label="$APP" \
    label.drawing=on
else
  sketchybar --set "$NAME" \
    background.color=0x00000000 \
    background.drawing=on \
    icon.color=0x66c8d3f5 \
    icon.padding_right=10 \
    label.drawing=off
fi
