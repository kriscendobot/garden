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
#
# Two bounded phases. Phase 1 lands through the shared producer clone, capped
# at GARDEN_SCHEDULE_ONCE_SHARED_ATTEMPTS CAS attempts and
# GARDEN_SCHEDULE_ONCE_SHARED_TIMEOUT seconds of wall clock. If that clone is
# corrupt or wedged (livelocked on a stale index.lock, 2026-09-29T17:17Z),
# phase 2 writes the schedule through a fresh shallow temporary clone, up to
# GARDEN_SCHEDULE_ONCE_ISOLATED_ATTEMPTS times, so a deferral never waits on
# someone repairing the producer clone.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="set-schedule-once"
: "${GARDEN_SCHEDULE_ONCE_SHARED_ATTEMPTS:=10}"
: "${GARDEN_SCHEDULE_ONCE_SHARED_TIMEOUT:=300}"   # seconds for phase 1 as a whole
: "${GARDEN_SCHEDULE_ONCE_ISOLATED_ATTEMPTS:=5}"

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
render() {  # the schedule file's exact bytes
  printf 'once: %s\njob_basename_prefix: %s\n---\n' "$when" "$prefix"
  printf '%s\n' "$BODY"
}

# already_landed <dir> <file> — true when origin/$JOURNAL_BRANCH already carries
# schedules/<name>.md byte-identical to <file>. commit_and_push returns 2 for ANY
# failed `git commit`, not only "nothing to commit" (a stale index.lock fails the
# commit too), so rc=2 is trusted as "unchanged" only when the tip really holds
# the schedule; otherwise it is a failed attempt, never a silent success.
already_landed() {
  git -C "$1" show "origin/$JOURNAL_BRANCH:schedules/$name.md" 2>/dev/null | cmp -s - "$2"
}

# --- phase 1: the shared producer clone (bounded CAS loop) ------------------
# Runs in a child process (re-exec below) so its wall clock can be capped: a
# corrupt shared clone can livelock sync_clone on a stale index.lock or wait out
# the clone-lock ladder (2026-09-29T17:17Z), and nothing inside the loop bounds
# that. Every exit — die, EX_TEMPFAIL, the timeout kill — lands in phase 2.
if [ "${_GARDEN_SCHEDULE_ONCE_PHASE:-}" = shared ]; then
  DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
  ensure_clone "$DIR"
  for attempt in $(seq 1 "$GARDEN_SCHEDULE_ONCE_SHARED_ATTEMPTS"); do
    sync_clone "$DIR"
    mkdir -p "$DIR/schedules"
    render > "$DIR/schedules/$name.md"
    git -C "$DIR" add "schedules/$name.md"
    # Capture with `|| rc=$?` (a false `if` with no `else` is exit 0 and would
    # swallow commit_and_push's rc=2 "nothing to commit" on an idempotent re-run).
    rc=0; commit_and_push "$DIR" "schedule-once($name) at=$when" || rc=$?
    [ "$rc" -eq 0 ] && { log "set one-time schedule $name (at $when)"; exit 0; }
    if [ "$rc" -eq 2 ] && already_landed "$DIR" "$DIR/schedules/$name.md"; then
      log "schedule $name unchanged"; exit 0
    fi
    backoff "$attempt"
  done
  die "could not set one-time schedule $name through the shared producer clone after retries"
fi

# Hand the body to phase 1 as a file so the child never reads stdin.
WORK="$(mktemp -d "${TMPDIR:-/tmp}/set-schedule-once.XXXXXX")"
trap 'rm -rf "$WORK"' EXIT
printf '%s\n' "$BODY" > "$WORK/body"
rc=0
_GARDEN_SCHEDULE_ONCE_PHASE=shared \
  timeout --kill-after="$GARDEN_FETCH_KILL_AFTER" "$GARDEN_SCHEDULE_ONCE_SHARED_TIMEOUT" \
  "$HERE/set-schedule-once.sh" "$name" "$when" "$prefix" "$WORK/body" </dev/null || rc=$?
[ "$rc" -eq 0 ] && exit 0
log "WARN: shared producer clone could not set schedule $name (rc=$rc); falling back to an isolated temporary clone"

# --- phase 2: isolated CAS through a fresh temporary clone ------------------
# Shares nothing with the producer clone (no clone lock, no index, no object
# store), so a wedged or corrupt producer clone cannot block a deferral. Each
# attempt re-clones shallow and single-branch; the bounded retry count and
# bounded_clone's own wall clock keep the whole fallback finite.
render > "$WORK/expected"
remote="$(journal_remote)"
for attempt in $(seq 1 "$GARDEN_SCHEDULE_ONCE_ISOLATED_ATTEMPTS"); do
  ISO="$WORK/journal.$attempt"
  if ! GARDEN_CLONE_RETRIES=1 bounded_clone "$remote" "$ISO" \
         --depth 1 --single-branch --branch "$JOURNAL_BRANCH"; then
    backoff "$attempt"; continue
  fi
  git -C "$ISO" config user.name  "$(bot_name)"
  git -C "$ISO" config user.email "$(bot_email)"
  mkdir -p "$ISO/schedules"
  cp "$WORK/expected" "$ISO/schedules/$name.md"
  git -C "$ISO" add "schedules/$name.md"
  rc=0; commit_and_push "$ISO" "schedule-once($name) at=$when" || rc=$?
  if [ "$rc" -eq 0 ]; then
    log "set one-time schedule $name (at $when) via isolated clone"; exit 0
  fi
  if [ "$rc" -eq 2 ] && already_landed "$ISO" "$WORK/expected"; then
    log "schedule $name unchanged"; exit 0
  fi
  rm -rf "$ISO"
  backoff "$attempt"
done
die "could not set one-time schedule $name after retries (shared producer clone and isolated fallback both failed)"
