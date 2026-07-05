#!/bin/bash
# set-schedule-once.sh — race a ONE-TIME future schedule onto the journal (CAS).
#
# Usage: set-schedule-once.sh <name> <ISO-datetime> [<basename-prefix>] [<body-file>]
#   <ISO-datetime>  when the job should fire, once, e.g. 2026-07-01T09:00:00Z
#   body from <body-file> else stdin: the task to dispatch when due.
#
# Writes schedules/<name>.md with an `once:` field (instead of `cadence:`). The
# sole scheduler service dispatches it when due and then DELETES the schedule
# file in the same CAS commit, so it fires exactly once and never repeats. The
# dispatched job's basename is the prefix itself (no timestamp), so a retried
# dispatch is basename-idempotent.
#
# Overwrites one file, so a rejected push just re-syncs and retries.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="set-schedule-once"

name="${1:?usage: set-schedule-once.sh <name> <ISO-datetime> [prefix] [body-file]}"
when="${2:?ISO-datetime}"
prefix="${3:-$name}"
body_src="${4:-}"
case "$name" in -*|*/*|.*|'') die "illegal schedule name '$name'";; esac

# Validate the timestamp up front so a bad value fails loudly here, not silently
# in the scheduler.
date -u -d "$when" +%s >/dev/null 2>&1 || die "unparseable ISO datetime '$when'"

# Body source guard: a non-empty $4 that is not a readable file is almost always
# a mistake (an inline body STRING passed where a body-FILE path is expected).
# Without this, the body read falls through to `cat` on stdin — and with a
# non-tty stdin (every background / `claude -p` / systemd context) that blocks
# forever, wedging the shared producer lock
# (garden-harden-producer-body-read-hang). Fail fast, mirroring post-job.sh and
# journal-entry.sh.
if [ -n "$body_src" ] && [ ! -f "$body_src" ]; then
  die "body source '$body_src' is not a readable file (pass a body FILE path, or feed the body on stdin / leave \$4 empty for a placeholder)"
fi

if   [ -n "$body_src" ] && [ -f "$body_src" ]; then BODY="$(cat "$body_src")"
elif [ ! -t 0 ];                                then BODY="$(cat)"
else BODY="# one-time scheduled job: $name"; fi

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

for attempt in $(seq 1 50); do
  sync_clone "$DIR"
  mkdir -p "$DIR/schedules"
  {
    printf 'once: %s\njob_basename_prefix: %s\n---\n' "$when" "$prefix"
    printf '%s\n' "$BODY"
  } > "$DIR/schedules/$name.md"
  git -C "$DIR" add "schedules/$name.md"
  # Capture with `|| rc=$?` (a false `if` with no `else` is exit 0 and would
  # swallow commit_and_push's rc=2 "nothing to commit" on an idempotent re-run).
  rc=0; commit_and_push "$DIR" "schedule-once($name) at=$when" || rc=$?
  [ "$rc" -eq 0 ] && { log "set one-time schedule $name (at $when)"; exit 0; }
  [ "$rc" -eq 2 ] && { log "schedule $name unchanged"; exit 0; }
  backoff "$attempt"
done
die "could not set one-time schedule $name after retries"
