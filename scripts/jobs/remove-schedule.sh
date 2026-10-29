#!/bin/bash
# remove-schedule.sh — retire one recurring schedule through the producer CAS.
#
# Usage: remove-schedule.sh [--expect-blob <sha>] <name>
#   --expect-blob <sha>  retire ONLY while schedules/<name>.md on the freshly
#                        synced journal tip is exactly this blob. A deterministic
#                        caller that judged the schedule redundant against one
#                        journal snapshot passes the blob it saw, so a schedule
#                        rewritten in the meantime (re-armed, re-stamped,
#                        re-gated) is preserved rather than retired on a stale
#                        verdict.
# Exit: 0 retired (or already absent); 3 precondition no longer holds (schedule
# preserved); 75 journal offline; 1 retries exhausted (GARDEN_POST_ATTEMPTS).
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/common.sh"
export GARDEN_TAG="remove-schedule"
usage="usage: remove-schedule.sh [--expect-blob <sha>] <name>"
expect_blob=""
if [ "${1:-}" = --expect-blob ]; then
  expect_blob="${2:?$usage}"; shift 2
  [[ "$expect_blob" =~ ^[0-9a-f]{40}([0-9a-f]{24})?$ ]] || die "--expect-blob needs a full object id, got '$expect_blob'"
fi
name="${1:?$usage}"
[ $# -eq 1 ] || die "remove-schedule.sh accepts one schedule name"
case "$name" in -*|*/*|.*|'') die "illegal schedule name '$name'" ;; esac
DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"
for attempt in $(seq 1 "${GARDEN_POST_ATTEMPTS:-50}"); do
  sync_clone "$DIR"
  path="schedules/${name%.md}.md"
  [ -e "$DIR/$path" ] || { log "schedule '$name' already absent"; exit 0; }
  if [ -n "$expect_blob" ]; then
    have="$(git -C "$DIR" rev-parse -q --verify "HEAD:$path" 2>/dev/null || true)"
    if [ "$have" != "$expect_blob" ]; then
      log "schedule '$name' changed since the caller's snapshot (${have:-unreadable} != $expect_blob); preserved"
      exit 3
    fi
  fi
  git -C "$DIR" rm -q "$path"
  rc=0; commit_and_push "$DIR" "schedule($name) retired" || rc=$?
  [ "$rc" -eq 0 ] && { log "retired schedule '$name'"; exit 0; }
  backoff "$attempt"
done
die "could not retire schedule '$name'"
