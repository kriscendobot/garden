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
export GARDEN_TAG="cursor-set"

key="${1:?usage: cursor-set.sh <key> [body-file]}"
body_src="${2:-}"
case "$key" in /*|*..*|'') die "illegal cursor key '$key'";; esac

if   [ -n "$body_src" ] && [ -f "$body_src" ]; then BODY="$(cat "$body_src")"
elif [ ! -t 0 ];                                then BODY="$(cat)"
else die "no cursor body given"; fi

DIR="${GARDEN_CURSOR_CLONE:-$GARDEN_STATE/cursors/journal}"

# A live sibling window already classified the episode: skip the clone AND the write.
journal_outage_active && exit "${GARDEN_OFFLINE_RC:-75}"

# Serialize against every other cursor-get/cursor-set on this host: they all share
# ONE local clone ($DIR), and cursor-set's write runs in the PARENT shell after the
# subshell'd sync_clone below has already dropped clone_lock (see cursor_io_lock).
# Hold this host-local lock in the parent shell across the WHOLE critical section —
# ensure_clone, every sync_clone, the working-tree write, and the CAS push — so no
# peer can mutate the shared index underneath us ("fatal: unable to write new index
# file"). The fd stays open until this process exits, releasing the lock on every
# path. On a bounded-wait timeout, treat the busy lock as TEMPORARY unavailability,
# not a fatal failure: a peer holds the shared clone this tick, and dying loud here
# (rc=1) blocked cursor advancement for the whole GARDEN_CURSOR_LOCK_WAIT window and
# fed retry noise across every watcher. Instead skip this advance as
# temporary-unavailable (GARDEN_OFFLINE_RC, the same quiet verdict cursor-get returns)
# and let the caller re-advance next cadence — the cursor only advances after its work
# is durably done, so a skipped advance re-processes the same range idempotently. Emit
# ONE bounded, read-only holder diagnostic (never `rm -f` advice: deleting an flock'd
# lock file does not free the flock and can hand two writers the shared index at once;
# flock frees the lock automatically when the holder's fd closes on exit/crash).
if ! cursor_io_lock "$DIR"; then
  log "cursor-set: cursor-IO lock for $DIR busy >${GARDEN_CURSOR_LOCK_WAIT}s ($(_cursor_io_lock_holder "$DIR")); skipping advance of cursor $key this tick (rc=${GARDEN_OFFLINE_RC:-75}); caller re-advances next cadence"
  exit "${GARDEN_OFFLINE_RC:-75}"
fi

# Clone creation/repair runs before any fetch/push. A local checkout, ownership, or
# configuration fault here stays LOUD and never poisons the host-wide latch — but a
# correlated network outage striking during a needed (re)clone is the same weather the
# sync/push paths already latch. ensure_clone_or_latch_outage classifies the two: a
# transport outage latches the host cooldown and exits GARDEN_OFFLINE_RC; only
# positively-identified local, auth, corruption, or missing-upstream failures are
# re-raised loud with their original rc.
ensure_clone_or_latch_outage "$DIR" cursor-set

diagnostic_file="$(mktemp "${TMPDIR:-/tmp}/garden-cursor-set.XXXXXX")" \
  || die "cannot create cursor-write diagnostic file"
trap 'rm -f "$diagnostic_file"' EXIT

cursor_set_latch_outage() {  # <diagnostic>
  local diagnostic="$1"
  if start_journal_outage_cooldown cursor-set; then
    log "journal-write outage; latched host cooldown ($(_journal_outage_secs)s) so sibling cursor reads/writes skip quietly"
  fi
  # The first detector's detailed transport line is useful once. Siblings that
  # observe the latch never reach this path and remain quiet.
  [ -z "$diagnostic" ] || printf '%s\n' "$diagnostic" >&2
  exit "${GARDEN_OFFLINE_RC:-75}"
}

for attempt in $(seq 1 50); do
  # A CAS rejection normally loops immediately into another sync/write/push. During
  # a shared journal outage that behavior lets cursor advances consume the whole
  # service deadline. Honor a sibling's live window before every attempt, including
  # retries, and return the same temporary-unavailable verdict as cursor-get.
  journal_outage_active && exit "${GARDEN_OFFLINE_RC:-75}"

  : > "$diagnostic_file"
  if ( sync_clone "$DIR" ) 2>"$diagnostic_file"; then sync_rc=0; else sync_rc=$?; fi
  sync_diagnostic="$(cat "$diagnostic_file")"
  if [ "$sync_rc" -eq "${GARDEN_OFFLINE_RC:-75}" ] \
    || journal_bounded_fetch_is_ambiguous_outage "$sync_rc" "$sync_diagnostic"; then
    cursor_set_latch_outage "$sync_diagnostic"
  fi
  if [ "$sync_rc" -ne 0 ]; then
    # Authentication, missing-upstream, corruption, local-state, and unknown failures
    # are defects, not weather. Preserve their complete diagnostic and original rc.
    [ -z "$sync_diagnostic" ] || printf '%s\n' "$sync_diagnostic" >&2
    exit "$sync_rc"
  fi

  mkdir -p "$(dirname "$DIR/cursors/$key")"
  printf '%s\n' "$BODY" > "$DIR/cursors/$key"
  git -C "$DIR" add "cursors/$key"
  # Capture with `|| rc=$?` (a false `if` with no `else` is exit 0 and would
  # swallow commit_and_push's rc=2 "nothing to commit" on an idempotent re-run).
  : > "$diagnostic_file"
  rc=0; commit_and_push "$DIR" "cursor($key) advanced on $GARDEN" 2>"$diagnostic_file" || rc=$?
  push_diagnostic="$(cat "$diagnostic_file")"
  [ "$rc" -eq 0 ] && { log "advanced cursor $key"; exit 0; }
  [ "$rc" -eq 2 ] && exit 0

  # A push transport failure and the verification fetch after an apparently
  # successful push are both network surfaces. Known transport signatures are
  # definitive. The verification fetch is additionally bounded, so its narrow
  # rc=1/no-signature shape gets the same conservative fallback as cursor reads.
  if _fetch_stderr_is_offline "$GARDEN_PUSH_STDERR" \
    || _fetch_stderr_is_offline "$GARDEN_FETCH_STDERR" \
    || { [ "${GARDEN_VERIFY_FETCH_RC:-0}" -eq 1 ] \
      && ! journal_diagnostic_is_definite_failure "$GARDEN_FETCH_STDERR"; }; then
    cursor_set_latch_outage "${GARDEN_PUSH_STDERR:-${GARDEN_FETCH_STDERR:-$push_diagnostic}}"
  fi

  # Positive structural/authentication/server diagnostics must not be diluted into
  # fifty generic rc=1 retries. Re-raise them on the first observation. Unknown
  # failures retain the conservative retry behavior used by the silent-loss guard.
  combined_diagnostic="${GARDEN_PUSH_STDERR}${GARDEN_FETCH_STDERR}${push_diagnostic}"
  if journal_push_is_definite_failure "$combined_diagnostic"; then
    [ -z "$combined_diagnostic" ] || printf '%s\n' "$combined_diagnostic" >&2
    exit "$rc"
  fi

  # A normal non-fast-forward is the compare-and-swap doing its job: another
  # journal writer won this round. Git appends "failed to push some refs" to this
  # diagnostic, but that generic trailer also appears on auth and server-policy
  # failures, so retry only when the ordinary porcelain rejection reason is present.
  if journal_push_is_cas_contention "$GARDEN_PUSH_STDERR"; then
    backoff "$attempt"
    continue
  fi
  backoff "$attempt"
done
die "could not advance cursor $key after retries"
