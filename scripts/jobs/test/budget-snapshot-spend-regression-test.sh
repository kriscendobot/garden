#!/bin/bash
# budget-snapshot-spend-regression-test.sh — a live budget reading below the last
# published spend for the same window is re-measured once, and the published
# high-water spend is held unless an entitlement transition is identified.
# Regression for oros-studio 2026-10-21 18:32Z, which published 20.3M between
# 33.4M and 35.0M (and 0 at 2026-10-20 21:03Z), and for endolin 2026-10-26
# 03:47:34Z, where a low re-measure let 47944967 regress to 47922983.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-budget-spend-regression.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

export GARDEN_TEST=1
export GARDEN=testhost
export GARDEN_STATE="$TR/state"
GARDEN_USAGE_NOW="$(date -u -d 2026-08-22T12:00:00Z +%s)"
export GARDEN_USAGE_NOW
export GARDEN_BUDGET_PUBLISH_ATTEMPTS=1
export GARDEN_BUDGET_PUBLISH_RESYNC_SECS=3600
export GARDEN_NO_MAINTAINER_ALERT=1
export GARDEN_BUDGET_SNAPSHOT_STAGGER_SECS=0

# shellcheck source=../common.sh
source "$JOBS/common.sh"

D="$TR/journal"; SCANS="$TR/scans"; SNAP="$D/budget/live/claude-x/testhost"
mkdir -p "$D/config" "$D/budget/live/claude-x"
printf 'claude-x\ttesthost\tmonk\n' > "$D/config/subscription-mapping"
: > "$D/config/budget-pools"
fail() { echo "FAIL: $*"; cat "$SNAP" 2>/dev/null || true; exit 1; }

budget_pool_file() { printf '%s\n' "$D/config/budget-pools"; }
budget_pool_row() { printf 'claude-x\tanthropic\tweekly-tokens\t1000\tfit\tnow\n'; }
subscription_window_start_epoch() { printf '%s\n' 1755820800; }
subscription_used_percent() { printf '%s\n' 40; }
# Each scan prints the next reading from READINGS (space-separated).
meter_subscription_window_total() {
  local n; n="$(cat "$SCANS" 2>/dev/null || echo 0)"; n=$((n + 1)); echo "$n" > "$SCANS"
  set -- $READINGS; shift $((n - 1)); printf '%s\n' "$1"
}
# ENTITLEMENT is the effective cutoff the meter would detect; default: none.
ENTITLEMENT=1755820800
_meter_entitlement_cutoff() { printf '%s\n' "$ENTITLEMENT"; }
sync_clone() { :; }
commit_and_push() { return 0; }
git() { :; }

seed() {  # seed <window> <spend> [sampled-at] — a published snapshot from an earlier bucket
  printf 'window_start_epoch: %s\nspend: %s\nsample_bucket: 1\nstatus: ok\n' "$1" "$2" > "$SNAP"
  [ -z "${3:-}" ] || printf 'sampled_at_epoch: %s\n' "$3" >> "$SNAP"
  : > "$SCANS"; ENTITLEMENT=1755820800
}
published() { sed -n 's/^spend:[[:space:]]*//p' "$SNAP"; }

# 1. A transient undercount is re-measured and the recovered reading published.
seed 1755820800 900; READINGS="600 950"
budget_publish_local_pool "$D" 2>/dev/null || fail "publication failed"
[ "$(published)" = 950 ] || fail "transient undercount published $(published), want 950"
[ "$(cat "$SCANS")" = 2 ] || fail "expected exactly one re-measure"
echo "PASS: a reading below the published spend is re-measured"

# 2. A re-measure that still reads low holds the published high-water spend.
seed 1755820800 47944967 1755830000; READINGS="47900000 47922983"
budget_publish_local_pool "$D" 2>/dev/null || fail "publication failed"
[ "$(published)" = 47944967 ] || fail "confirmed undercount published $(published), want 47944967"
echo "PASS: a low re-measure without an entitlement transition holds the high-water spend"

# 2b. Two consecutive undercounting ticks both hold the floor.
seed 1755820800 900; READINGS="600 650"
budget_publish_local_pool "$D" 2>/dev/null || fail "publication failed"
[ "$(published)" = 900 ] || fail "first undercount published $(published), want 900"
sed -i 's/^sample_bucket:.*/sample_bucket: 2/' "$SNAP"; : > "$SCANS"; READINGS="700 720"
budget_publish_local_pool "$D" 2>/dev/null || fail "publication failed"
[ "$(published)" = 900 ] || fail "second undercount published $(published), want 900"
[ "$(cat "$SCANS")" = 2 ] || fail "second undercount did not re-measure once"
echo "PASS: two consecutive undercounts keep the high-water spend"

# 2c. An entitlement boundary after the published sample lets a drop publish.
seed 1755820800 900 1755830000; ENTITLEMENT=1755840000; READINGS="300 200"
budget_publish_local_pool "$D" 2>/dev/null || fail "publication failed"
[ "$(published)" = 300 ] || fail "entitlement drop published $(published), want 300"
echo "PASS: a drop across an identified entitlement transition still publishes"

# 2d. A boundary the published sample already counted from does not excuse a drop.
seed 1755820800 900 1755850000; ENTITLEMENT=1755840000; READINGS="300 200"
budget_publish_local_pool "$D" 2>/dev/null || fail "publication failed"
[ "$(published)" = 900 ] || fail "pre-sample boundary published $(published), want 900"
echo "PASS: an entitlement boundary older than the published sample holds the floor"

# 3. A new window starts low without a re-measure.
seed 1755216000 900; READINGS="10 999"
budget_publish_local_pool "$D" 2>/dev/null || fail "publication failed"
[ "$(published)" = 10 ] || fail "new window published $(published), want 10"
[ "$(cat "$SCANS")" = 1 ] || fail "a new window re-measured"
echo "PASS: a new window is not compared with the old one"

# 4. A growing reading is published as-is with one scan.
seed 1755820800 900; READINGS="1000 1"
budget_publish_local_pool "$D" 2>/dev/null || fail "publication failed"
[ "$(published)" = 1000 ] || fail "growing reading published $(published), want 1000"
[ "$(cat "$SCANS")" = 1 ] || fail "a growing reading re-measured"
echo "PASS: a growing reading costs one scan"
