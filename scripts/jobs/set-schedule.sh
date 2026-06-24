#!/bin/bash
# set-schedule.sh — race a schedule change onto the journal (CAS).
#
# Usage: set-schedule.sh <name> <cadence> [<basename-prefix>] [<body-file>]
#   <cadence>  weekly | daily | hourly | <N>s   (most schedules are weekly)
#   body from <body-file> else stdin: the task to duplicate each period.
#
# Writes schedules/<name>; the scheduler service dispatches it on its cadence
# and stamps last_dispatched. Add-only-ish (overwrites one file), so a rejected
# push just re-syncs and retries.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="set-schedule"

name="${1:?usage: set-schedule.sh <name> <cadence> [prefix] [body-file]}"
cadence="${2:?cadence}"
prefix="${3:-$name}"
body_src="${4:-}"
case "$name" in -*|*/*|.*|'') die "illegal schedule name '$name'";; esac

if   [ -n "$body_src" ] && [ -f "$body_src" ]; then BODY="$(cat "$body_src")"
elif [ ! -t 0 ];                                then BODY="$(cat)"
else BODY="# scheduled job: $name"; fi

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

for attempt in $(seq 1 50); do
  sync_clone "$DIR"
  mkdir -p "$DIR/schedules"
  # preserve an existing last_dispatched if the schedule already exists
  last=""
  [ -f "$DIR/schedules/$name.md" ] && last="$(sed -n 's/^last_dispatched:[[:space:]]*//p' "$DIR/schedules/$name.md" | head -1)"
  {
    printf 'cadence: %s\nlast_dispatched: %s\njob_basename_prefix: %s\n---\n' "$cadence" "$last" "$prefix"
    printf '%s\n' "$BODY"
  } > "$DIR/schedules/$name.md"
  git -C "$DIR" add "schedules/$name.md"
  if commit_and_push "$DIR" "schedule($name) cadence=$cadence"; then log "set schedule $name ($cadence)"; exit 0; fi
  rc=$?; [ "$rc" -eq 2 ] && { log "schedule $name unchanged"; exit 0; }
  backoff
done
die "could not set schedule $name after retries"
