#!/bin/bash
# cursor-set.sh — CAS-advance a journal-backed poll cursor.
#
# Usage: cursor-set.sh <key> [<body-file>]   (body else stdin)
#
# Writes cursors/<key> in the journal and pushes (CAS). Advance the cursor only
# AFTER the work for everything up to that position is durably done, so a crash
# between poll and processing resumes from the old cursor rather than skipping
# events. The body is whatever the poller needs to resume (last_event_id, etag,
# last_polled_at, last_sha, …).

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="cursor-set"

key="${1:?usage: cursor-set.sh <key> [body-file]}"
body_src="${2:-}"
case "$key" in /*|*..*|'') die "illegal cursor key '$key'";; esac

if   [ -n "$body_src" ] && [ -f "$body_src" ]; then BODY="$(cat "$body_src")"
elif [ ! -t 0 ];                                then BODY="$(cat)"
else die "no cursor body given"; fi

DIR="${GARDEN_CURSOR_CLONE:-$GARDEN_STATE/cursors/journal}"
ensure_clone "$DIR"

for attempt in $(seq 1 50); do
  sync_clone "$DIR"
  mkdir -p "$(dirname "$DIR/cursors/$key")"
  printf '%s\n' "$BODY" > "$DIR/cursors/$key"
  git -C "$DIR" add "cursors/$key"
  if commit_and_push "$DIR" "cursor($key) advanced on $GARDEN_HOST"; then
    log "advanced cursor $key"; exit 0
  fi
  rc=$?; [ "$rc" -eq 2 ] && exit 0
  backoff
done
die "could not advance cursor $key after retries"
