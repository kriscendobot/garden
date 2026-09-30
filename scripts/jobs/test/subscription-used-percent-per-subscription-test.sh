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

# Feedback loop (2026-09-30): the meter republished this helper's own output as
# live used_percent with a fresh sampled_at_epoch, so a contaminated 78 outranked
# the newer per-host ledger forever. Stale-figure live files, newer than every
# ledger row, both untagged (pre-fix) and tagged derived: each subscription must
# still read its own ledger value.
{ row 2026-09-30T03:56:00Z host-one 0.80; row 2026-09-30T03:57:00Z host-two 0.64; } > "$D/usage/b.jsonl"
mkdir -p "$D/budget/live/sub-one" "$D/budget/live/sub-two"
live_at="$(date -u -d 2026-09-30T03:59:00Z +%s)"
printf 'subscription: sub-one\nsampled_at_epoch: %s\nused_percent: 78\n' "$live_at" > "$D/budget/live/sub-one/host-one"
printf 'subscription: sub-two\nsampled_at_epoch: %s\nused_percent: 78\nused_percent_source: derived\n' "$live_at" \
  > "$D/budget/live/sub-two/host-two"
[ "$(subscription_used_percent sub-one "$D")" = 80 ] && ok "stale untagged live echo does not outrank sub-one's ledger (80)" \
  || bad "sub-one read $(subscription_used_percent sub-one "$D" || echo none), want 80"
[ "$(subscription_used_percent sub-two "$D")" = 64 ] && ok "stale derived live echo does not outrank sub-two's ledger (64)" \
  || bad "sub-two read $(subscription_used_percent sub-two "$D" || echo none), want 64"

# The meter's own write tags an anthropic used_percent as derived, and a fixed
# point holds: re-publishing and re-reading keeps the ledger value.
GARDEN=host-one
commit_and_push() { return 0; }; alert_maintainer() { :; }
git -C "$D" init -q 2>/dev/null
GARDEN_BUDGET_SNAPSHOT_SECS=60 GARDEN_BUDGET_SNAPSHOT_STAGGER_SECS=0 _budget_publish_local_pool_once "$D" >/dev/null 2>&1 || true
grep -qx 'used_percent: 80' "$D/budget/live/sub-one/host-one" && grep -qx 'used_percent_source: derived' "$D/budget/live/sub-one/host-one" \
  && ok "meter publishes the ledger value tagged derived" || bad "meter live file: $(cat "$D/budget/live/sub-one/host-one")"
[ "$(subscription_used_percent sub-one "$D")" = 80 ] && ok "republished snapshot stays at the ledger value" || bad "fixed point lost"

# Independently observed live percents (codex rate limits) still count.
mkdir -p "$D/budget/live/codex-x"
printf 'sampled_at_epoch: %s\nused_percent: 42\n' "$live_at" > "$D/budget/live/codex-x/host-one"
[ "$(subscription_used_percent codex-x "$D")" = 42 ] && ok "percent pool's observed live used_percent still read" || bad "codex live lost"

# Pre-migration journal (no mapping): the ledger is read unfiltered, as before.
rm "$D/config/subscription-mapping"
[ "$(subscription_used_percent sub-two "$D")" = 64 ] && ok "no mapping: newest ledger row (legacy)" || bad "legacy unfiltered read"

echo "subscription-used-percent-per-subscription-test: $P passed, $F failed"
[ "$F" -eq 0 ]
