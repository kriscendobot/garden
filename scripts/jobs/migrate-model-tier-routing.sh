#!/bin/bash
# migrate-model-tier-routing.sh — one-shot CAS migration for queued automatic work.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/common.sh"
export GARDEN_TAG="migrate-model-tier-routing"
DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"
for attempt in $(seq 1 50); do
  sync_clone "$DIR"
  changed=0
  for sub in "$JOBS_TODO" "$JOBS_PLAN"; do
    for f in "$DIR/$sub"/*.md; do
      [ -f "$f" ] || continue
      tmp="$(mktemp "${TMPDIR:-/tmp}/garden-tier-migrate.XXXXXX")"
      if [ "$(plan_field "$f" dispatch)" = manual ]; then
        # Deterministic legacy manual Fable conversion; reject other old manual ids.
        if [ "$(job_tier "$f" 2>/dev/null || true)" = mentat ]; then
          sed -E 's/^model:[[:space:]]*(claude-fable-5|mentat|fable)[[:space:]]*$/tier: mentat/' "$f" > "$tmp"
        else cp "$f" "$tmp"; fi
      else automatic_route_body < "$f" > "$tmp"; fi
      if ! cmp -s "$f" "$tmp"; then mv "$tmp" "$f"; git -C "$DIR" add "${f#"$DIR/"}"; changed=$((changed+1)); else rm -f "$tmp"; fi
    done
  done
  [ "$changed" -gt 0 ] || { log "model-tier migration already current"; exit 0; }
  rc=0; commit_and_push "$DIR" "migrate: route automatic jobs to minion Codex" || rc=$?
  [ "$rc" -eq 0 ] && { log "migrated $changed queued or parked automatic job(s)"; exit 0; }
  log "migration lost push race (attempt $attempt); re-syncing"; backoff "$attempt"
done
die "could not migrate queued model routing"
