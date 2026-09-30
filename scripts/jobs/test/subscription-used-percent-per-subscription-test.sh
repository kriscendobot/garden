#!/bin/bash
# subscription-used-percent-per-subscription-test.sh — the claim gate's Claude
# utilization is per subscription. Two accounts on two hosts report different
# seven-day utilizations into the shared usage ledger; each subscription must
# read its own host's figure, never whichever host reported last (2026-09-30:
# claude-endolin1 at 73% read claude-endolin2's 57%).
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-sub-used-pct.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
export GARDEN_TEST=1 GARDEN=host-one GARDEN_STATE="$TR/state"
# shellcheck source=/dev/null
. "$JOBS/usage-meter.sh"
P=0 F=0
ok() { P=$((P+1)); echo "ok - $*"; }
bad() { F=$((F+1)); echo "not ok - $*"; }

D="$TR/journal"
mkdir -p "$D/usage" "$D/config" "$D/budget/reset-events"
printf '%s\n' 'sub-one anthropic weekly-tokens 1000 measured' 'sub-two anthropic weekly-tokens 1000 measured' \
  'sub-idle anthropic weekly-tokens 1000 measured' 'codex-x openai percent 100 measured' > "$D/config/budget-pools"
printf 'sub-one\thost-one\tmonk\nsub-one\thost-one\tgardener\nsub-two\thost-two\tmonk\nsub-idle\thost-three\tmonk\ncodex-x\thost-one\tcleric\n' \
  > "$D/config/subscription-mapping"
for s in sub-one sub-two sub-idle codex-x; do
  printf '%s\n' '{"cadence":"calendar","schedule_weekday":2,"schedule_time":"00:00","timezone":"UTC","reset_at":"2026-09-22T00:00:00Z"}' \
    > "$D/budget/reset-events/$s.jsonl"
done
GARDEN_USAGE_NOW="$(date -u -d 2026-09-30T04:00:00Z +%s)"; export GARDEN_USAGE_NOW
row() { jq -cn --arg ts "$1" --arg host "$2" --argjson u "$3" \
  '{ts:$ts,host:$host,provider:"anthropic",rate_limit:{sampled_at:$ts,seven_day:{utilization:$u}}}'; }
# host-one reported 73% earlier; host-two reported 57% last.
{ row 2026-09-30T03:50:00Z host-one 0.73; row 2026-09-30T03:55:00Z host-two 0.57; } > "$D/usage/a.jsonl"

[ "$(subscription_used_percent sub-one "$D")" = 73 ] && ok "sub-one reads its own host (73), not the newest row" \
  || bad "sub-one read $(subscription_used_percent sub-one "$D" || echo none)"
[ "$(subscription_used_percent sub-two "$D")" = 57 ] && ok "sub-two reads its own host (57)" \
  || bad "sub-two read $(subscription_used_percent sub-two "$D" || echo none)"
subscription_used_percent sub-idle "$D" >/dev/null 2>&1 && bad "sub-idle borrowed another account's utilization" \
  || ok "subscription with no ledger rows reports unknown"
subscription_used_percent codex-x "$D" >/dev/null 2>&1 && bad "cleric-only subscription read anthropic ledger" \
  || ok "cleric-only subscription ignores the anthropic ledger"

# Fallbacks survive: a fresher live snapshot for sub-one still wins.
mkdir -p "$D/budget/live/sub-one"
printf 'sampled_at_epoch: %s\nused_percent: 80\n' "$(date -u -d 2026-09-30T03:58:00Z +%s)" > "$D/budget/live/sub-one/host-one"
[ "$(subscription_used_percent sub-one "$D")" = 80 ] && ok "fresher live used_percent still overrides" || bad "live fallback lost"
[ "$(subscription_used_percent sub-two "$D")" = 57 ] && ok "sub-one's live snapshot does not leak into sub-two" || bad "live leak"

# Pre-migration journal (no mapping): the ledger is read unfiltered, as before.
rm "$D/config/subscription-mapping"
[ "$(subscription_used_percent sub-two "$D")" = 57 ] && ok "no mapping: newest ledger row (legacy)" || bad "legacy unfiltered read"

echo "subscription-used-percent-per-subscription-test: $P passed, $F failed"
[ "$F" -eq 0 ]
