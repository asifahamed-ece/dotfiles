#!/bin/bash
# Immortal Cliphist Watchdog Daemon
# Forces a clean restart every 10 minutes to prevent wl-paste silent hangs.
#
# FIX: previously ran a single "wl-paste --watch cliphist store" with no
# --type filter. wl-paste with no --type only follows ONE mime offer per
# copy — for an app that advertises both text and image simultaneously,
# whichever offer the compositor hands back first is the only one that
# gets stored, so some copies were silently skipped depending on the
# source app. Running one watcher per type fixes that.
#
# Also added a lock so a second copy of this daemon (e.g. started twice by
# an autostart entry) can't run alongside this one and steal/duplicate the
# clipboard listener, which looks exactly like "works sometimes, not others".

LOCK_FILE="/tmp/cliphist-daemon.lock"
exec 200>"$LOCK_FILE"
flock -n 200 || { echo "cliphist-daemon already running, exiting"; exit 1; }

watch_loop() {
    local mime_type="$1"
    while true; do
        timeout 600 wl-paste --type "$mime_type" --watch cliphist store
        sleep 1
    done
}

watch_loop "text" &
watch_loop "image" &

wait
