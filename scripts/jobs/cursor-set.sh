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
# Clone creation/repair is local setup, not evidence of a transport episode. Keep it
# outside the outage classifier so configuration, ownership, and clone failures stay
# loud and cannot poison the host-wide latch.
ensure_clone "$DIR"

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
      && ! _fetch_stderr_is_auth_failure "$GARDEN_FETCH_STDERR" \
      && ! _fetch_stderr_is_upstream_gone "$GARDEN_FETCH_STDERR" \
      && ! _fetch_stderr_is_corrupt "$GARDEN_FETCH_STDERR" \
      && ! journal_diagnostic_is_local_failure "$GARDEN_FETCH_STDERR"; }; then
    cursor_set_latch_outage "${GARDEN_PUSH_STDERR:-${GARDEN_FETCH_STDERR:-$push_diagnostic}}"
  fi

  # Positive structural/authentication diagnostics must not be diluted into fifty
  # generic rc=1 retries. Re-raise them on the first observation. An ordinary CAS
  # rejection has neither signature and retains the existing retry behavior.
  combined_diagnostic="${GARDEN_PUSH_STDERR}${GARDEN_FETCH_STDERR}${push_diagnostic}"
  if _fetch_stderr_is_auth_failure "$combined_diagnostic" \
    || _fetch_stderr_is_upstream_gone "$combined_diagnostic" \
    || _fetch_stderr_is_corrupt "$combined_diagnostic" \
    || journal_diagnostic_is_local_failure "$combined_diagnostic"; then
    [ -z "$combined_diagnostic" ] || printf '%s\n' "$combined_diagnostic" >&2
    exit "$rc"
  fi
  backoff "$attempt"
done
die "could not advance cursor $key after retries"
