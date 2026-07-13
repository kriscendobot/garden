#!/bin/bash
# set-workers.sh — declare a host's concurrent count for one worker KIND.
#
# Usage: set-workers.sh <kind> <N> [host]   (kind ∈ gardener|cleric; host defaults
#                                            to this host)
#
# Per-host worker concurrency is garden state, so it lives on the bus: writes the
# journal hosts/<host> file's `<count_key>: N` line for the given kind (gardeners: /
# clerics:). The gardener-scaler service on that host watches for the change and
# reconciles its local pool for THAT kind. A host may thus be scaled from anywhere
# (any host, or a human), and the change propagates via the journal push.
#
# A host's hosts/<host> file holds an INDEPENDENT count line per kind. This writer
# updates ONLY the named kind's line and PRESERVES every other kind's line — so
# `set-workers.sh cleric 4` never disturbs an existing `gardeners: N`, and a sibling
# kind that was never declared stays undeclared (a no-op for the scaler) rather than
# being written as an explicit 0 (which would scale it to zero).

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="set-workers"

kind="${1:?usage: set-workers.sh <kind> <N> [host]}"
n="${2:?usage: set-workers.sh <kind> <N> [host]}"
host="${3:-$GARDEN}"
count_key="$(worker_kind_field "$kind" count_key)" || die "unknown worker kind '$kind' (known: $(worker_kinds | paste -sd'|' -))"
[[ "$n" =~ ^[0-9]+$ ]] || die "count must be a non-negative integer"

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

for attempt in $(seq 1 50); do
  sync_clone "$DIR"
  mkdir -p "$DIR/hosts"
  f="$DIR/hosts/$host"
  # Gather each kind's CURRENT declared count from the existing file, override the
  # target kind with N, and rewrite — so a sibling kind's count is preserved and an
  # undeclared sibling stays undeclared (never forced to 0).
  {
    for k in $(worker_kinds); do
      ck="$(worker_kind_field "$k" count_key)"
      if [ "$k" = "$kind" ]; then
        printf '%s: %s\n' "$ck" "$n"
      else
        cur="$(sed -n "s/^$ck:[[:space:]]*//p" "$f" 2>/dev/null | head -1)"
        [[ "$cur" =~ ^[0-9]+$ ]] && printf '%s: %s\n' "$ck" "$cur"
      fi
    done
    printf 'updated_at: %s\n' "$(date -u +%FT%TZ)"
    printf 'updated_by: %s\n' "$GARDEN"
  } > "$f.tmp"
  mv "$f.tmp" "$f"
  git -C "$DIR" add "hosts/$host"
  # Capture with `|| rc=$?` (a false `if` with no `else` is exit 0 and would
  # swallow commit_and_push's rc=2 "nothing to commit" on an idempotent re-run).
  rc=0; commit_and_push "$DIR" "hosts($host) $count_key=$n" || rc=$?
  [ "$rc" -eq 0 ] && { log "declared $host $count_key=$n"; exit 0; }
  [ "$rc" -eq 2 ] && { log "$host already at $count_key=$n"; exit 0; }
  log "set-workers lost a push race (attempt $attempt); retrying"
  backoff "$attempt"
done
die "could not declare $count_key for $host after retries"
