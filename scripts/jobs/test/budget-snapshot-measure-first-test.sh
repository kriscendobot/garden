#!/bin/bash
# budget-snapshot-measure-first-test.sh — the live budget publisher measures before
# it publishes. A tick with no snapshot due runs no session-log scan; a slow scan
# re-syncs the journal clone before the first push, so the push CAS window spans
# only write+commit+push; and a lost CAS retries without re-scanning. Regression
# for oros-studio 2026-10-01 18:20-20:08Z, where a ~40s scan sat between sync and
# push and 21 consecutive scaler ticks lost every CAS attempt.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-budget-measure-first.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

export GARDEN_TEST=1
export GARDEN=testhost
export GARDEN_STATE="$TR/state"
GARDEN_USAGE_NOW="$(date -u -d 2026-08-22T12:00:00Z +%s)"
export GARDEN_USAGE_NOW
export GARDEN_BUDGET_PUBLISH_ATTEMPTS=3
export GARDEN_BACKOFF_BASE_MS=0
export GARDEN_BACKOFF_CAP_MS=0
export GARDEN_NO_MAINTAINER_ALERT=1
export GARDEN_BUDGET_SNAPSHOT_STAGGER_SECS=0

# shellcheck source=../common.sh
source "$JOBS/common.sh"

D="$TR/journal"; LOG="$TR/events"; PUSHES="$TR/pushes"
mkdir -p "$D/config"
printf 'claude-x\ttesthost\tmonk\n' > "$D/config/subscription-mapping"
: > "$D/config/budget-pools"
fail() { echo "FAIL: $*"; echo "--- events"; cat "$LOG"; exit 1; }

budget_pool_file() { printf '%s\n' "$D/config/budget-pools"; }
budget_pool_row() { printf 'claude-x\tanthropic\tweekly-tokens\t1000\tfit\tnow\n'; }
subscription_window_start_epoch() { printf '%s\n' 1755820800; }
meter_subscription_window_total() { echo scan >> "$LOG"; printf '%s\n' 400; }
subscription_used_percent() { printf '%s\n' 40; }
# sync_clone resets the clone to origin: a lost CAS discards the local snapshot.
sync_clone() { echo sync >> "$LOG"; rm -f "$1/budget/live/claude-x/testhost"; }
commit_and_push() {
  local n; n="$(cat "$PUSHES" 2>/dev/null || echo 0)"; n=$((n + 1)); echo "$n" > "$PUSHES"
  if [ "$n" -le "${LOSE_PUSHES:-0}" ]; then
    echo push-lost >> "$LOG"; GARDEN_COMMIT_PUSH_CLASS=cas; return 1
  fi
  echo push-ok >> "$LOG"; return 0
}
git() { :; }

# 1. Not due: this bucket is already published → no scan, no sync, no push.
mkdir -p "$D/budget/live/claude-x"
printf 'sample_bucket: %s\nsampled_at_epoch: %s\nstatus: ok\n' \
  "$((GARDEN_USAGE_NOW / 900))" "$GARDEN_USAGE_NOW" > "$D/budget/live/claude-x/testhost"
: > "$LOG"
budget_publish_local_pool "$D" || fail "not-due tick reported failure"
[ ! -s "$LOG" ] || fail "a not-due tick scanned, synced, or pushed"
echo "PASS: a tick with no snapshot due runs no session-log scan"

# 2. Due with a slow measurement (threshold 0): scan, re-sync, then push; a lost
#    CAS re-syncs and re-pushes from the memoized reading without re-scanning.
rm -f "$D/budget/live/claude-x/testhost"; : > "$LOG"; : > "$PUSHES"
LOSE_PUSHES=1 GARDEN_BUDGET_PUBLISH_RESYNC_SECS=0 budget_publish_local_pool "$D" \
  || fail "publication after one lost CAS failed"
[ "$(paste -sd' ' "$LOG")" = "scan sync push-lost sync push-ok" ] \
  || fail "expected 'scan sync push-lost sync push-ok', saw '$(paste -sd' ' "$LOG")'"
echo "PASS: slow measurement re-syncs before the push; a CAS retry reuses the reading"

# 3. Due with a fast measurement: no extra sync before the first push.
rm -f "$D/budget/live/claude-x/testhost"; : > "$LOG"; : > "$PUSHES"
GARDEN_BUDGET_PUBLISH_RESYNC_SECS=3600 budget_publish_local_pool "$D" || fail "fast publication failed"
[ "$(paste -sd' ' "$LOG")" = "scan push-ok" ] \
  || fail "expected 'scan push-ok', saw '$(paste -sd' ' "$LOG")'"
echo "PASS: a fast measurement publishes on the already-synced tip"

# 4. A direct single attempt never reads a stale memo from an earlier call.
rm -f "$D/budget/live/claude-x/testhost"; : > "$LOG"; : > "$PUSHES"
_budget_publish_local_pool_once "$D" || fail "direct attempt failed"
[ "$(grep -c scan "$LOG")" -eq 1 ] || fail "direct attempt reused a memoized reading"
echo "PASS: the measurement memo is scoped to one publish call"
