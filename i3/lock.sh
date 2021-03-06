#!/usr/bin/env bash

revert() {
    xset dpms 0 0 0
    xset dpms force on
    pkill -xu $EUID i3lock
}
trap revert EXIT

xset dpms 10 10 10

if [ -n "${XSS_SLEEP_LOCK_FD}" ] && [[ -e /dev/fd/${XSS_SLEEP_LOCK_FD:--1} ]]; then
    # we have to make sure the locker does not inherit a copy of the lock fd
    i3lock -ef -c 222244 -p default {XSS_SLEEP_LOCK_FD}<&-

    # now close our fd (only remaining copy) to indicate we're ready to sleep
    exec {XSS_SLEEP_LOCK_FD}<&-
else 
    i3lock -ef -c 222244 -p default
fi

# Wait for i3lock to exit.
tail --pid="$(pidof -s i3lock)" -f /dev/null

