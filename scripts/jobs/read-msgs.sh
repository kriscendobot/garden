#!/bin/bash
# read-msgs.sh — the per-agent monitor: surface unseen messages for an agent.
#
# Usage: read-msgs.sh <seen-key> <address>...
#   <seen-key>  a stable per-agent key (e.g. gardener-1); names the seen-marker.
#   <address>   one or more bus addresses to watch, e.g. role/gardener job/abc
#               host/<GARDEN> broadcast.
#
# Prints each not-yet-seen message (newest-last) and records it as seen in a
# marker kept OUTSIDE the journal (under GARDEN_STATE), so a `git reset --hard`
# of any worktree never loses an agent's read cursor. Exit status is the number
# of new messages (0 = none), capped at 250.
#
# Every working agent calls this on a cadence so it notices messages broadcast
# to its role or its job while it works — the bus is checked, not just the board.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"

seen_key="${1:?usage: read-msgs.sh <seen-key> <address>...}"; shift
[ "$#" -ge 1 ] || die "need at least one address to watch"
export GARDEN_TAG="monitor/$seen_key"

# Validate each address with the SAME grammar send-msg.sh enforces: one of the
# four kinds (role/<name>, job/<base>, host/<GARDEN>, broadcast), and after the
# kind prefix exactly one path segment ([A-Za-z0-9._-]+, no leading dot, no
# embedded slash). This is what keeps a relpath like host/../../x from escaping
# msgs/ on the READ side too — we cat files under msgs/$addr, so an un-guarded
# address is a path-traversal read. Reused verbatim from send-msg.sh so the send
# and read grammars can never drift. broadcast has no segment.
for addr in "$@"; do
  case "$addr" in
    role/?*|job/?*|host/?*|broadcast) :;;
    *) die "illegal address '$addr' (use role/<name>, job/<base>, host/<GARDEN>, or broadcast)";;
  esac
  case "$addr" in
    broadcast) :;;
    *) seg="${addr#*/}"
       case "$seg" in
         *[!A-Za-z0-9._-]*|.*|'') die "illegal address segment '$seg' (one [A-Za-z0-9._-]+ segment, no leading dot)";;
       esac;;
  esac
done

DIR="${GARDEN_MSG_CLONE:-$GARDEN_STATE/monitors/$seen_key/journal}"
SEEN="$GARDEN_STATE/seen/$seen_key"
mkdir -p "$(dirname "$SEEN")"; touch "$SEEN"

ensure_clone "$DIR"
sync_clone "$DIR"

new=0
for addr in "$@"; do
  d="$DIR/msgs/$addr"
  [ -d "$d" ] || continue
  while IFS= read -r f; do
    id="$addr/$f"
    grep -qxF "$id" "$SEEN" && continue
    printf '========== message %s ==========\n' "$id"
    cat "$d/$f"
    printf '\n'
    printf '%s\n' "$id" >> "$SEEN"
    new=$((new+1))
  done < <(find "$d" -mindepth 1 -maxdepth 1 -type f ! -name '.gitkeep' -printf '%f\n' 2>/dev/null | sort)
done
[ "$new" -gt 0 ] && log "$new new message(s)"
[ "$new" -gt 250 ] && new=250
exit "$new"
