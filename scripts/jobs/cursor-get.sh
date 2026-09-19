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
ensure_clone "$DIR"

# --- host-shared journal-read outage cooldown (herd suppression) --------------
# Every per-repo triager/comment/mention/issue-inbox watcher opens each tick with a
# cursor-get. On a journal-connectivity outage a bare sync_clone burns up to
# ~GARDEN_FETCH_TIMEOUT * GARDEN_FETCH_RETRIES seconds and logs an offline line — once
# per repo per watcher-kind, a self-inflicted thundering herd of doomed fetches. So:
# consult the host-wide outage latch FIRST. If a sibling already latched a live window,
# report temporary-unavailable (GARDEN_OFFLINE_RC) IMMEDIATELY — no fetch, no warning.
if journal_outage_active; then
  exit "${GARDEN_OFFLINE_RC:-75}"
fi

# No live latch: probe once. Run sync_clone in a SUBSHELL so its offline `exit
# "$GARDEN_OFFLINE_RC"` (an exit, not a return) does not terminate us before we can
# latch — and so a plain `die` (rc=1, a structural/authentication failure whose stderr
# missed sync_clone's offline signature) is captured too, not swallowed.
if ( sync_clone "$DIR" ); then rc=0; else rc=$?; fi
if [ "$rc" -eq "${GARDEN_OFFLINE_RC:-75}" ]; then
  # A genuine journal-read outage. Latch the shared cooldown so sibling cursor reads
  # skip quietly for the window; the tick that wins the latch owns the single warning.
  if start_journal_outage_cooldown cursor-get; then
    log "journal-read outage; latched host cooldown ($(_journal_outage_secs)s) so sibling cursor reads skip quietly"
  fi
  exit "${GARDEN_OFFLINE_RC:-75}"
fi
if [ "$rc" -ne 0 ]; then
  # Preserve LOUD structural/authentication failures: re-raise the rc unchanged so a
  # real defect is never masked by the temporary-unavailable path.
  exit "$rc"
fi

# The read succeeded, so connectivity is back. A LIVE window would have short-circuited
# us above, so recovery is normally window-bounded (like the gh-api cooldown): the first
# read after the window expires reaps the marker and reads through. This clear is the
# belt-and-suspenders case that path can't cover — a leftover marker while the cooldown
# is toggled OFF (secs=0), where journal_outage_active returns "not active" without
# reaping. Cheap no-op when no marker exists.
clear_journal_outage_cooldown
[ -f "$DIR/cursors/$key" ] && cat "$DIR/cursors/$key" || true
