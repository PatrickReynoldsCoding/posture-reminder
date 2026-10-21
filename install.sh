#!/usr/bin/env bash
set -euo pipefail

label="com.paddymac.posture-reminder"
source_plist="$(cd "$(dirname "$0")" && pwd)/${label}.plist"
target_plist="${HOME}/Library/LaunchAgents/${label}.plist"
domain="gui/$(id -u)"

mkdir -p "${HOME}/Library/LaunchAgents"
cp "${source_plist}" "${target_plist}"

# bootout fails when the job is not loaded yet, which is fine on a first install.
launchctl bootout "${domain}/${label}" 2>/dev/null || true
launchctl bootstrap "${domain}" "${target_plist}"

echo "Installed ${label}. It runs now, every 30 minutes, and at every login."
