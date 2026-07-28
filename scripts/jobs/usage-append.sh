#!/bin/bash
# usage-append.sh — bounded, best-effort writer for a non-completing engagement.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/common.sh"

base="${1:?usage: usage-append.sh <base> <elapsed-s> <requeue|fail> [measurement-json]}"
elapsed="${2:?}" outcome="${3:?}" measurement="${4:-${GARDEN_ENGAGEMENT_USAGE:-}}"
case "$base" in -*|*/*|.*|'') exit 2;; esac
case "$outcome" in requeue|fail) ;; *) exit 2;; esac
dir="${GARDEN_GARDENER_CLONE:-$GARDEN_STATE/gardeners/${GARDEN_GARDENER_ID:-0}/journal}"
ensure_clone "$dir"
for attempt in $(seq 1 8); do
  sync_clone "$dir"
  usage_ledger_stage_row "$dir" "$base" "$elapsed" "$outcome" "$measurement" || exit 0
  rc=0; commit_and_push "$dir" "usage($base) $outcome" || rc=$?
  [ "$rc" -eq 0 ] && exit 0
  [ "$rc" -eq 2 ] && exit 0
  backoff "$attempt"
done
# Accounting is observability, never a reason to strand a job.
exit 0
