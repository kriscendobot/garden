#!/bin/bash
# openrouter-promo-drop.sh — the per-id RIP-CORD: remove a cloaked OpenRouter id.
#
# Usage: openrouter-promo-drop.sh <wire-id>
#
# Deletes <wire-id>'s row from the journal ledger config/openrouter-promos, so the id
# is immediately unclaimable (fails closed at classification) even at pool > 0. This is
# the half of the rip-cord that removes the specific id; `set-openrouter-promos.sh 0`
# is the half that zeroes the whole lane's pool (context/operations/openrouter.md §
# Rip-cord). Idempotent: dropping an absent id is a clean no-op.
#
# The scheduled recheck (openrouter-promo-recheck.sh) calls this same removal path
# automatically when an id 404s or its attestation has gone stale.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="openrouter-promo-drop"

wire="${1:?usage: openrouter-promo-drop.sh <wire-id>}"
rel="${GARDEN_OPENROUTER_PROMOS_PATH:-config/openrouter-promos}"

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

for attempt in $(seq 1 50); do
  sync_clone "$DIR"
  f="$DIR/$rel"
  if [ ! -f "$f" ]; then log "no openrouter-promo ledger; nothing to drop"; exit 0; fi
  if ! awk -F'\t' -v w="$wire" '$1 == w { found=1 } END { exit !found }' "$f"; then
    log "openrouter-promo id $wire not in ledger; nothing to drop"; exit 0
  fi
  awk -F'\t' -v w="$wire" '$1 != w { print }' "$f" > "$f.tmp"
  mv "$f.tmp" "$f"
  git -C "$DIR" add "$rel"
  rc=0; commit_and_push "$DIR" "openrouter-promo drop $wire (rip-cord)" || rc=$?
  [ "$rc" -eq 0 ] && { log "dropped openrouter-promo id $wire"; exit 0; }
  [ "$rc" -eq 2 ] && { log "openrouter-promo id $wire already absent"; exit 0; }
  log "drop lost a push race (attempt $attempt); retrying"
  backoff "$attempt"
done
die "could not drop openrouter-promo id $wire after retries"
