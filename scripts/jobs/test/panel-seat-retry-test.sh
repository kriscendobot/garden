#!/bin/bash
# panel-seat-retry-test.sh — regression guard for panel.sh's RETRY-ON-EMPTY seat
# fan-out (scripts/jobs/gardening/panel.sh).
#
# THE BUG (jammed the finbot merge gate for days, 2026-07-25..27): a jury seat's
# `claude -p` intermittently exits 0 with EMPTY stdout (rate-limit / overload /
# truncation). The old seat loop `seat_review > block || fail` handled only the
# NON-ZERO case; a 0-byte-but-exit-0 answer slipped through and was SILENTLY
# aggregated as an empty verdict the decider judged over — a seat with no signal
# diluting the disposition. Evidence: recurring 0-byte round-1.typist.md /
# round-1.prover.md under /tmp/garden-panel-finbot*/.
#
# THE FIX: an empty/blank seat block is a failure; retry with backoff; only fail
# LOUDLY (pointing at the captured .stderr) once the attempts are spent. An empty
# seat verdict is never legitimate signal and must never reach the aggregate.
#
# SUBTEST 1 — a seat that ALWAYS returns empty (exit 0) fails the panel loudly
#             after exactly GARDEN_PANEL_SEAT_ATTEMPTS tries; it NEVER un-drafts.
# SUBTEST 2 — a seat empty on tries 1..2 then non-empty on try 3 recovers: the
#             panel passes and the seat's real content reaches the aggregate.
# SUBTEST 3 — a seat non-empty on the first try passes with a single attempt
#             (no spurious retries on the healthy path).
#
# Hermetic: the seat review, the disposition decider, the appellate and the
# un-draft are all env-stubbed (GARDEN_PANEL_SEAT / _DECIDE / _APPELLATE /
# _UNDRAFT), so NO real `claude -p` and NO network. Backoff is zeroed so retries
# are instant.
#
# Usage: panel-seat-retry-test.sh

# The ok/bad idiom is the intended A && pass || fail (SC2015, safe: ok never
# fails). Deliberate.
# shellcheck disable=SC2015
set -uo pipefail
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PANEL="$(cd "$HERE/../gardening" && pwd)/panel.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/panel-seat-retry.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }
trap 'rm -rf "$TR"' EXIT

# The stubbed seat hook is a COMMITTED in-repo file (panel-seat-retry-stub.sh):
# it counts invocations in $SEAT_COUNTER and emits a verdict only once the count
# reaches $SEAT_SUCCEED_AT, else exits 0 empty. It lives in the repo (exec-ok)
# rather than in $TR because the test scratch (/tmp) is a noexec mount on some
# hosts, and panel.sh exec's the hook directly.
STUB_SEAT="$HERE/panel-seat-retry-stub.sh"
STUB_DECIDE="$HERE/panel-decide-stub.sh"   # prints `pass` (a single executable)

# Common env for a hermetic single-seat CODE panel: one seat, decider says pass,
# appellate skipped, un-draft a no-op, retries instant.
run_panel() {  # run_panel <succeed-at> <rundir> <counter>  -> panel.sh exit code + output
  SEAT_SUCCEED_AT="$1" SEAT_COUNTER="$3" \
  GARDEN_CODE_SEATS="typist" \
  GARDEN_PANEL_SEAT="$STUB_SEAT" \
  GARDEN_PANEL_DECIDE="$STUB_DECIDE" \
  GARDEN_PANEL_APPELLATE=":" \
  GARDEN_PANEL_UNDRAFT="true" \
  GARDEN_PANEL_SEAT_ATTEMPTS=3 \
  GARDEN_PANEL_SEAT_BACKOFF=0 \
  GARDEN_PANEL_RUNDIR="$2" \
    bash "$PANEL" "$TR/wt" 999 HEAD~1
}
# GARDEN_PANEL_DECIDE is called as `<cmd> <agg> <pr>`; the stub ignores the args
# and writes exactly `pass` (the decider contract: last non-blank token).
mkdir -p "$TR/wt"   # a non-git worktree → sense falls to the (broader) code panel

hr; echo "SUBTEST 1 — an always-empty seat fails the panel loudly, never un-drafts"; hr
rd1="$TR/rd1"; ctr1="$TR/ctr1"; : > "$ctr1"
out1="$(run_panel 999999 "$rd1" "$ctr1" 2>&1)"; rc1=$?
[ "$rc1" -ne 0 ] && ok "always-empty seat → panel exits non-zero ($rc1)" \
  || bad "always-empty seat → panel exited 0 (silently passed an empty verdict!)"
printf '%s' "$out1" | grep -q 'empty verdict after 3 attempts' \
  && ok "fails LOUD with the empty-verdict diagnostic" \
  || bad "missing the 'empty verdict after N attempts' diagnostic; got: $out1"
[ "$(cat "$ctr1")" = "3" ] \
  && ok "seat retried exactly GARDEN_PANEL_SEAT_ATTEMPTS (3) times" \
  || bad "seat invoked $(cat "$ctr1") times; expected 3"
printf '%s' "$out1" | grep -q 'PASSED' \
  && bad "panel printed PASSED on an empty seat (fail-open regression!)" \
  || ok "panel never announced PASSED / un-drafted"
[ -f "$rd1/round-1.typist.md.stderr" ] \
  && ok "per-seat .stderr captured to the run dir (diagnosable)" \
  || bad "no round-1.typist.md.stderr captured"

hr; echo "SUBTEST 2 — a seat empty twice then non-empty recovers and passes"; hr
rd2="$TR/rd2"; ctr2="$TR/ctr2"; : > "$ctr2"
out2="$(run_panel 3 "$rd2" "$ctr2" 2>&1)"; rc2=$?
[ "$rc2" -eq 0 ] && ok "recovered seat → panel exits 0" \
  || bad "recovered seat → panel exited $rc2; out: $out2"
printf '%s' "$out2" | grep -q 'PASSED' \
  && ok "panel announced PASSED after recovery" \
  || bad "panel did not announce PASSED; out: $out2"
[ "$(cat "$ctr2")" = "3" ] \
  && ok "seat retried until it produced a verdict (3 tries)" \
  || bad "seat invoked $(cat "$ctr2") times; expected 3"
grep -q 'Verdict: approve' "$rd2/round-1.md" 2>/dev/null \
  && ok "the recovered seat's real verdict reached the aggregate" \
  || bad "aggregate is missing the recovered verdict content"

hr; echo "SUBTEST 3 — a healthy first-try seat passes with a single attempt"; hr
rd3="$TR/rd3"; ctr3="$TR/ctr3"; : > "$ctr3"
out3="$(run_panel 1 "$rd3" "$ctr3" 2>&1)"; rc3=$?
[ "$rc3" -eq 0 ] && ok "healthy seat → panel exits 0" \
  || bad "healthy seat → panel exited $rc3; out: $out3"
[ "$(cat "$ctr3")" = "1" ] \
  && ok "no spurious retries on the healthy path (1 attempt)" \
  || bad "healthy seat invoked $(cat "$ctr3") times; expected 1"

hr
echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
