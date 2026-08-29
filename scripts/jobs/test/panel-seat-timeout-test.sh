#!/bin/bash
# panel-seat-timeout-test.sh - regression guard for bounded panel-seat attempts.
#
# A seat that hangs must time out below the enclosing handler budget, retain its
# stderr, and retry. Exhausting timed-out attempts must fail with a timeout class
# rather than the older empty-verdict class.
# Deliberate A && pass || fail test-reporting idiom; ok never fails.
# shellcheck disable=SC2015
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PANEL="$(cd "$HERE/../gardening" && pwd)/panel.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/panel-seat-timeout.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
trap 'rm -rf "$TR"' EXIT

run_panel() { # run_panel <succeed-at> <rundir> <counter> [seat-timeout] [handler-budget]
  SEAT_SUCCEED_AT="$1" SEAT_COUNTER="$3" SEAT_HANG_SECONDS=30 \
  GARDEN_CODE_SEATS=typist \
  GARDEN_PANEL_SEAT="$HERE/panel-seat-timeout-stub.sh" \
  GARDEN_PANEL_DECIDE="$HERE/panel-decide-stub.sh" \
  GARDEN_PANEL_APPELLATE=: GARDEN_PANEL_UNDRAFT=true GARDEN_PANEL_RECORD=: \
  GARDEN_PANEL_SEAT_ATTEMPTS=2 GARDEN_PANEL_SEAT_BACKOFF=0 \
  GARDEN_PANEL_SEAT_TIMEOUT="${4:-1}" GARDEN_PANEL_SEAT_KILL_AFTER=1 \
  GARDEN_APPLIED_HANDLER_BUDGET="${5:-10}" GARDEN_PANEL_RUNDIR="$2" \
    bash "$PANEL" "$TR/wt" 999 HEAD~1
}
mkdir -p "$TR/wt"

ctr1="$TR/ctr1"; : > "$ctr1"
out1="$(run_panel 2 "$TR/rd1" "$ctr1" 2>&1)"; rc1=$?
[ "$rc1" -eq 0 ] && ok "a timed-out first attempt retries and recovers" \
  || bad "recovering seat exited $rc1: $out1"
[ "$(cat "$ctr1")" = 2 ] && ok "the timed-out seat ran exactly twice" \
  || bad "recovering seat ran $(cat "$ctr1") times"
grep -q 'seat stderr attempt 1' "$TR/rd1/round-1.typist.md.stderr" \
  && ok "stderr from the timed-out attempt was preserved" \
  || bad "timed-out attempt stderr was lost"
grep -q 'Verdict: approve' "$TR/rd1/round-1.md" \
  && ok "the retry verdict reached the aggregate" \
  || bad "the retry verdict did not reach the aggregate"

ctr2="$TR/ctr2"; : > "$ctr2"
out2="$(run_panel 999999 "$TR/rd2" "$ctr2" 2>&1)"; rc2=$?
[ "$rc2" -ne 0 ] && ok "an always-hung seat fails the panel" \
  || bad "always-hung seat passed"
printf '%s' "$out2" | grep -q 'timed out after 1s on its final attempt; 2 attempts exhausted' \
  && ok "exhaustion is classified deterministically as timeout" \
  || bad "timeout classification missing: $out2"
[ "$(cat "$TR/rd2/round-1.typist.md.status")" = timeout ] \
  && ok "the seat status records timeout" \
  || bad "seat status is not timeout"
grep -q 'seat stderr attempt 1' "$TR/rd2/round-1.typist.md.stderr" \
  && grep -q 'seat stderr attempt 2' "$TR/rd2/round-1.typist.md.stderr" \
  && ok "stderr from every timed-out attempt was preserved" \
  || bad "one or more timed-out attempt stderr records were lost"

ctr3="$TR/ctr3"; : > "$ctr3"
out3="$(run_panel 999999 "$TR/rd3" "$ctr3" 9 3 2>&1)"; rc3=$?
[ "$rc3" -ne 0 ] && printf '%s' "$out3" | grep -q 'timed out after 1s' \
  && ok "an over-large seat timeout is clamped below the applied handler budget" \
  || bad "seat timeout was not clamped below the handler budget: $out3"

echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
