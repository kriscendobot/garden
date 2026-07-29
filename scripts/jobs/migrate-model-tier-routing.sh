#!/bin/bash
# migrate-model-tier-routing.sh — one-shot CAS migration for queued automatic work.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/common.sh"
GARDEN_TAG="migrate-model-tier-routing"
DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"
for attempt in $(seq 1 50); do
  sync_clone "$DIR"
  changed=0
  for sub in "$JOBS_TODO" "$JOBS_PLAN"; do
    for f in "$DIR/$sub"/*.md; do
      [ -f "$f" ] || continue
      [ "$(plan_field "$f" dispatch)" = manual ] && continue
      tmp="$(mktemp "${TMPDIR:-/tmp}/garden-tier-migrate.XXXXXX")"
      automatic_route_body < "$f" > "$tmp"
      if ! cmp -s "$f" "$tmp"; then mv "$tmp" "$f"; git -C "$DIR" add "${f#"$DIR/"}"; changed=$((changed+1)); else rm -f "$tmp"; fi
    done
  done
  [ "$changed" -gt 0 ] || { log "model-tier migration already current"; exit 0; }
  rc=0; commit_and_push "$DIR" "migrate: route automatic jobs to mentor" || rc=$?
  [ "$rc" -eq 0 ] && { log "migrated $changed queued automatic job(s)"; exit 0; }
  log "migration lost push race (attempt $attempt); re-syncing"; backoff "$attempt"
done
die "could not migrate queued model routing"
