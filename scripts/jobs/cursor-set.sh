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

push_reject_alert_key="cursor-push-rejected-${GARDEN}-${key//[^A-Za-z0-9._-]/_}"

cursor_set_clear_push_rejection() {
  alert_maintainer_edge_clear "$push_reject_alert_key" \
    "cursor-set on $GARDEN can advance $key again; the journal push rejection has cleared." \
    >/dev/null 2>&1 || true
}

cursor_set_raise_push_rejection() {  # <class> <diagnostic>
  local class="$1" diagnostic="$2"
  if alert_maintainer_edge "$push_reject_alert_key" "$class" \
      "cursor-set on $GARDEN cannot advance $key after deterministic remote verification: $class. ${cursor_set_reject_verdict:-The requested content was not verified remotely and no safe remote movement was established.} Cursor-driven work will replay until this receive-side rejection is repaired. Push diagnostic:
$diagnostic"; then
    log "cursor-set: raised deduplicated repair alert for $key ($class)"
  fi
}

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

  # Remember the authoritative tip this attempt was based on. A receive-side
  # rejection is not conclusive: the server can accept the update while the
  # client reports failure, or another writer can move journal2 during the push.
  # The post-rejection fetch below distinguishes both recoverable cases from a
  # stationary remote that genuinely refused this write.
  base_remote="$(git -C "$DIR" rev-parse "origin/$JOURNAL_BRANCH")"

  mkdir -p "$(dirname "$DIR/cursors/$key")"
  printf '%s\n' "$BODY" > "$DIR/cursors/$key"
  desired_blob="$(git -C "$DIR" hash-object "$DIR/cursors/$key")"
  git -C "$DIR" add "cursors/$key"
  # Capture with `|| rc=$?` (a false `if` with no `else` is exit 0 and would
  # swallow commit_and_push's rc=2 "nothing to commit" on an idempotent re-run).
  : > "$diagnostic_file"
  rc=0; commit_and_push "$DIR" "cursor($key) advanced on $GARDEN" 2>"$diagnostic_file" || rc=$?
  push_diagnostic="$(cat "$diagnostic_file")"
  [ "$rc" -eq 0 ] && { cursor_set_clear_push_rejection; contention_record "$DIR" push-attempts "$attempt"; log "advanced cursor $key"; exit 0; }
  [ "$rc" -eq 2 ] && { cursor_set_clear_push_rejection; exit 0; }

  # A rejected push gets one deterministic fetch before it is classified. Do not
  # trust the push's generic "failed to push some refs" trailer: first compare the
  # exact cursor blob at the fetched remote, then compare the remote tip with the
  # tip this attempt used. Exact content means the durable outcome already exists;
  # a moved tip means this was safely reconcilable contention, even when a receive
  # hook described it as a rejection. Only a stationary remote is a true refusal.
  reject_fetch_rc=0
  stationary_rejection=0
  cursor_set_reject_verdict="The requested content was not verified remotely and no safe remote movement was established."
  if [ "${GARDEN_COMMIT_PUSH_REJECTED:-0}" = 1 ]; then
    journal_fetch "$DIR" 0 >/dev/null 2>>"$diagnostic_file" || reject_fetch_rc=$?
  else
    # commit_and_push reached its normal verify-after-success path already. Its
    # fetched view and failure classification are authoritative for this attempt.
    reject_fetch_rc="${GARDEN_VERIFY_FETCH_RC:-1}"
  fi
  if [ "$reject_fetch_rc" -ne 0 ]; then
    cursor_set_reject_verdict="The post-rejection fetch failed, so the requested content and remote movement could not be verified."
    if _fetch_stderr_is_offline "$GARDEN_FETCH_STDERR" \
      || { [ "$reject_fetch_rc" -eq 1 ] \
        && ! journal_diagnostic_is_definite_failure "$GARDEN_FETCH_STDERR"; }; then
      cursor_set_latch_outage "${GARDEN_FETCH_STDERR:-$push_diagnostic}"
    fi
  elif [ "${GARDEN_COMMIT_PUSH_REJECTED:-0}" = 1 ]; then
    remote_tip="$(git -C "$DIR" rev-parse "origin/$JOURNAL_BRANCH" 2>/dev/null || true)"
    remote_blob="$(git -C "$DIR" rev-parse "origin/$JOURNAL_BRANCH:cursors/$key" 2>/dev/null || true)"
    if [ -n "$remote_blob" ] && [ "$remote_blob" = "$desired_blob" ]; then
      cursor_set_clear_push_rejection
      contention_record "$DIR" push-attempts "$attempt"
      log "reconciled cursor $key after rejected push: requested content is already remote"
      exit 0
    fi
    if [ -n "$remote_tip" ] && [ "$remote_tip" != "$base_remote" ]; then
      log "cursor-set: remote moved after rejected push of $key; reconciling and retrying"
      backoff "$attempt"
      continue
    fi
    cursor_set_reject_verdict="The fetched remote cursor does not contain the requested content and $JOURNAL_BRANCH did not move."
    stationary_rejection=1
  fi

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

  # Preserve the existing sibling-outage contract even though deterministic
  # rejection verification now happens before the retry boundary. A peer may
  # have opened the host-wide cooldown while our push was in flight.
  journal_outage_active && exit "${GARDEN_OFFLINE_RC:-75}"

  # Positive structural/authentication/server diagnostics must not be diluted into
  # fifty generic rc=1 retries. Re-raise them on the first observation. Unknown
  # failures retain the conservative retry behavior used by the silent-loss guard.
  combined_diagnostic="${GARDEN_PUSH_STDERR}${GARDEN_FETCH_STDERR}${push_diagnostic}"
  if journal_push_is_definite_failure "$combined_diagnostic"; then
    [ -z "$combined_diagnostic" ] || printf '%s\n' "$combined_diagnostic" >&2
    reject_class="${GARDEN_COMMIT_PUSH_CLASS:-definite-fail}"
    cursor_set_raise_push_rejection "$reject_class" "${GARDEN_PUSH_STDERR:-$combined_diagnostic}"
    exit "$rc"
  fi

  # The classifier intentionally recognizes only stable Git signatures, but a
  # successful post-rejection fetch gives stronger evidence than text parsing.
  # If the exact cursor is absent and the remote tip is unchanged, an otherwise
  # unfamiliar receive-side diagnostic is still a genuine stationary refusal.
  # Preserve it and page once instead of converting it into 50 opaque retries.
  if [ "$stationary_rejection" -eq 1 ] \
    && [ "${GARDEN_COMMIT_PUSH_REJECTED:-0}" = 1 ] \
    && ! journal_push_is_cas_contention "$GARDEN_PUSH_STDERR"; then
    [ -z "$GARDEN_PUSH_STDERR" ] || printf '%s\n' "$GARDEN_PUSH_STDERR" >&2
    cursor_set_raise_push_rejection unclassified-reject \
      "${GARDEN_PUSH_STDERR:-${push_diagnostic:-no push diagnostic}}"
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
contention_record "$DIR" push-attempts 50   # reached the CAS cap: a push wedge (hard guard)
die "could not advance cursor $key after retries"
