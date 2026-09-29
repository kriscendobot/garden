#!/bin/bash
# seed-ironhorse-press.sh — park the first foreman-only Ironhorse press.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/common.sh"
export GARDEN_TAG="seed-ironhorse-press"

not_before="${1:-$(date -u +%FT%TZ)}"
[ $# -le 1 ] || die "usage: seed-ironhorse-press.sh [not-before-ISO-UTC]"
not_before="$(date -u -d "$not_before" +%FT%TZ 2>/dev/null)" \
  || die "not-before must be a parseable ISO-UTC timestamp"
now_epoch="${GARDEN_PRESS_NOW:-$(date -u +%s)}"
case "$now_epoch" in ''|*[!0-9]*) die "invalid GARDEN_PRESS_NOW '$now_epoch'" ;; esac
posted_at="$(date -u -d "@$now_epoch" +%FT%TZ)"
stamp="$(date -u -d "@$now_epoch" +%Y%m%d-%H%M%S)"
base="ironhorse-test262-press-$stamp"
DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

for attempt in $(seq 1 "${GARDEN_POST_ATTEMPTS:-50}"); do
  sync_clone "$DIR"
  python3 "$HERE/ratchet/policy.py" active "$DIR" >/dev/null \
    || die "Ironhorse delegation is not active"
  for d in "$JOBS_PLAN" "$JOBS_TODO" "$JOBS_DOIN"; do
    for f in "$DIR/$d"/ironhorse-test262-press-[0-9]*.md; do
      [ -e "$f" ] || continue
      python3 "$HERE/ratchet/policy.py" job "$DIR" "$f" >/dev/null \
        || die "live Ironhorse press '$(basename "$f")' is noncanonical"
      log "live Ironhorse press '$(basename "$f" .md)' already exists; seed is idempotent"
      exit 0
    done
  done
  tada_exists "$DIR" "$base" && die "seed basename '$base' collides with tada"
  mkdir -p "$DIR/$JOBS_PLAN"
  python3 "$HERE/ratchet/policy.py" plan "$DIR" "$DIR/$JOBS_PLAN/$base.md" \
    "$not_before" "$posted_at" >/dev/null || die "could not compose canonical press"
  git -C "$DIR" add "$JOBS_PLAN/$base.md"
  if commit_and_push "$DIR" "plan($base) initial Ironhorse foreman press"; then
    log "parked initial Ironhorse press '$base' (not_before=$not_before)"
    exit 0
  fi
  backoff "$attempt"
done
die "could not seed initial Ironhorse press"
