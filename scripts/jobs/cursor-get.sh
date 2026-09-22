#!/bin/bash
# cursor-get.sh — read a journal-backed poll cursor.
#
# Usage: cursor-get.sh <key>        (e.g. activity/kriscendobot-endo)
# Prints the cursor's contents (empty if none). Cursors live in the journal
# (cursors/<key>), so a poller resumes from the last committed position after a
# restart or a failed run — and across hosts. The caller parses the body
# (typically `last_event_id` / `etag` / `last_polled_at` for a GitHub activity
# stream, or `last_sha` for a branch).

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="cursor-get"

key="${1:?usage: cursor-get.sh <key>}"
case "$key" in /*|*..*|'') die "illegal cursor key '$key'";; esac

DIR="${GARDEN_CURSOR_CLONE:-$GARDEN_STATE/cursors/journal}"

# --- host-shared journal-read outage cooldown (herd suppression) --------------
# Every per-repo triager/comment/mention/issue-inbox watcher opens each tick with a
# cursor-get. On a journal-connectivity outage a bare sync_clone burns up to
# ~GARDEN_FETCH_TIMEOUT * GARDEN_FETCH_RETRIES seconds and logs an offline line — once
# per repo per watcher-kind, a self-inflicted thundering herd of doomed fetches. So:
# consult the host-wide outage latch FIRST — before even the clone step below. If a
# sibling already latched a live window, report temporary-unavailable
# (GARDEN_OFFLINE_RC) IMMEDIATELY — no clone, no fetch, no warning.
if journal_outage_active; then
  exit "${GARDEN_OFFLINE_RC:-75}"
fi

# Serialize against every other cursor-get/cursor-set on this host: they all share
# ONE local clone ($DIR). cursor-get's fetch + `reset --hard` (inside sync_clone
# below) mutates the shared index, which must not race a concurrent cursor-set write
# on the same working tree (see cursor_io_lock). Hold the host-local cursor-IO lock
# in the parent shell across ensure_clone, sync_clone, and the final read; the fd
# releases on process exit. On a bounded-wait timeout a peer is wedged holding the
# clone — log it (so a real wedge is never silent) and skip this tick as
# temporary-unavailable rather than hard-failing the watcher; a concurrent cursor-set
# still advances the cursor, and the caller retries next cadence.
if ! cursor_io_lock "$DIR"; then
  log "cursor-get: cursor-IO lock for $DIR busy >${GARDEN_CURSOR_LOCK_WAIT}s ($(_cursor_io_lock_holder "$DIR")); skipping tick (rc=${GARDEN_OFFLINE_RC:-75})"
  exit "${GARDEN_OFFLINE_RC:-75}"
fi

# Clone creation/repair runs before any fetch. A local checkout, ownership, or
# configuration fault here must stay LOUD and must never poison the shared latch —
# but a correlated network outage that strikes DURING a needed (re)clone (a fresh
# host, a reaped/partial clone) is the same weather the fetch path already latches.
# ensure_clone_or_latch_outage classifies the two: a transport outage latches the
# host cooldown and exits GARDEN_OFFLINE_RC; only positively-identified local, auth,
# corruption, or missing-upstream failures are re-raised loud with their original rc.
ensure_clone_or_latch_outage "$DIR" cursor-get

# No live latch: probe once. Run sync_clone in a SUBSHELL so its offline `exit
# "$GARDEN_OFFLINE_RC"` (an exit, not a return) does not terminate us before we can
# latch. Capture the diagnostic as well: git sometimes reports a correlated journal
# transport failure as the otherwise-ambiguous rc=1 without one of its stable network
# strings. Those failures still carry journal_fetch's bounded-retry line. Treat that
# narrow shape as temporary unless the underlying diagnostic positively identifies an
# authentication/upstream/local-clone problem. Capturing also lets all concurrent
# detectors race through the atomic latch without each printing its own fetch failure.
sync_err="$(mktemp "${TMPDIR:-/tmp}/garden-cursor-get.XXXXXX")" \
  || die "cannot create cursor-read diagnostic file"
trap 'rm -f "$sync_err"' EXIT
if ( sync_clone "$DIR" ) 2>"$sync_err"; then rc=0; else rc=$?; fi
sync_diagnostic="$(cat "$sync_err")"

ambiguous_fetch_outage=1
if journal_bounded_fetch_is_ambiguous_outage "$rc" "$sync_diagnostic"; then
  ambiguous_fetch_outage=0
fi

if [ "$rc" -eq "${GARDEN_OFFLINE_RC:-75}" ] || [ "$ambiguous_fetch_outage" -eq 0 ]; then
  # A genuine journal-read outage. Latch the shared cooldown so sibling cursor reads
  # skip quietly for the window; the tick that wins the latch owns the single warning.
  if start_journal_outage_cooldown cursor-get; then
    log "journal-read outage; latched host cooldown ($(_journal_outage_secs)s) so sibling cursor reads skip quietly"
  fi
  exit "${GARDEN_OFFLINE_RC:-75}"
fi
if [ "$rc" -ne 0 ]; then
  # Preserve LOUD local-clone, upstream, authentication, and other unclassified
  # failures. Replay the captured diagnostic exactly once and re-raise the original
  # rc, so a real defect is never masked by the temporary-unavailable path.
  [ -z "$sync_diagnostic" ] || printf '%s\n' "$sync_diagnostic" >&2
  exit "$rc"
fi

# The read succeeded, so connectivity was available for this probe. Recovery remains
# window-bounded: do NOT clear an enabled cooldown here. Another cursor reader may have
# failed and opened a fresh host-wide outage window while this fetch was in flight; a
# late success from this older probe must not erase that correlated episode and release
# the herd. The only cleanup needed here is for the escape-hatch case (secs=0), where
# journal_outage_active deliberately ignores a leftover marker without reaping it.
if [ "$(_journal_outage_secs)" -eq 0 ]; then
  clear_journal_outage_cooldown
fi
[ -f "$DIR/cursors/$key" ] && cat "$DIR/cursors/$key" || true
