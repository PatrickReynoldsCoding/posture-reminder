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

# Prints the clicked button title, or @TIMEOUT / @CLOSED. The timeout stops one unanswered
# notification from blocking the next 30-minute run.
notify_with_mute_buttons() {
    /opt/homebrew/bin/terminal-notifier \
        -title "Posture" \
        -message "Change your sitting position!" \
        -sound Glass \
        -group posture-reminder \
        -action "Mute 1h,Mute 2h,Mute 4h,Mute 8h" \
        -timeout 120 || true
}

mute_if_button_clicked() {
    local clicked_button="$1"
    if [[ "${clicked_button}" =~ ^Mute\ ([0-9]+)h$ ]]; then
        "${script_dir}/posture-mute.sh" "${BASH_REMATCH[1]}"
    fi
}

if is_working_hours && ! is_muted; then
    mute_if_button_clicked "$(notify_with_mute_buttons)"
fi
