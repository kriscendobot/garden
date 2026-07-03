#!/bin/bash
# complete-job.sh — consumer primitive: finish a job, doin → tada (report).
#
# Usage: complete-job.sh <gardener-id> <basename> <report-file>
#   Removes jobs/doin/<basename> and writes jobs/tada/<basename> from
#   <report-file>, under the SAME reserved basename.
#
# Unlike a claim, completion touches only THIS gardener's own basename, so it
# is safe to retry on push contention: re-sync, re-apply the deterministic
# rm+add, push again.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"

id="${1:?usage: complete-job.sh <gardener-id> <basename> <report-file>}"
base="${2:?missing basename}"
report="${3:?missing report-file}"
GARDEN_TAG="done/$id"
[ -f "$report" ] || die "report file not found: $report"
case "$base" in -*|*/*|.*|'') die "illegal basename: '$base'";; esac

DIR="${GARDEN_GARDENER_CLONE:-$GARDEN_STATE/gardeners/$id/journal}"
ensure_clone "$DIR"

# Completion only touches this gardener's own basename, so it is guaranteed to
# fast-forward once it lands a clean window — retry generously with backoff
# rather than giving up and stranding the job in doin.
for attempt in $(seq 1 100); do
  sync_clone "$DIR"
  mkdir -p "$DIR/$JOBS_TADA"
  cp "$report" "$DIR/$JOBS_TADA/$base.md"
  git -C "$DIR" add "$JOBS_TADA/$base.md"
  [ -e "$DIR/$JOBS_DOIN/$base.md" ] && git -C "$DIR" rm -q "$JOBS_DOIN/$base.md"
  [ -e "$DIR/work/$base" ]       && git -C "$DIR" rm -q "work/$base"
  # destroy this job doer's inbox; its lifetime ends with the job.
  [ -d "$DIR/inbox/$base" ]      && git -C "$DIR" rm -rq "inbox/$base"
  if commit_and_push "$DIR" "tada($base) done $GARDEN/gardener-$id"; then
    log "completed '$base'"
    # This doin→tada→push IS the "gardener job completion" edge: kick the foreman
    # to re-evaluate now rather than at its next poll. Non-blocking + best-effort;
    # never fails or delays this completion (foreman_kick swallows all errors).
    foreman_kick
    exit 0
  fi
  rc=$?
  [ "$rc" -eq 2 ] && { log "'$base' already completed (nothing to commit)"; exit 0; }
  log "completion of '$base' lost a push race (attempt $attempt); retrying"
  backoff "$attempt"
done
die "could not complete '$base' after retries"
