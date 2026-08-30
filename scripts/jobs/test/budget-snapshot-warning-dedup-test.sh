#!/bin/bash
# budget-snapshot-warning-dedup-test.sh — live snapshot publication failures are
# one edge-triggered incident, followed by one recovery summary.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-budget-publish-latch.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

export GARDEN_TEST=1
export GARDEN_STATE="$TR/state"
export GARDEN_BUDGET_PUBLISH_OUTAGE_LATCH="$TR/state/publish-outage"
# shellcheck source=../common.sh
source "$JOBS/common.sh"

LOG="$TR/log"
log() { printf '%s\n' "$*" >> "$LOG"; }

budget_publish_note_failure
budget_publish_note_failure
budget_publish_note_failure

[ "$(grep -c '^WARN: could not publish live budget snapshot' "$LOG")" -eq 1 ] \
  || { echo "FAIL: repeated publication failures did not collapse to one WARN"; cat "$LOG"; exit 1; }
[ "$(cat "$GARDEN_BUDGET_PUBLISH_OUTAGE_LATCH/failures")" -eq 3 ] \
  || { echo "FAIL: outage latch did not count all failed ticks"; exit 1; }

budget_publish_note_success
grep -q 'publication recovered after 3 failed scaler tick(s)' "$LOG" \
  || { echo "FAIL: recovery summary did not report the suppressed failures"; cat "$LOG"; exit 1; }
[ ! -e "$GARDEN_BUDGET_PUBLISH_OUTAGE_LATCH" ] \
  || { echo "FAIL: recovery did not clear the outage latch"; exit 1; }

# Recovery re-arms the edge: a later, distinct outage gets its own first WARN.
budget_publish_note_failure
[ "$(grep -c '^WARN: could not publish live budget snapshot' "$LOG")" -eq 2 ] \
  || { echo "FAIL: a later outage did not emit a fresh first WARN"; cat "$LOG"; exit 1; }

echo "PASS: snapshot publication outage warns once, suppresses repeats, and summarizes recovery"
