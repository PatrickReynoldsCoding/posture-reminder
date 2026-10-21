#!/usr/bin/env bash
set -euo pipefail

first_hour=9
last_hour=18
script_dir="$(cd "$(dirname "$0")" && pwd)"

# Pinned to London so the window stays right if the Mac's timezone changes (e.g. when travelling).
# The 10# prefix stops bash reading "08" and "09" as invalid octal.
current_hour=$((10#$(TZ=Europe/London date +%H)))

is_working_hours() {
    (( current_hour >= first_hour && current_hour < last_hour ))
}

is_muted() {
    (( $("${script_dir}/posture-mute.sh" remaining-minutes) > 0 ))
}

if is_working_hours && ! is_muted; then
    osascript -e 'display notification "Change your sitting position!" with title "Posture" sound name "Glass"'
fi
