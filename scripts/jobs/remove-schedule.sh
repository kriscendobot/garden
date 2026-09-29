#!/bin/bash
# remove-schedule.sh — retire one recurring schedule through the producer CAS.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/common.sh"
export GARDEN_TAG="remove-schedule"
name="${1:?usage: remove-schedule.sh <name>}"
[ $# -eq 1 ] || die "remove-schedule.sh accepts one schedule name"
case "$name" in -*|*/*|.*|'') die "illegal schedule name '$name'" ;; esac
DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"
for attempt in $(seq 1 "${GARDEN_POST_ATTEMPTS:-50}"); do
  sync_clone "$DIR"
  path="schedules/${name%.md}.md"
  [ -e "$DIR/$path" ] || { log "schedule '$name' already absent"; exit 0; }
  git -C "$DIR" rm -q "$path"
  rc=0; commit_and_push "$DIR" "schedule($name) retired" || rc=$?
  [ "$rc" -eq 0 ] && { log "retired schedule '$name'"; exit 0; }
  backoff "$attempt"
done
die "could not retire schedule '$name'"
