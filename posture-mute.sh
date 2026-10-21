#!/usr/bin/env bash
# Usage: posture-mute.sh <hours> | off | remaining-minutes
set -euo pipefail

# /tmp is emptied on restart, which is how a restart cancels the mute.
mute_file="/tmp/posture-reminder-mute-until"

remaining_minutes() {
    [[ -f "${mute_file}" ]] || { echo 0; return; }
    local seconds_left=$(( $(cat "${mute_file}") - $(date +%s) ))
    if (( seconds_left > 0 )); then
        echo $(( (seconds_left + 59) / 60 ))
    else
        echo 0
    fi
}

case "${1:-}" in
    off)
        rm -f "${mute_file}"
        ;;
    remaining-minutes)
        remaining_minutes
        ;;
    1|2|4|8)
        echo $(( $(date +%s) + $1 * 3600 )) > "${mute_file}"
        ;;
    *)
        echo "Usage: $0 1|2|4|8|off|remaining-minutes" >&2
        exit 1
        ;;
esac
