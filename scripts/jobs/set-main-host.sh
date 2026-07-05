#!/bin/bash
# set-main-host.sh — designate the leader host in the journal. Manual, no failover.
#
# Usage: set-main-host.sh <garden-identity>   (defaults to this host's GARDEN)
#
# The leader host is the one host that runs the garden's SINGLETON services
# (foreman, scheduler, bulletin, deadmail, reaper, follow-up, proxy, mentor,
# mirror-closer, the comment/mention watchers, the library-source-drift scan, and
# the liaison maintainer-inbox Monitor). None of them handle concurrent duplicates,
# so they run on exactly one host. Gardeners run on EVERY host regardless.
#
# Which host is the leader is JOURNAL STATE: this writes the single `leader` file
# (at the journal root) with the leader's GARDEN identity and CAS-races it onto
# origin/journal2 the same way set-gardeners.sh writes hosts/<host>. Every host's
# is-main-host.sh predicate then reads it. Changing the leader is this one journal
# edit (by hand) — there is no automatic failover; if the leader dies the
# singletons stay down until the marker is re-pointed. See issue
# kriskowal/garden#11 and designs/multibot-leader-follower.md.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="set-main-host"

leader="${1:-$GARDEN}"
[ -n "$leader" ] || die "usage: set-main-host.sh <garden-identity>"
case "$leader" in *[!A-Za-z0-9._-]*) die "leader identity must match [A-Za-z0-9._-]" ;; esac

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

for attempt in $(seq 1 50); do
  sync_clone "$DIR"
  marker_dir="$(dirname "$GARDEN_LEADER_MARKER_PATH")"
  [ "$marker_dir" = "." ] || mkdir -p "$DIR/$marker_dir"
  current="$(head -1 "$DIR/$GARDEN_LEADER_MARKER_PATH" 2>/dev/null | tr -d '[:space:]' || true)"
  if [ "$current" = "$leader" ]; then
    log "leader host already $leader; nothing to do"; exit 0
  fi
  printf '%s\n' "$leader" > "$DIR/$GARDEN_LEADER_MARKER_PATH"
  git -C "$DIR" add "$GARDEN_LEADER_MARKER_PATH"
  # Capture with `|| rc=$?` (a false `if` with no `else` is exit 0 and would
  # swallow commit_and_push's rc=2 "nothing to commit" on an idempotent re-run).
  rc=0; commit_and_push "$DIR" "leader=$leader (designated by $GARDEN)" || rc=$?
  [ "$rc" -eq 0 ] && { log "designated leader host: $leader"; exit 0; }
  [ "$rc" -eq 2 ] && { log "leader host already $leader"; exit 0; }
  log "set-main-host lost a push race (attempt $attempt); retrying"
  backoff "$attempt"
done
die "could not designate leader host $leader after retries"
