#!/bin/sh
# macshell-wallpause.sh OUTPUT pause|resume: stop decoding a video wallpaper nobody can see
f="${XDG_RUNTIME_DIR:-/tmp}/macshell-wall/$1.pid"
[ -f "$f" ] || exit 0
pid=$(cat "$f")
[ "$(cat "/proc/$pid/comm" 2>/dev/null)" = mpvpaper ] || exit 0
case "$2" in
pause) kill -STOP "$pid" ;;
resume) kill -CONT "$pid" ;;
esac
