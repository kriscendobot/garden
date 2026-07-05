#!/bin/bash
# set-gardeners.sh — declare a host's concurrent gardener count in the journal.
#
# Usage: set-gardeners.sh <N> [host]   (host defaults to this host)
#
# Per-host worker concurrency is garden state, so it lives on the bus: writes
# journal hosts/<host> with `gardeners: N`. The gardener-scaler service on that
# host watches for the change and adjusts its local pool. A host may thus be
# scaled from anywhere (any host, or a human), and the change propagates via the
# journal push.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="set-gardeners"

n="${1:?usage: set-gardeners.sh <N> [host]}"
host="${2:-$GARDEN}"
[[ "$n" =~ ^[0-9]+$ ]] || die "count must be a non-negative integer"

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

for attempt in $(seq 1 50); do
  sync_clone "$DIR"
  mkdir -p "$DIR/hosts"
  printf 'gardeners: %s\nupdated_at: %s\nupdated_by: %s\n' \
    "$n" "$(date -u +%FT%TZ)" "$GARDEN" > "$DIR/hosts/$host"
  git -C "$DIR" add "hosts/$host"
  # Capture with `|| rc=$?` (a false `if` with no `else` is exit 0 and would
  # swallow commit_and_push's rc=2 "nothing to commit" on an idempotent re-run).
  rc=0; commit_and_push "$DIR" "hosts($host) gardeners=$n" || rc=$?
  [ "$rc" -eq 0 ] && { log "declared $host gardeners=$n"; exit 0; }
  [ "$rc" -eq 2 ] && { log "$host already at gardeners=$n"; exit 0; }
  log "set-gardeners lost a push race (attempt $attempt); retrying"
  backoff "$attempt"
done
die "could not declare gardener count for $host after retries"
