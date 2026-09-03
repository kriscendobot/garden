#!/bin/bash
# Hermetic coverage for weekly-capacity-calibration.sh: the closed-week fold, the
# (host,anchor) upsert, max-over-trailing-N per account, the summed token bucket,
# per-anchor idempotency, and the optional notional-to-real index.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-weekly-cal-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
pass=0; fail=0
ok() { echo "PASS: $*"; pass=$((pass+1)); }
bad() { echo "FAIL: $*"; fail=$((fail+1)); }
git_id=(-c user.name=test -c user.email=test@example.invalid)

# Resolve three consecutive weekly anchors through the same helper the script uses,
# so the fixtures land in the right closed weeks regardless of DST.
anchors="$(bash -c 'source "$1/common.sh"
  now="'"$(date -u -d 2026-08-29T12:00:00Z +%s)"'"
  w2="$(meter_week_anchor_epoch "$now")"
  w1="$(meter_week_anchor_epoch "$((w2-1))")"
  w0="$(meter_week_anchor_epoch "$((w1-1))")"
  printf "%s %s %s\n" "$w0" "$w1" "$w2"' _ "$JOBS")"
read -r W0 W1 W2 <<<"$anchors"
iso() { date -u -d "@$1" +%FT%TZ; }

BARE="$TR/journal.git"; SEED="$TR/seed"
git init -q --bare "$BARE"; git init -q "$SEED"; git -C "$SEED" checkout -q -b journal2
mkdir -p "$SEED"/{config,usage,budget}
touch "$SEED/usage/.gitkeep"
row() { # host ts-epoch input cost   -> a usage CostRecord line
  local host="$1" ts="$2" input="$3" cost="$4" extra=""
  [ "$cost" = - ] || extra=",\"total_cost_usd\":$cost"
  printf '{"host":"%s","provider":"anthropic","ts":"%s","input_tokens":%s,"output_tokens":0,"cache_creation_tokens":0%s}\n' \
    "$host" "$(iso "$ts")" "$input" "$extra" >> "$SEED/usage/ledger.jsonl"
}
# hostA: 2000 billable in the W0->W1 week; 1000+500 billable in the W1->W2 week
# (notional 46.15+46.15 = 92.30); one row BEFORE W0 (excluded) and one AT W2 (next
# week, excluded). hostB: 800 billable in the W1->W2 week, unpriced.
row hostA "$((W0-3600))"  9999 -
row hostA "$((W0+3600))"  2000 -
row hostA "$((W1+3600))"  1000 46.15
row hostA "$((W1+7200))"  500  46.15
row hostA "$((W2+3600))"  7777 -
row hostB "$((W1+3600))"  800  -
# hostA is a configured subscription (real weekly = 200*12/52 = 46.15); hostB is not.
printf 'hostA 200 max-a\n' > "$SEED/config/claude-subscriptions"
git -C "$SEED" add -A; git -C "$SEED" "${git_id[@]}" commit -qm seed
git -C "$SEED" remote add origin "$BARE"; git -C "$SEED" push -q -u origin journal2
view() { git --git-dir="$BARE" show "journal2:$1" 2>/dev/null; }

run_cal() { # now [args...]
  local now="$1"; shift
  env GARDEN_TEST=1 GARDEN=leader GARDEN_LEADER=leader GARDEN_STATE="$TR/state" JOURNAL_REMOTE="$BARE" \
    GARDEN_WEEKLY_CAL_NOW="$now" GARDEN_NO_MAINTAINER_ALERT=1 \
    "$JOBS/weekly-capacity-calibration.sh" "$@"
}

# --- Calibrate the W1 anchor (folds the W0->W1 week) -------------------------------
run_cal "$W1" >/dev/null 2>&1
a_w1="$(view budget/weekly-capacity/hostA.jsonl | jq -sr --arg a "$(iso "$W1")" '.[] | select(.anchor==$a) | .billable_tokens')"
[ "$a_w1" = 2000 ] && ok "W1 fold sums hostA's closed-week billable (2000)" || bad "W1 hostA billable was '$a_w1'"

# --- Calibrate the W2 anchor (folds the W1->W2 week) -------------------------------
run_cal "$W2" >/dev/null 2>&1
a_w2="$(view budget/weekly-capacity/hostA.jsonl | jq -sr --arg a "$(iso "$W2")" '.[] | select(.anchor==$a) | .billable_tokens')"
[ "$a_w2" = 1500 ] && ok "W2 fold sums hostA's two in-week rows (1500), excluding out-of-week rows" \
  || bad "W2 hostA billable was '$a_w2'"
b_w2="$(view budget/weekly-capacity/hostB.jsonl | jq -sr --arg a "$(iso "$W2")" '.[] | select(.anchor==$a) | .billable_tokens')"
[ "$b_w2" = 800 ] && ok "W2 fold records hostB (800)" || bad "W2 hostB billable was '$b_w2'"

a_index="$(view budget/weekly-capacity/hostA.jsonl | jq -sr --arg a "$(iso "$W2")" '.[] | select(.anchor==$a) | .notional_to_real_index')"
awk -v v="$a_index" 'BEGIN{exit !(v+0==2)}' && ok "notional_to_real_index computed for a configured account (92.30/46.15=2)" \
  || bad "hostA index was '$a_index'"
b_index="$(view budget/weekly-capacity/hostB.jsonl | jq -sr --arg a "$(iso "$W2")" '.[] | select(.anchor==$a) | (.notional_to_real_index // "omitted")')"
[ "$b_index" = omitted ] && ok "notional_to_real_index omitted for an unconfigured account" \
  || bad "hostB index should be omitted, was '$b_index'"

# --- The token bucket: capacity = sum of per-account max-over-N ---------------------
# hostA max over [2000@W1, 1500@W2] = 2000; hostB max = 800; capacity = 2800.
cap="$(view budget/bucket.json | jq -r '.capacity')"
[ "$cap" = 2800 ] && ok "bucket capacity = sum of per-account max-over-trailing-N (2000+800)" \
  || bad "bucket capacity was '$cap'"
paA="$(view budget/bucket.json | jq -r '.per_account_capacity.hostA')"
paB="$(view budget/bucket.json | jq -r '.per_account_capacity.hostB')"
[ "$paA" = 2000 ] && [ "$paB" = 800 ] && ok "per_account_capacity records each account's max (A=2000, B=800)" \
  || bad "per_account was A=$paA B=$paB"
refill="$(view budget/bucket.json | jq -r '.refilled_at')"
[ "$refill" = "$(iso "$W2")" ] && ok "bucket refilled_at is the W2 anchor" || bad "refilled_at was '$refill'"

# --- Idempotency: re-running the W2 anchor adds no record and returns no-work (2) ---
before="$(view budget/weekly-capacity/hostA.jsonl | wc -l)"
set +e
run_cal "$W2" scheduled >/dev/null 2>&1
rc=$?
set -e
after="$(view budget/weekly-capacity/hostA.jsonl | wc -l)"
[ "$rc" -eq 2 ] && [ "$before" = "$after" ] \
  && ok "re-running an already-calibrated anchor is an idempotent no-op (exit 2, no new record)" \
  || bad "idempotency: rc=$rc before=$before after=$after"

# --- A follower host does no calibration -------------------------------------------
set +e
fout="$(env GARDEN_TEST=1 GARDEN=follower GARDEN_LEADER=leader GARDEN_STATE="$TR/state-f" JOURNAL_REMOTE="$BARE" \
  GARDEN_WEEKLY_CAL_NOW="$W2" GARDEN_NO_MAINTAINER_ALERT=1 "$JOBS/weekly-capacity-calibration.sh" scheduled 2>&1)"
frc=$?
set -e
[ "$frc" -eq 2 ] && echo "$fout" | grep -q 'leader-only' \
  && ok "a follower host skips calibration (leader-only), preserving the scheduled exit contract" \
  || bad "follower calibration rc=$frc out=$fout"

echo "RESULT: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
