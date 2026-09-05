#!/bin/bash
# Hermetic coverage for manual quota checkpoint ingestion, contiguous-run fitting,
# confidence grading and deliberate pool promotion.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
TEST_ROOT="$(mktemp -d "${TMPDIR:-/var/tmp}/garden-quota-calibration-test.XXXXXX")"
trap 'rm -rf "$TEST_ROOT"' EXIT
pass=0; fail=0
ok() { echo "PASS: $*"; pass=$((pass+1)); }
bad() { echo "FAIL: $*"; fail=$((fail+1)); }
git_id=(-c user.name=test -c user.email=test@example.invalid)

BARE="$TEST_ROOT/journal.git"
SEED="$TEST_ROOT/seed"
WORK="$TEST_ROOT/work"
git init -q --bare "$BARE"
git init -q "$SEED"
git -C "$SEED" checkout -q -b journal2
mkdir -p "$SEED"/budget/{live,manual-checkpoints,boost-events} "$SEED/config"
touch "$SEED/budget/boost-events/.gitkeep"
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -qm seed
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin journal2
git clone -q --single-branch --branch journal2 "$BARE" "$WORK"
git -C "$WORK" config user.name test
git -C "$WORK" config user.email test@example.invalid
mkdir -p "$WORK"/budget/{live,manual-checkpoints,boost-events} "$WORK/config"

export GARDEN_TEST=1 GARDEN=test-garden GARDEN_ROOT="$ROOT"
export GARDEN_STATE="$TEST_ROOT/state" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2
export GARDEN_PRODUCER_CLONE="$WORK" GARDEN_QUOTA_FIT_MIN_POINTS=3

commit_fixture() {
  git -C "$WORK" add -A
  git -C "$WORK" commit -qm fixture
  git -C "$WORK" push -q origin HEAD:journal2
}

write_live() {
  local host="$1" anchor="$2" spend="${3:-100}"
  printf 'status: ok\nspend: %s\nwindow_start_epoch: %s\nsampled_at: 2026-09-05T00:00:00Z\nsampled_at_epoch: 1788566400\n' \
    "$spend" "$anchor" > "$WORK/budget/live/$host"
}

checkpoint() {
  local checked_at="$1" anchor="$2" percent="$3" spend="$4" confidence="$5"
  jq -cn --arg checked_at "$checked_at" --argjson anchor "$anchor" \
    --argjson percent "$percent" --argjson spend "$spend" --arg confidence "$confidence" \
    '{checked_at:$checked_at,meter_window_start_epoch:$anchor,weekly_percent:$percent,meter_spend_tokens:$spend,pairing_confidence:$confidence}'
}

HOST=return-host
write_live "$HOST" 100
{
  checkpoint 2026-09-01T00:00:00Z 100 10 100 high
  checkpoint 2026-09-01T01:00:00Z 100 11 110 high
  checkpoint 2026-09-01T02:00:00Z 200 20 200 flagged
  checkpoint 2026-09-01T02:30:00Z 200 20 200 low
  checkpoint 2026-09-01T03:00:00Z 100 12 120 medium
  checkpoint 2026-09-01T04:00:00Z 100 13 130 medium
} > "$WORK/budget/manual-checkpoints/$HOST.jsonl"
commit_fixture
verdict="$($JOBS/fit-quota-calibration.sh "$HOST" --dry-run --json-only)"
if jq -e '
    .confidence == "insufficient" and
    ([.segments[].window_start_epoch] == [100,200,100]) and
    ([.segments[].n_points] == [2,1,2]) and
    ([.segments[].segment_id] == ["run-0-anchor-100","run-1-anchor-200","run-2-anchor-100"]) and
    .governing_segment.run_index == 0 and
    .governing_segment.first_checked_at == "2026-09-01T00:00:00Z" and
    .governing_segment.last_checked_at == "2026-09-01T01:00:00Z"
  ' <<<"$verdict" >/dev/null; then
  ok "A-B-A anchors become three auditable contiguous runs without pooling"
else
  bad "return-to-old-anchor verdict was $(jq -c . <<<"$verdict")"
fi

# Equal confidence weight chooses the more recent segment; within it, the freshest
# highest-confidence point governs. A flagged row is ignored.
HOST=selection-host
write_live "$HOST" 200
{
  checkpoint 2026-09-02T00:00:00Z 100 10 100 high
  checkpoint 2026-09-02T01:00:00Z 100 11 110 high
  checkpoint 2026-09-02T02:00:00Z 200 19 190 high
  checkpoint 2026-09-02T03:00:00Z 200 20 200 medium
  checkpoint 2026-09-02T04:00:00Z 200 21 210 low
  checkpoint 2026-09-02T05:00:00Z 200 99 999 flagged
} > "$WORK/budget/manual-checkpoints/$HOST.jsonl"
commit_fixture
verdict="$($JOBS/fit-quota-calibration.sh "$HOST" --dry-run --json-only)"
if jq -e '
    .confidence == "converged" and
    .governing_segment.run_index == 1 and
    .governing_segment.n_points == 3 and
    .governing_point.checked_at == "2026-09-02T02:00:00Z" and
    .selected_cap_tokens == 974
  ' <<<"$verdict" >/dev/null; then
  ok "grading and confidence-recency selection preserve the documented behavior"
else
  bad "selection verdict was $(jq -c . <<<"$verdict")"
fi

# Enough live-window points with a wide spread remain provisional. The fit must not
# touch the actuator configuration, even when it emits a recommendation.
HOST=provisional-host
write_live "$HOST" 300
printf '# unchanged actuator\n' > "$WORK/config/budget-pools"
{
  checkpoint 2026-09-03T00:00:00Z 300 10 100 high
  checkpoint 2026-09-03T01:00:00Z 300 10 150 high
  checkpoint 2026-09-03T02:00:00Z 300 10 200 high
} > "$WORK/budget/manual-checkpoints/$HOST.jsonl"
commit_fixture
config_before="$(git -C "$WORK" hash-object config/budget-pools)"
verdict="$($JOBS/fit-quota-calibration.sh "$HOST" --dry-run --json-only)"
config_after="$(git -C "$WORK" hash-object config/budget-pools)"
if jq -e '.confidence == "provisional" and .checks.enough_points and (.checks.spread_within_tolerance | not)' <<<"$verdict" >/dev/null \
   && [ "$config_before" = "$config_after" ]; then
  ok "wide-spread fit is provisional and the measure path leaves pool config untouched"
else
  bad "provisional/measure boundary failed: $(jq -c . <<<"$verdict")"
fi

# The ingestion path remains active for an unmetered pool and records its live
# pairing. A later anchor change is called out on the appended row.
HOST=unmetered-host
"$JOBS/set-budget-pool.sh" "anthropic:$HOST" - temporary-key 2026-09-05 --kind unmetered >/dev/null 2>&1
LIVE_FILE="$TEST_ROOT/live"
printf 'status: ok\nspend: 280\nwindow_start_epoch: 400\nsampled_at: 2026-09-05T00:00:00Z\nsampled_at_epoch: 1788566400\n' > "$LIVE_FILE"
"$JOBS/append-quota-checkpoint.sh" "$HOST" 28 --checked-at 2026-09-05T00:05:00Z --host-file "$LIVE_FILE" >/dev/null 2>&1
printf 'status: ok\nspend: 290\nwindow_start_epoch: 500\nsampled_at: 2026-09-05T00:10:00Z\nsampled_at_epoch: 1788567000\n' > "$LIVE_FILE"
"$JOBS/append-quota-checkpoint.sh" "$HOST" 29 --checked-at 2026-09-05T00:15:00Z --host-file "$LIVE_FILE" >/dev/null 2>&1
git -C "$WORK" fetch -q origin journal2
git -C "$WORK" reset -q --hard origin/journal2
if jq -se '
    length == 2 and .[0].meter_spend_tokens == 280 and
    .[0].pairing_confidence == "medium" and
    .[1].meter_window_start_epoch == 500 and
    (.[1].notes | contains("WINDOW ANCHOR CHANGED"))
  ' "$WORK/budget/manual-checkpoints/$HOST.jsonl" >/dev/null \
   && awk '$1 == "anthropic:unmetered-host" { found=($4 == "unmetered" && $5 == "-") } END { exit !found }' "$WORK/config/budget-pools"; then
  ok "unmetered pool still accepts historical checkpoints without implicit actuation"
else
  bad "unmetered ingestion or pool configuration was incorrect"
fi

# Promotion remains an explicit setter action with complete provenance.
"$JOBS/set-budget-pool.sh" "anthropic:$HOST" 1000 manual-fit 2026-09-05 >/dev/null 2>&1
git -C "$WORK" fetch -q origin journal2
git -C "$WORK" reset -q --hard origin/journal2
if awk '$1 == "anthropic:unmetered-host" { found=($4 == "weekly-tokens" && $5 == 1000 && $6 == "manual-fit" && $7 == "2026-09-05") } END { exit !found }' "$WORK/config/budget-pools"; then
  ok "deliberate setter is the sole tested promotion path and records provenance"
else
  bad "explicit promotion row was incorrect"
fi

set +e
"$JOBS/set-budget-pool.sh" "anthropic:$HOST" provisional manual-fit >/dev/null 2>&1
invalid_rc=$?
set -e
[ "$invalid_rc" -eq 2 ] && ok "setter rejects a nonnumeric weekly-token ceiling" \
  || bad "setter accepted an invalid weekly-token ceiling (rc=$invalid_rc)"

echo "quota-calibration-test: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
