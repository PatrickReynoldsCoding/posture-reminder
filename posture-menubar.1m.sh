#!/usr/bin/env bash
# SwiftBar plugin: menu bar mute button for the posture reminder. Refreshes every minute.
set -euo pipefail

script_dir="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
mute_script="${script_dir}/posture-mute.sh"
minutes_left=$("${mute_script}" remaining-minutes)

if (( minutes_left > 0 )); then
    echo "🔕 $((minutes_left / 60))h$((minutes_left % 60))m"
else
    echo "🪑"
fi
echo "---"
for hours in 1 2 4 8; do
    echo "Mute for ${hours} hour(s) | bash=${mute_script} param1=${hours} terminal=false refresh=true"
done
if (( minutes_left > 0 )); then
    echo "Unmute | bash=${mute_script} param1=off terminal=false refresh=true"
fi
