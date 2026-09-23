#!/bin/bash
# panel-seat-tiering-test.sh — panel.sh's per-seat model tiering resolves each seat to
# the right `claude --model` value: opus/unmapped -> inherit (empty), sonnet/haiku ->
# explicit alias, and per-tier/wholesale overrides are honored.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"; ROOT="$(cd "$JOBS/../.." && pwd)"
PANEL="$ROOT/scripts/jobs/gardening/panel.sh"
TSV="$ROOT/scripts/jobs/gardening/seat-model-tiers.tsv"
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }

# Extract seat_model_flag out of panel.sh (sourcing panel.sh runs its main body).
fn="$(awk '/^seat_model_flag\(\)/{p=1} p{print} p&&/^}/{exit}' "$PANEL")"
[ -n "$fn" ] || { echo "could not extract seat_model_flag from panel.sh"; exit 1; }
eval "$fn"
# panel.sh sets these via `: "${VAR:=default}"` before the function; the extracted
# function does not carry those lines, so seed them here (the resolver reads them).
export GARDEN_PANEL_SEAT_TIERS="$TSV"
export GARDEN_PANEL_MODEL_SONNET="${GARDEN_PANEL_MODEL_SONNET:-sonnet}"
export GARDEN_PANEL_MODEL_HAIKU="${GARDEN_PANEL_MODEL_HAIKU:-haiku}"

check() { # <expected> <seat> [desc]
  local got; got="$(seat_model_flag "$2")"
  [ "$got" = "$1" ] && ok "${3:-seat $2} -> '${1:-<inherit>}'" || bad "seat $2: expected '$1' got '$got'"
}

# defaults from the shipped TSV
check ""       saboteur   "opus seat inherits (empty)"
check ""       warden     "security seat inherits"
check ""       integrator "expert-distilled seat inherits"
check sonnet   typist     "sonnet seat"
check sonnet   assessor   "sonnet seat"
check haiku    orthographer "haiku pre-pass seat"
check haiku    reexport-auditor "haiku pre-pass seat (low-tier responder)"
check haiku    appellate  "appellate decision call"
check sonnet   decider    "decider decision call"
check ""       no-such-seat "unmapped seat inherits (fail-safe)"

# per-tier overrides
GARDEN_PANEL_MODEL_SONNET=claude-sonnet-5 check claude-sonnet-5 typist "sonnet override"
GARDEN_PANEL_MODEL_HAIKU=claude-haiku-4-5-20251001 check claude-haiku-4-5-20251001 pruner "haiku override"

# wholesale TSV override
alt="$(mktemp)"; printf 'typist\thaiku\nsaboteur\tsonnet\n' > "$alt"
GARDEN_PANEL_SEAT_TIERS="$alt" check haiku  typist   "wholesale TSV: typist->haiku"
GARDEN_PANEL_SEAT_TIERS="$alt" check sonnet saboteur "wholesale TSV: saboteur->sonnet"
rm -f "$alt"

# every juror seat directory is present in the shipped map (no seat silently unmapped)
missing=0
for d in "$ROOT"/roles/jurors/*/; do
  s="$(basename "$d")"
  grep -qE "^${s}[[:space:]]" "$TSV" || { echo "    unmapped seat: $s"; missing=$((missing+1)); }
done
[ "$missing" -eq 0 ] && ok "all juror seats appear in seat-model-tiers.tsv" || bad "$missing seat(s) unmapped"

echo "panel-seat-tiering-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
