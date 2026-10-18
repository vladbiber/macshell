#!/bin/sh
# macshell-gaming.sh on|off: Game Mode. The compositor already drops its effects
# under a full screen window; this adds the performance power profile.
saved="${XDG_RUNTIME_DIR:-/tmp}/macshell-gaming-profile"
command -v powerprofilesctl >/dev/null 2>&1 || exit 0
case "$1" in
on)
	[ -f "$saved" ] || powerprofilesctl get > "$saved" 2>/dev/null
	powerprofilesctl set performance 2>/dev/null
	;;
off)
	[ -f "$saved" ] || exit 0
	powerprofilesctl set "$(cat "$saved")" 2>/dev/null
	rm -f "$saved"
	;;
esac
exit 0
