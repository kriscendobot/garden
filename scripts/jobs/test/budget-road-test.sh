#!/bin/bash
# Hermetic contract for the budget road (designs/budget-road.md): the formulas
# (maintainer reserve decay, lane reservation, discretion, the 0.90 ceiling), the
# pool verdict and per-arc admission, laning (go-ahead and blocked plans hold no
# lane, a mid-week holder change), the pin, P calibration, the dormant fallback,
# codex staying flat, set-road.sh verbs, and the foreman's promotion order.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TEST_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/garden-budget-road.XXXXXX")"
trap 'rm -rf "$TEST_ROOT"' EXIT
export GARDEN_TEST=1 GARDEN=endolin-garden-ece02cb4 GARDEN_STATE="$TEST_ROOT/state" GARDEN_ROAD_CACHE_SECS=0
export GARDEN_CCUSAGE_LOGDIR="$TEST_ROOT/no-logs"
unset GARDEN_TOKEN_BACKOFF_FRACTION GARDEN_BUDGET_POOLS_FILE GARDEN_ROAD_U GARDEN_ROAD_W_KRIS
# shellcheck source=../common.sh
source "$JOBS/common.sh"

fail=0
ok()  { printf 'ok   %s\n' "$1"; }
bad() { printf 'FAIL %s\n' "$1"; fail=1; }
at()  { date -u -d "$1" +%s; }
near() { awk -v a="$1" -v b="$2" 'BEGIN { d = a - b; if (d < 0) d = -d; exit !(d <= 0.0005) }'; }

J="$TEST_ROOT/journal"
mkdir -p "$J/config" "$J/budget/reset-events" "$J/usage" "$J/jobs/todo" "$J/jobs/doin" "$J/jobs/plan" "$J/allocation" "$J/maintainers"
printf '%s\n' \
  $'claude-endolin1\tanthropic\tweekly-tokens\t100\tfixture\t2026-09-20' \
  $'codex-endolin\topenai\tpercent\t95\tfixture\t2026-09-20' > "$J/config/budget-pools"
printf '%s\n' $'claude-endolin1\tendolin-garden-ece02cb4\tmonk' $'codex-endolin\tendolin-garden-ece02cb4\tcleric' \
  > "$J/config/subscription-mapping"
# Friday 20:00 PT = 03:00Z: the window is 2026-09-26T03:00Z -> 2026-10-03T03:00Z.
printf '%s\n' '{"subscription_id":"claude-endolin1","event_type":"declared-schedule","cadence":"calendar","schedule_weekday":5,"schedule_time":"20:00","timezone":"America/Los_Angeles","reset_at_precision":"exact","reset_at":"2026-09-19T03:00:00Z"}' \
  > "$J/budget/reset-events/claude-endolin1.jsonl"
printf 'kriskowal\n' > "$J/maintainers/allowlist"
printf '%s\n' '{"subscription_id":"codex-endolin","event_type":"manual-reset","cadence":"manual","reset_at":"2026-09-27T05:00:00Z","reset_at_precision":"exact","recorded_at":"2026-09-27T05:00:00Z","timezone":"UTC"}' \
  > "$J/budget/reset-events/codex-endolin.jsonl"
MID=2026-09-29T15:00:00Z    # t = 0.5

row() { # <arc> <input-tokens>
  printf '{"ts":"2026-09-27T00:00:00Z","base":"x","host":"endolin-garden-ece02cb4","provider":"anthropic","input_tokens":%s%s}\n' \
    "$2" "${1:+,\"arc\":\"$1\"}" >> "$J/usage/fixture.jsonl"
}
job() { # <slice> <base> <arc> [gate]
  { printf -- '---\n'; [ -z "$3" ] || printf 'arc: %s\n' "$3"; [ -z "${4:-}" ] || printf 'gate: %s\n' "$4"
    printf 'posted_at: 2026-09-27T00:00:00Z\n---\nbody\n'; } > "$J/jobs/$1/$2.md"
}
road() { # <pinned-json> — arcs a b c g, pinned as given
  printf '{"schema":1,"lanes":{"primary":0.6,"secondary":0.4},"pinned":%s,"arcs":[{"arc":"g","summary":"gated"},{"arc":"a","summary":"A"},{"arc":"b","summary":"B"},{"arc":"c","summary":"C"}],"aliases":{"unallocated":null,"old-a":"a"}}\n' "$1" \
    > "$J/allocation/road.json"
}
pool() { budget_road "$J" claude-endolin1 | awk -F'\t' '$1 == "pool"'; }
arcrow() { budget_road "$J" claude-endolin1 | awk -F'\t' -v a="$1" '$1 == "arc" && $4 == a'; }
col() { cut -f"$1"; }
check() { # <label> <actual> <expected>
  local numre='^-?[0-9]+([.][0-9]+)?$'
  if { [[ "$2" =~ $numre && "$3" =~ $numre ]] && near "$2" "$3"; } || [ "$2" = "$3" ]; then ok "$1 ($2)"; else bad "$1: expected $3, got $2"; fi
}

# Spend: arc a 1e6 weighted (500k via the old-a alias), unarced 0; the maintainer 1e6.
row a 500000; row old-a 500000
job todo a1 a; job plan b1 b deferred; job plan g1 g go-ahead; job plan c1 c blocked
road '["a"]'
export GARDEN_USAGE_NOW="$(at "$MID")" GARDEN_ROAD_U=0.20 GARDEN_ROAD_W_KRIS=1000000

echo "== formulas at t=0.5, u=0.20, W_fleet=W_kris=1e6 (P=1e7) =="
p="$(pool)"
check "t" "$(col 3 <<<"$p")" 0.5
check "P is calibrated from the current week" "$(col 5 <<<"$p")" 10000000
check "P provenance" "$(col 6 <<<"$p")" current
check "kris_u = u - fleet_u" "$(col 7 <<<"$p")" 0.1
check "maintainer reserve R_k = k(1-t) - kris_u" "$(col 8 <<<"$p")" 0.15
check "lane reservations: 0.24*0.5-0.1 + 0.16*0.5" "$(col 9 <<<"$p")" 0.10
check "discretion D = c - u - R_k - sum R_l" "$(col 10 <<<"$p")" 0.45
check "verdict" "$(col 11 <<<"$p")" ok
check "D at reset = c - u" "$(col 13 <<<"$p")" 0.70
check "aliased spend folds into a" "$(arcrow a | col 7)" 0.1
check "a holds the primary lane" "$(arcrow a | col 5)" primary
check "a's reservation" "$(arcrow a | col 8)" 0.02
check "a is admitted on reservation" "$(arcrow a | col 9)" reserved
check "go-ahead-only g cedes its lane" "$(arcrow g | col 5)" -
check "b, next with deferred work, holds the secondary lane" "$(arcrow b | col 5)" secondary
check "blocked-only c holds no lane" "$(arcrow c | col 5)" -
check "c draws on discretion" "$(arcrow c | col 9)" discretion
check "the pinned arc ranks first" "$(arcrow a | col 3)" 1

echo "== holder change mid-week =="
road '["b","a"]'
check "b now holds primary" "$(arcrow b | col 5)" primary
check "b's reservation is 0.24*0.5 minus its own (zero) spend" "$(arcrow b | col 8)" 0.12
check "a takes its spend to secondary" "$(arcrow a | col 8)" 0.0
check "a past its reservation draws on discretion" "$(arcrow a | col 9)" discretion
road '["a"]'

echo "== the maintainer's reserve holds the fleet =="
p="$(GARDEN_ROAD_W_KRIS=0 GARDEN_ROAD_U=0.70 pool)"
check "u >= c - R_k with lane reservation left is backoff/reserve" "$(col 11,12 <<<"$p")" $'backoff\treserve'
rm -f "$J/jobs/todo/a1.md" "$J/jobs/plan/b1.md"
p="$(GARDEN_ROAD_W_KRIS=0 GARDEN_ROAD_U=0.70 pool)"
check "with nothing reserved it is backoff/spent" "$(col 11,12 <<<"$p")" $'backoff\tspent'
job todo a1 a; job plan b1 b deferred

echo "== the 0.90 ceiling =="
END=2026-10-03T02:59:59Z
p="$(GARDEN_USAGE_NOW="$(at "$END")" GARDEN_ROAD_U=0.90 pool)"
check "u = 0.90 with R_k = 0 at reset is backoff/ceiling" "$(col 11,12 <<<"$p")" $'backoff\tceiling'
p="$(GARDEN_USAGE_NOW="$(at "$END")" GARDEN_ROAD_U=0.89 pool)"
check "just below the ceiling at reset admits" "$(col 11 <<<"$p")" ok
printf '0.95\n' > "$J/config/token-backoff-fraction"
p="$(GARDEN_USAGE_NOW="$(at "$END")" GARDEN_ROAD_U=0.90 pool)"
check "a pin above 0.90 does not lift the ceiling" "$(col 11 <<<"$p")" backoff
printf '0.15\n' > "$J/config/token-backoff-fraction"
p="$(pool)"
check "a pin overrides ok" "$(col 11,12 <<<"$p")" $'backoff\tpin'
rm -f "$J/config/token-backoff-fraction"

echo "== sensors =="
p="$(GARDEN_ROAD_U=- pool)"
check "no u sample is unknown" "$(col 11 <<<"$p")" unknown
rm -rf "$GARDEN_STATE/budget/road"
p="$(GARDEN_ROAD_U=0.05 pool)"
check "P unknown below u=0.10 with no last week" "$(col 5 <<<"$p")" -
check "P unknown keeps R_k whole" "$(col 8 <<<"$p")" 0.25
check "P unknown: arcs open below the ceiling" "$(col 11 <<<"$p")" ok

echo "== meter_quota_status (claim gate) =="
check "armed: the road verdict reaches meter_quota_status" "$(GARDEN_ROAD_U=0.70 GARDEN_ROAD_W_KRIS=0 meter_quota_status claude-endolin1 "$J")" backoff
check "armed: ok under the bound" "$(meter_quota_status claude-endolin1 "$J")" ok
mkdir -p "$J/budget/live/codex-endolin"
printf 'sampled_at_epoch: %s\nused_percent: 91\n' "$(at "$MID")" > "$J/budget/live/codex-endolin/h"
check "codex-endolin stays flat, its 95 capped at 90" "$(meter_quota_status codex-endolin "$J")" backoff
printf 'sampled_at_epoch: %s\nused_percent: 89\n' "$(at "$MID")" > "$J/budget/live/codex-endolin/h"
check "codex-endolin below 90 admits" "$(meter_quota_status codex-endolin "$J")" ok
mv "$J/allocation/road.json" "$TEST_ROOT/road.json"
mkdir -p "$J/budget/manual-checkpoints"
printf '{"checked_at":"%s","weekly_percent":80}\n' "$MID" > "$J/budget/manual-checkpoints/claude-endolin1.jsonl"
check "dormant: no road.json and no maintainer-reserve, the ramp decides (0.80 >= 0.75)" \
  "$(meter_quota_status claude-endolin1 "$J")" backoff
rm -f "$J/budget/manual-checkpoints/claude-endolin1.jsonl"
printf '0.50\n' > "$J/config/maintainer-reserve"
p="$(pool)"
check "maintainer-reserve alone arms R_k with no lanes" "$(col 9 <<<"$p")" 0.0
check "no road: no arc holds a lane" "$(arcrow a | col 5)" -
rm -f "$J/config/maintainer-reserve"; mv "$TEST_ROOT/road.json" "$J/allocation/road.json"

echo "== promotion order: lane groups, then road rank =="
job plan c2 c deferred; job plan z1 '' deferred; job plan a2 a deferred
order="$(GARDEN_CNF_TRIPLE=/nonexistent plan_deferred_ranked_omega "$J" | cut -f2 | paste -sd' ')"
check "reserved holders first (a, b), then discretion by road rank (c), then unarced" "$order" "a2 b1 c2 z1"
skips="$(GARDEN_ROAD_U=0.70 GARDEN_ROAD_W_KRIS=0 plan_deferred_skipped "$J" | sort | paste -sd' ')"
check "every arc is held at the reserve bound" "$skips" "a2	arc-held:a b1	arc-held:b c2	arc-held:c z1	arc-held:-"
rm -f "$J/jobs/plan/c2.md" "$J/jobs/plan/z1.md" "$J/jobs/plan/a2.md"

echo "== accountant statement =="
stmt="$(GARDEN_USAGE_NOW="$(at "$MID")" "$JOBS/accountant-statement.sh" --dir "$J" --now-epoch "$(at "$MID")" 2>&1)" || bad "statement failed: $stmt"
grep -q '^- claude-endolin1: primary a' <<<"$stmt" && ok "the statement names the lane holders" || bad "statement lanes: $stmt"
grep -q 'g: (no planned work); gated: 1 go-ahead' <<<"$stmt" && ok "the statement says what gates a no-work arc" || bad "statement gates: $stmt"

echo "== set-road.sh =="
SR() { GARDEN_ROAD_CLONE="$J" GARDEN_ROAD_NO_SYNC=1 "$JOBS/set-road.sh" "$@"; }
if out="$(SR focus c --authorized-by mallory --dry-run 2>&1)"; then bad "an unlisted login was accepted"; else ok "writer verbs need a maintainers/allowlist login"; fi
out="$(SR focus c --authorized-by kriskowal --dry-run 2>&1)" || bad "focus dry run failed: $out"
grep -q '"c",' <<<"$out" && grep -A2 '"pinned"' <<<"$out" | grep -q '"c"' && ok "focus draws c to the head of the pinned list" || bad "focus: $out"
if SR lanes 0.7 0.4 --authorized-by kriskowal --dry-run >/dev/null 2>&1; then bad "lanes not summing to 1 accepted"; else ok "lanes must sum to 1"; fi

exit "$fail"
