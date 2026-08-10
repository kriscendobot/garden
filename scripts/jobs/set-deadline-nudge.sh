#!/bin/bash
# set-deadline-nudge.sh - enable, disable, or report the shared courtesy timer.
#
# The journal-backed value follows a leader handoff. It changes no job body and
# does not drain workers; the leader's next scanner tick observes it.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="set-deadline-nudge"

action="${1:-status}"
case "$action" in on|off|status) : ;; *) die "usage: set-deadline-nudge.sh on|off|status" ;; esac

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

if [ "$action" = status ]; then
  sync_clone "$DIR"
  state="$(head -1 "$DIR/$GARDEN_DEADLINE_NUDGE_CONFIG_PATH" 2>/dev/null || echo on)"
  clone_unlock "$DIR"
  log "deadline nudge ${state:-on}"
  exit 0
fi

for attempt in $(seq 1 50); do
  sync_clone "$DIR"
  mkdir -p "$DIR/$(dirname "$GARDEN_DEADLINE_NUDGE_CONFIG_PATH")"
  printf '%s\n' "$action" > "$DIR/$GARDEN_DEADLINE_NUDGE_CONFIG_PATH"
  git -C "$DIR" add "$GARDEN_DEADLINE_NUDGE_CONFIG_PATH"
  rc=0
  commit_and_push "$DIR" "config: deadline-nudge=$action" || rc=$?
  [ "$rc" -eq 0 ] && { log "deadline nudge $action"; exit 0; }
  [ "$rc" -eq 2 ] && { log "deadline nudge already $action"; exit 0; }
  log "set-deadline-nudge lost a push race (attempt $attempt); retrying"
  backoff "$attempt"
done
die "could not set deadline nudge after retries"
