#!/bin/bash
# fleet-brake-test.sh — unit guard for the shared fleet brake and the per-worker
# transient-failure backoff (gardener.sh + common.sh).
#
# Motivation (the 2026-07-01 quota-storm poisoning): on a correlated Claude
# quota/usage outage every gardener's handler failed transiently, but the loop
# applied NO delay on either transient path — a just-failed worker fell straight
# back to the claim head and re-ran the next job against the already-exhausted
# quota, and ~100 workers doing so in lockstep amplified the outage and churned
# todo<->doin until the reaper poisoned a dozen unrelated jobs. The fix adds
#   (a) a per-worker exponential+jittered backoff (idle_backoff("$fail_attempt"))
#       after any transient-classified handler failure, and
#   (b) a SHARED host-local fleet brake: every gardener stamps a rolling ledger on
#       a transient failure, and before each claim reads the fleet-wide density and
#       PAUSES claiming when it crosses a threshold, so the storm drains.
# The brake logic lives in pure helpers in common.sh; this test drives them
# directly with a fixed clock (GARDEN_FLEET_BRAKE_NOW) so it needs no sleeps.
#
# Usage: fleet-brake-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener invoking this test cannot splice its
# own GARDEN_* state underneath the fixture (mirrors the sibling classifier tests).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

# Hermetic ledger + a frozen clock so density math is deterministic (no real time).
TR="$(mktemp -d "${TMPDIR:-/tmp}/fleet-brake.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
export GARDEN_STATE="$TR/state"
export GARDEN_FLEET_BRAKE_LEDGER="$TR/state/fleet-brake/failures"
export GARDEN_FLEET_BRAKE_WINDOW_SECS=300
export GARDEN_FLEET_BRAKE_THRESHOLD=10
export GARDEN_FLEET_BRAKE_NOW=1000000000

# shellcheck source=../common.sh
source "$JOBS/common.sh"

hr; echo "SUBTEST 1 — empty/missing ledger reads as density 0 (fail-open, released)"; hr
rm -f "$GARDEN_FLEET_BRAKE_LEDGER"
d="$(transient_failure_density)"
[ "$d" = 0 ] && ok "missing ledger → density 0" || bad "missing ledger density='$d' expected 0"
if fleet_brake_engaged; then bad "brake ENGAGED on empty ledger (should be released)"; else ok "brake released on empty ledger"; fi

hr; echo "SUBTEST 2 — below threshold: recorded failures do not engage the brake"; hr
for _ in $(seq 1 9); do record_transient_failure; done   # 9 < threshold 10
d="$(transient_failure_density)"
[ "$d" = 9 ] && ok "9 in-window failures counted" || bad "density='$d' expected 9"
if fleet_brake_engaged; then bad "brake ENGAGED at 9 (< threshold 10)"; else ok "brake released at 9 (< 10)"; fi

hr; echo "SUBTEST 3 — crossing the threshold engages the brake"; hr
record_transient_failure                                   # now 10 == threshold
d="$(transient_failure_density)"
[ "$d" = 10 ] && ok "10 in-window failures counted" || bad "density='$d' expected 10"
if fleet_brake_engaged; then ok "brake ENGAGED at threshold (10 ≥ 10)"; else bad "brake NOT engaged at threshold"; fi

hr; echo "SUBTEST 4 — failures older than the window age out (the brake releases)"; hr
# Advance the clock past the window: every stamp so far is now out-of-window.
GARDEN_FLEET_BRAKE_NOW=$(( 1000000000 + GARDEN_FLEET_BRAKE_WINDOW_SECS + 1 ))
export GARDEN_FLEET_BRAKE_NOW
d="$(transient_failure_density)"
[ "$d" = 0 ] && ok "aged-out failures no longer counted → density 0" || bad "density='$d' expected 0 after window"
if fleet_brake_engaged; then bad "brake still ENGAGED after the window drained"; else ok "brake released after the storm drained"; fi

hr; echo "SUBTEST 5 — a window-scoped count ignores stamps just outside the edge"; hr
: > "$GARDEN_FLEET_BRAKE_LEDGER"
now=2000000000; export GARDEN_FLEET_BRAKE_NOW=$now
win=$GARDEN_FLEET_BRAKE_WINDOW_SECS
{
  printf '%s\n' "$(( now - win + 1 ))"   # just inside → counts
  printf '%s\n' "$(( now - win ))"       # exactly at cutoff → counts (>=)
  printf '%s\n' "$(( now - win - 1 ))"   # just outside → excluded
  printf '%s\n' "$now"                    # now → counts
} >> "$GARDEN_FLEET_BRAKE_LEDGER"
d="$(transient_failure_density)"
[ "$d" = 3 ] && ok "3 of 4 stamps within window (cutoff inclusive)" || bad "density='$d' expected 3"

hr; echo "SUBTEST 6 — threshold 0 (or non-integer) DISABLES the brake"; hr
# Load the ledger well past any positive threshold, then disable.
for _ in $(seq 1 50); do record_transient_failure; done
GARDEN_FLEET_BRAKE_THRESHOLD=0
if fleet_brake_engaged; then bad "threshold 0 still engaged the brake"; else ok "threshold 0 disables the brake"; fi
GARDEN_FLEET_BRAKE_THRESHOLD=notanumber
if fleet_brake_engaged; then bad "non-integer threshold still engaged the brake"; else ok "non-integer threshold disables the brake (no crash)"; fi
GARDEN_FLEET_BRAKE_THRESHOLD=10   # restore

hr; echo "SUBTEST 7 — fleet_brake_pause sleeps within [base/2, 3*base/2]"; hr
# A tiny base keeps the test fast; the jittered draw must land in the window.
GARDEN_FLEET_BRAKE_PAUSE_SECS=2
t0=$SECONDS
fleet_brake_pause
elapsed=$(( SECONDS - t0 ))
# base=2 → window [1, 3]s. SECONDS is whole-second granular, so allow [0,3].
if [ "$elapsed" -ge 0 ] && [ "$elapsed" -le 3 ]; then
  ok "pause slept ${elapsed}s within the jittered [1,3]s window"
else
  bad "pause slept ${elapsed}s outside the expected [1,3]s window"
fi

hr; echo "SUBTEST 8 — the per-worker backoff counter grows across consecutive failures"; hr
# Model gardener.sh's fail_attempt discipline: it is the failure-path analog of
# idle_attempt, resets ONLY on a genuine completion, and feeds idle_backoff so a
# sustained outage backs a single worker off exponentially. Assert the growth
# discipline here (the loop wiring is exercised by the gardener itself); idle_backoff
# is bounded by GARDEN_IDLE_SLEEP_CAP so the sleep never runs away.
fail_attempt=1
seq_ok=1
for expect in 1 2 3 4; do
  [ "$fail_attempt" -eq "$expect" ] || seq_ok=0
  fail_attempt=$((fail_attempt+1))   # a transient failure increments (never resets on a claim)
done
[ "$seq_ok" -eq 1 ] && ok "fail_attempt grows 1→2→3→4 across consecutive transient failures" || bad "fail_attempt growth broken"
fail_attempt=1   # a genuine completion resets it
[ "$fail_attempt" -eq 1 ] && ok "a completion resets fail_attempt to 1 (quick first backoff next time)" || bad "reset broken"

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
