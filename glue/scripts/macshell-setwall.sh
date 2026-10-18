#!/bin/sh
# macshell-setwall.sh FILE        set a picture (awww) or a video (mpvpaper, one per output)
# macshell-setwall.sh --prepare V cache the animated preview of video V
# The last line printed is a still image of what is on screen, for the glass.
run="${XDG_RUNTIME_DIR:-/tmp}/macshell-wall"
cache="$HOME/.cache/macshell/thumbs"
mkdir -p "$run" "$cache"

thumb() {
	printf '%s/%s' "$cache" "$(printf '%s:%s' "$1" "$(stat -c %Y "$1" 2>/dev/null)" | md5sum | cut -c1-16)"
}

stopvideo() {
	for f in "$run"/*.pid; do
		[ -f "$f" ] || continue
		pid=$(cat "$f")
		# only our own mpvpaper, never a reused pid
		case "$(cat "/proc/$pid/comm" 2>/dev/null)" in mpvpaper) kill -CONT "$pid"; kill "$pid" ;; esac
		rm -f "$f"
	done
}

if [ "$1" = "--prepare" ]; then
	v=$2 t=$(thumb "$2")
	[ -s "$t.webp" ] && exit 0
	ffmpeg -loglevel error -y -ss 1 -t 3 -i "$v" -an \
		-vf "fps=12,scale=480:-2:flags=lanczos" -loop 0 -q:v 60 "$t.webp.part.webp" </dev/null &&
		mv "$t.webp.part.webp" "$t.webp"
	exit 0
fi

f=$1
[ -f "$f" ] || { echo "no such file: $f" >&2; exit 1; }
case "$(printf %s "$f" | tr 'A-Z' 'a-z')" in
*.mp4|*.webm|*.mkv|*.mov|*.m4v)
	command -v mpvpaper >/dev/null 2>&1 || { echo "mpvpaper is not installed" >&2; exit 1; }
	stopvideo
	for o in $(hyprctl -j monitors | jq -r '.[].name'); do
		setsid mpvpaper -o "no-audio loop-file=inf hwdec=auto panscan=1.0" "$o" "$f" \
			>/dev/null 2>&1 </dev/null &
		echo $! > "$run/$o.pid"
	done
	still="$(thumb "$f")-still.jpg"
	[ -s "$still" ] || ffmpeg -loglevel error -y -ss 1 -i "$f" -frames:v 1 \
		-vf "scale=1920:-2" "$still" </dev/null >/dev/null 2>&1
	echo "applied with: mpvpaper"
	[ -s "$still" ] && echo "$still"
	;;
*)
	stopvideo
	awww img "$f" --transition-type fade --transition-duration 0.7 || exit 1
	echo "applied with: awww"
	echo "$f"
	;;
esac
