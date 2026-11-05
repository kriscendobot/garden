#!/bin/bash
# defer-gauntlet-status-probe.sh — return one claimed deterministic probe to todo.
#
# Usage: defer-gauntlet-status-probe.sh <gardener-id> <job-base> [delay-seconds]
#
# The current claim is consumed in the same CAS that re-posts its body.  No tada is
# written: an orchestration therefore continues to see the one child as active.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"

id="${1:?usage: defer-gauntlet-status-probe.sh <gardener-id> <job-base> [delay-seconds]}"
base="${2:?missing job base}"
delay="${3:-180}"
case "$base" in -*|*/*|.*|'') die "illegal basename: '$base'";; esac
case "$delay" in ''|*[!0-9]*) die "delay must be a positive integer";; esac
[ "$delay" -gt 0 ] || die "delay must be a positive integer"

export GARDEN_TAG="gauntlet-probe-defer/$id"
DIR="${GARDEN_WORKER_CLONE:-$GARDEN_STATE/monks/$id/journal}"
ensure_clone "$DIR"

for attempt in $(seq 1 100); do
  sync_clone "$DIR"
  src="$DIR/$JOBS_DOIN/$base.md"
  dst="$DIR/$JOBS_TODO/$base.md"
  # A prior replay may already have landed.  Trust it only when the exact probe is
  # still live in todo; a terminal completion must never be resurrected.
  if [ ! -f "$src" ]; then
    if [ -f "$dst" ] && [ -n "$(plan_field "$dst" gauntlet-status-probe)" ]; then exit 0; fi
    die "claimed gauntlet status probe '$base' is no longer in doin"
  fi
  [ -n "$(plan_field "$src" gauntlet-status-probe)" ] \
    || die "refusing to defer non-probe job '$base'"
  due="$(date -u -d "+$delay seconds" +%FT%TZ)"
  body="$(mktemp "${TMPDIR:-/tmp}/gauntlet-probe-body.XXXXXX")"
  cut_claim_block "$src" \
    | sed -E '/^<!--[[:space:]]*garden-gauntlet-probe-not-before:.*-->$/d' \
    > "$body"
  printf '\n<!-- garden-gauntlet-probe-not-before: %s -->\n' "$due" >> "$body"
  mkdir -p "$(dirname "$dst")"
  mv "$body" "$dst"
  git -C "$DIR" rm -q "$JOBS_DOIN/$base.md"
  git -C "$DIR" add "$JOBS_TODO/$base.md"
  rc=0; commit_and_push "$DIR" "gauntlet-probe($base) active; check after $due" || rc=$?
  [ "$rc" -eq 0 ] && { log "gauntlet status probe '$base' remains active; deferred until $due"; exit 0; }
  backoff "$attempt"
done
die "could not defer gauntlet status probe '$base' after retries"
