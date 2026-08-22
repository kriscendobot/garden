#!/bin/bash
# openrouter-promo-attest.sh — enable / re-attest a cloaked ("stealth") OpenRouter id.
#
# Usage: openrouter-promo-attest.sh <wire-id> <tier> [attested-by]
#   <wire-id>      the EXACT OpenRouter model id sent on the wire (the value AFTER the
#                  garden `openrouter-promo/` namespace, e.g. `openrouter/horizon-beta`).
#   <tier>         mentat | mentor | minion | myrmidon — the dispatch tier this cloaked
#                  id is admitted at (usually minion; NEVER mentat unless the operator
#                  means it as an authorization boundary).
#   [attested-by]  the maintainer login recording the review; defaults to the git
#                  user.name of this checkout. Self-asserted (like a host-op from_host).
#
# This is the "short mandatory re-review cadence" made concrete: it CAS-writes a row
# to the journal ledger config/openrouter-promos stamping attested_at=now. The read
# side (common.sh _openrouter_promo_wire_tier) admits the id ONLY while that stamp is
# within GARDEN_OPENROUTER_PROMO_CADENCE_SECS (24h) of now — so an id you do not
# re-run this command for within the window AUTOMATICALLY falls out of service
# (fails closed), with no daemon required. Re-running it refreshes the window.
#
# A cloaked model's operator and data policy are undisclosed BY DEFINITION; running
# this command accepts ONLY that "we do not know which model this is" risk. The ZDR /
# deny-collection request controls are still forced on every request by the same
# fail-closed privacy proxy the stable lane uses — that is not relaxable here.
#
# Maintainer-directed, host-side, like the first canary. It does NOT enable a worker;
# set the pool with set-openrouter-promos.sh AFTER a status-only canary (see
# context/operations/openrouter.md § The promo (stealth) lane).
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="openrouter-promo-attest"

wire="${1:?usage: openrouter-promo-attest.sh <wire-id> <tier> [attested-by]}"
tier="${2:?usage: openrouter-promo-attest.sh <wire-id> <tier> [attested-by]}"
by="${3:-$(git -C "$HERE" config --get user.name 2>/dev/null || echo unknown)}"

case "$tier" in mentat|mentor|minion|myrmidon) : ;; *) die "tier must be one of mentat|mentor|minion|myrmidon (got '$tier')";; esac
# The wire id lands in a TAB-separated ledger and, namespaced, in a shell/glob-matched
# routing id; forbid a tab, newline, or whitespace so a row can never be split or a
# selector smuggled.
case "$wire" in
  ''|*[$'\t\n ']*) die "wire id must be non-empty and contain no whitespace/tab/newline" ;;
  \#*)             die "wire id must not begin with '#'" ;;
esac
case "$by" in *[$'\t\n']*) die "attested-by must contain no tab/newline" ;; esac

rel="${GARDEN_OPENROUTER_PROMOS_PATH:-config/openrouter-promos}"
now="$(date -u +%FT%TZ)"

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

for attempt in $(seq 1 50); do
  sync_clone "$DIR"
  mkdir -p "$DIR/$(dirname "$rel")"
  f="$DIR/$rel"
  {
    printf '# openrouter-promo ledger — enabled cloaked/stealth OpenRouter ids.\n'
    printf '# TAB-separated: <wire-id> <tier> <attested_at ISO8601> <attested_by>.\n'
    printf '# A row whose attested_at is older than the re-review cadence STOPS\n'
    printf '# classifying (common.sh _openrouter_promo_wire_tier) — auto-disabled.\n'
    printf '# Refresh with openrouter-promo-attest.sh; drop with openrouter-promo-drop.sh.\n'
    # keep every OTHER id's row unchanged; replace this id's row with a fresh stamp
    if [ -f "$f" ]; then
      awk -F'\t' -v w="$wire" '$1 !~ /^#/ && $1 != "" && $1 != w { print }' "$f"
    fi
    printf '%s\t%s\t%s\t%s\n' "$wire" "$tier" "$now" "$by"
  } > "$f.tmp"
  mv "$f.tmp" "$f"
  git -C "$DIR" add "$rel"
  rc=0; commit_and_push "$DIR" "openrouter-promo attest $wire ($tier) by $by" || rc=$?
  [ "$rc" -eq 0 ] && { log "attested openrouter-promo id $wire tier=$tier attested_by=$by at $now"; exit 0; }
  [ "$rc" -eq 2 ] && { log "openrouter-promo id $wire already attested identically"; exit 0; }
  log "attest lost a push race (attempt $attempt); retrying"
  backoff "$attempt"
done
die "could not attest openrouter-promo id $wire after retries"
