#!/bin/bash
# subscription-used-percent-batches-test.sh — a usage ledger too big for one xargs
# command line runs jq once per batch. The newest sample must win whichever batch
# holds it. Reading only the first row made the figure depend on directory order,
# and a first batch with no samples read as unknown, dropping admission to the
# token estimate (2026-11-02: a pool really at 70% read 35%, flipping backoff to ok).
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-sub-used-batches.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
export GARDEN_TEST=1 GARDEN=host-one GARDEN_STATE="$TR/state"
# shellcheck source=/dev/null
. "$JOBS/usage-meter.sh"
P=0 F=0
ok() { P=$((P+1)); echo "ok - $*"; }
bad() { F=$((F+1)); echo "not ok - $*"; }

D="$TR/journal"
mkdir -p "$D/usage" "$D/config" "$D/budget/reset-events"
printf 'sub-one anthropic weekly-tokens 1000 measured\n' > "$D/config/budget-pools"
printf 'sub-one\thost-one\tmonk\n' > "$D/config/subscription-mapping"
printf '%s\n' '{"cadence":"calendar","schedule_weekday":2,"schedule_time":"00:00","timezone":"UTC","reset_at":"2026-09-22T00:00:00Z","type":"observed-reset","precision":"scheduled"}' \
  > "$D/budget/reset-events/sub-one.jsonl"
GARDEN_USAGE_NOW="$(date -u -d 2026-09-30T04:00:00Z +%s)"; export GARDEN_USAGE_NOW
row() { jq -cn --arg ts "$1" --arg host "$2" --argjson u "$3" \
  '{ts:$ts,host:$host,provider:"anthropic",rate_limit:{sampled_at:$ts,seven_day:{utilization:$u}}}'; }

pad="$(printf 'p%.0s' $(seq 1 200))"
for i in $(seq 1 800); do : > "$D/usage/$pad-$i.jsonl"; done
# Sorted names pin the order: empties fill the early batches.
find() { command find "$@" | sort -z; }
batches="$(find "$D/usage" -maxdepth 1 -type f -name '*.jsonl' -print0 | xargs -0 -r sh -c 'echo x' _ | wc -l)"
[ "$batches" -ge 2 ] && ok "fixture spans $batches xargs batches" || bad "fixture fit one batch; the cases below prove nothing"

row 2026-09-30T03:58:00Z host-one 0.91 > "$D/usage/zzz-last.jsonl"
got="$(subscription_used_percent sub-one "$D" || echo none)"
[ "$got" = 91 ] && ok "sample only in the last batch is read, not unknown" || bad "last-batch sample read $got, want 91"

# An older sample in the first batch must not shadow the newer one.
row 2026-09-30T03:00:00Z host-one 0.40 > "$D/usage/aaa-first.jsonl"
got="$(subscription_used_percent sub-one "$D" || echo none)"
[ "$got" = 91 ] && ok "older first-batch sample does not shadow the newest" || bad "read $got, want 91 (first-batch shadow)"

# No samples anywhere is still unknown.
rm -f "$D/usage/zzz-last.jsonl" "$D/usage/aaa-first.jsonl"
subscription_used_percent sub-one "$D" >/dev/null 2>&1 && bad "no samples read as a figure" || ok "no samples reports unknown"

echo "subscription-used-percent-batches-test: $P passed, $F failed"
[ "$F" -eq 0 ]
