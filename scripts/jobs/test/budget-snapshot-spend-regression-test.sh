#!/bin/bash
# budget-snapshot-spend-regression-test.sh — a live budget reading below the last
# published spend for the same window is re-measured once, and the larger reading
# is published. Regression for oros-studio 2026-10-21 18:32Z, which published
# 20.3M between 33.4M and 35.0M (and 0 at 2026-10-20 21:03Z): one-tick
# undercounts of a total that only grows within a window.
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
sync_clone() { :; }
commit_and_push() { return 0; }
git() { :; }

seed() {  # seed <window> <spend> — a published snapshot from an earlier bucket
  printf 'window_start_epoch: %s\nspend: %s\nsample_bucket: 1\nstatus: ok\n' "$1" "$2" > "$SNAP"
  : > "$SCANS"
}
published() { sed -n 's/^spend:[[:space:]]*//p' "$SNAP"; }

# 1. A transient undercount is re-measured and the recovered reading published.
seed 1755820800 900; READINGS="600 950"
budget_publish_local_pool "$D" 2>/dev/null || fail "publication failed"
[ "$(published)" = 950 ] || fail "transient undercount published $(published), want 950"
[ "$(cat "$SCANS")" = 2 ] || fail "expected exactly one re-measure"
echo "PASS: a reading below the published spend is re-measured"

# 2. A genuine drop reads low twice and still publishes (the larger reading).
seed 1755820800 900; READINGS="300 200"
budget_publish_local_pool "$D" 2>/dev/null || fail "publication failed"
[ "$(published)" = 300 ] || fail "genuine drop published $(published), want 300"
echo "PASS: a drop confirmed by the re-measure still publishes"

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
