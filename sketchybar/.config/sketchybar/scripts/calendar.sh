#!/usr/bin/env bash

# -----------------------------------
# -------- Icons
# -----------------------------------
CALENDAR=􀉉
CLOCK=􀐫


# -----------------------------------
# -------- Trigger
# -----------------------------------
sketchybar --set "$NAME" icon="$CALENDAR $(date '+%a %b %-d')" label="$(date '+%H:%M')"
