#!/bin/bash
# cost-sh-test.sh — the read side of the cost ledger (scripts/jobs/cost.sh). Builds a
# fixed usage/ tree plus a few tada reports and asserts the aggregation, the per-host
# (per-account) split, the --since filter, --json, and — the headline — the honest
# COVERAGE line (metered bases / completed jobs, plus unpriced/unmetered counts).
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"; ROOT="$(cd "$JOBS/../.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_)' || true) 2>/dev/null || true
export GARDEN_TEST=1 GARDEN_ROOT="$ROOT" GARDEN_NO_MAINTAINER_ALERT=1
command -v jq >/dev/null 2>&1 || { echo "cost-sh-test: jq absent, skipping"; exit 0; }

TR="$(mktemp -d "${TMPDIR:-/tmp}/cost-sh.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
D="$TR/journal"; mkdir -p "$D/usage" "$D/jobs/tada"
# Five completed jobs across both layouts (coverage denominator); three carry a ledger.
for b in j1 j2 j3 j4; do printf 'done\n' > "$D/jobs/tada/$b.md"; done
mkdir -p "$D/jobs/tada/2026/08/13"
printf 'done\n' > "$D/jobs/tada/2026/08/13/j5.md"
# j1: two priced engagements on host A (role builder, opus).
printf '%s\n' \
  '{"ts":"2026-08-01T10:00:00Z","base":"j1","host":"hostA","role":"builder","model":"claude-opus-4-8","source":"result","outcome":"requeue","elapsed_s":100,"input_tokens":1000,"output_tokens":200,"cache_creation_tokens":50,"cache_read_tokens":10,"total_cost_usd":1.00}' \
  '{"ts":"2026-08-02T10:00:00Z","base":"j1","host":"hostA","role":"builder","model":"claude-opus-4-8","source":"result","outcome":"tada","elapsed_s":200,"input_tokens":2000,"output_tokens":400,"cache_creation_tokens":50,"cache_read_tokens":10,"total_cost_usd":2.00}' \
  > "$D/usage/j1.jsonl"
# j2: one priced engagement on host B (role fixer).
printf '%s\n' \
  '{"ts":"2026-08-02T11:00:00Z","base":"j2","host":"hostB","role":"fixer","model":"claude-fable-5","source":"result","outcome":"tada","elapsed_s":300,"input_tokens":500,"output_tokens":100,"total_cost_usd":0.50}' \
  > "$D/usage/j2.jsonl"
# j3: one UNPRICED, UNMETERED engagement (source none) on host B.
printf '%s\n' \
  '{"ts":"2026-08-02T12:00:00Z","base":"j3","host":"hostB","source":"none","outcome":"tada","elapsed_s":5}' \
  > "$D/usage/j3.jsonl"

run() { GARDEN_STATE="$TR/nostate" bash "$JOBS/cost.sh" "$@" --dir "$D"; }

# --- coverage: 3 metered bases of 5 completed jobs = 60% ---------------------
cov="$(run --by job | grep '^Coverage:')"
echo "$cov" | grep -q '3 of 5 completed jobs metered (60.0%)' \
  && ok "coverage line: 3 of 5 completed jobs metered (60.0%)" || bad "coverage wrong: $cov"
echo "$cov" | grep -q '1 engagement(s) unpriced' && ok "coverage flags 1 unpriced engagement" || bad "unpriced count wrong: $cov"
echo "$cov" | grep -q '1 unmetered' && ok "coverage flags 1 unmetered engagement" || bad "unmetered count wrong: $cov"

# --- totals via --json -------------------------------------------------------
tj="$(run --by job --json)"
[ "$(jq -r '.totals.eng' <<<"$tj")" = 4 ] && ok "total engagements = 4 (2+1+1)" || bad "total eng wrong ($(jq -r '.totals.eng' <<<"$tj"))"
awk -v c="$(jq -r '.totals.cost' <<<"$tj")" 'BEGIN{exit !(c>3.49 && c<3.51)}' \
  && ok "total cost = \$3.50 (1+2+0.5)" || bad "total cost wrong ($(jq -r '.totals.cost' <<<"$tj"))"
[ "$(jq -r '.coverage.metered_bases' <<<"$tj")" = 3 ] && [ "$(jq -r '.coverage.completed_jobs' <<<"$tj")" = 5 ] \
  && ok "--json coverage block: metered_bases=3 completed_jobs=5" || bad "json coverage wrong"
# j1 folds its two engagements into one group of $3.00, and sorts first (most $).
[ "$(jq -r '.groups[0].k' <<<"$tj")" = j1 ] && awk -v c="$(jq -r '.groups[0].cost' <<<"$tj")" 'BEGIN{exit !(c>2.99 && c<3.01)}' \
  && ok "job j1 folds 2 engagements to \$3.00 and ranks first (sorted by dollars desc)" || bad "j1 fold/sort wrong"

# --- the per-host (per-account) split ---------------------------------------
hj="$(run --by host --json)"
ha="$(jq -r '.groups[] | select(.k=="hostA") | .cost' <<<"$hj")"
hb="$(jq -r '.groups[] | select(.k=="hostB") | .cost' <<<"$hj")"
awk -v a="$ha" 'BEGIN{exit !(a>2.99 && a<3.01)}' && ok "host split: hostA = \$3.00 (account A)" || bad "hostA cost wrong ($ha)"
awk -v b="$hb" 'BEGIN{exit !(b>0.49 && b<0.51)}' && ok "host split: hostB = \$0.50 (account B)" || bad "hostB cost wrong ($hb)"

# --- --since lexicographic filter -------------------------------------------
sj="$(run --by job --since 2026-08-02 --json)"
# j1's Aug-1 row drops; only Aug-2 rows remain: j1($2)+j2($0.5)+j3($0) = $2.50 over 3 eng.
[ "$(jq -r '.totals.eng' <<<"$sj")" = 3 ] && awk -v c="$(jq -r '.totals.cost' <<<"$sj")" 'BEGIN{exit !(c>2.49 && c<2.51)}' \
  && ok "--since 2026-08-02 drops the Aug-1 engagement (eng=3 cost=\$2.50)" || bad "--since filter wrong (eng=$(jq -r '.totals.eng' <<<"$sj") cost=$(jq -r '.totals.cost' <<<"$sj"))"

# --- --job restricts to one base --------------------------------------------
jj="$(run --job j2 --json)"
[ "$(jq -r '.totals.eng' <<<"$jj")" = 1 ] && [ "$(jq -r '.groups[0].k' <<<"$jj")" = j2 ] \
  && ok "--job j2 restricts to that base's single engagement" || bad "--job filter wrong"

# --- empty ledger degrades gracefully ---------------------------------------
mkdir -p "$TR/empty/usage" "$TR/empty/jobs/tada"
printf 'x\n' > "$TR/empty/jobs/tada/only.md"
out="$(GARDEN_STATE="$TR/nostate" bash "$JOBS/cost.sh" --dir "$TR/empty" 2>&1)"
echo "$out" | grep -q '0 of 1 completed jobs metered' && ok "empty ledger: reports 0 of 1 metered, no crash" || bad "empty ledger handling wrong: $out"

echo "cost-sh-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
