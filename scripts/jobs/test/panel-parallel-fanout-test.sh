#!/bin/bash
# panel-parallel-fanout-test.sh — regression guard for panel.sh's BOUNDED-
# CONCURRENCY seat fan-out (scripts/jobs/gardening/panel.sh).
#
# THE PROBLEM: the seat fan-out was a strictly sequential `for seat in $seats`
# loop. Measured on this fleet, one seat reviewing a ~1500-line diff takes over
# three minutes, so the 29-seat code panel ran ~1.5-2.5 HOURS against a default
# GARDEN_HANDLER_TIMEOUT of 2400s — structurally outside a gardener's budget.
# Every build's auto-gauntlet and every `run the gauntlet` job was therefore
# unrunnable in one claim unless whoever posted it REMEMBERED to stamp
# `handler-timeout:`, with a reduced panel plus a spillover job as the fallback.
#
# THE FIX: fan the seats concurrently, GARDEN_PANEL_CONCURRENCY at a time, and
# append the blocks to the round aggregate in a deterministic second pass in
# `$seats` order after the join — so the panel fits the budget by construction
# while the aggregate stays byte-identical to the sequential one.
#
# SUBTEST 1 — the fan-out is REAL: N seats each sleeping 1s finish in roughly
#             one seat's time at concurrency N, and roughly N× that at 1.
# SUBTEST 2 — the fan-out is BOUNDED: never more than GARDEN_PANEL_CONCURRENCY
#             seats in flight, and the bound is actually reached (not serialized).
# SUBTEST 3 — the aggregate is BYTE-STABLE and in `$seats` order regardless of
#             concurrency: concurrency=1 and concurrency=8 produce identical
#             round-1.md, with the seats in list order, not completion order.
# SUBTEST 4 — a failing seat under parallel fan-out still fails LOUDLY, names
#             THAT seat, never un-drafts, and the healthy seats still ran.
# SUBTEST 5 — a garbage GARDEN_PANEL_CONCURRENCY falls back to a sane bound
#             instead of wedging the fan-out.
#
# Hermetic: the seat review, the disposition decider, the appellate and the
# un-draft are all env-stubbed (GARDEN_PANEL_SEAT / _DECIDE / _APPELLATE /
# _UNDRAFT), so NO real `claude -p` and NO network.
#
# Usage: panel-parallel-fanout-test.sh

# The ok/bad idiom is the intended A && pass || fail (SC2015, safe: ok never
# fails). Deliberate.
# shellcheck disable=SC2015
set -uo pipefail
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PANEL="$(cd "$HERE/../gardening" && pwd)/panel.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/panel-parallel-fanout.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }
trap 'rm -rf "$TR"' EXIT

# Both stubs are COMMITTED in-repo files rather than $TR heredocs: the test
# scratch (/tmp) is a noexec mount on this host and panel.sh runs the hooks
# directly. The seat stub records in-flight concurrency under $FAN_DIR.
STUB_SEAT="$HERE/panel-parallel-fanout-stub.sh"
STUB_DECIDE="$HERE/panel-decide-stub.sh"   # prints `pass`

SEATS8="assessor typist stylist packager archivist prover curator migrator"

run_panel() {  # run_panel <seats> <concurrency> <rundir> <fandir> [sleep] [fail-seat]
  FAN_DIR="$4" FAN_SLEEP="${5:-0}" FAN_FAIL_SEAT="${6:-}" \
  GARDEN_CODE_SEATS="$1" \
  GARDEN_PANEL_CONCURRENCY="$2" \
  GARDEN_PANEL_SEAT="$STUB_SEAT" \
  GARDEN_PANEL_DECIDE="$STUB_DECIDE" \
  GARDEN_PANEL_APPELLATE=":" \
  GARDEN_PANEL_UNDRAFT="true" \
  GARDEN_PANEL_SEAT_ATTEMPTS=2 \
  GARDEN_PANEL_SEAT_BACKOFF=0 \
  GARDEN_PANEL_RUNDIR="$3" \
    bash "$PANEL" "$TR/wt" 999 HEAD~1
}
mkdir -p "$TR/wt"   # a non-git worktree → sense falls to the (broader) code panel

hr; echo "SUBTEST 1 — the fan-out is real (8 one-second seats do not take 8s)"; hr
t0=$SECONDS
run_panel "$SEATS8" 8 "$TR/rd-par" "$TR/fan-par" 1 >/dev/null 2>&1; rc=$?
par=$((SECONDS - t0))
[ "$rc" -eq 0 ] && ok "parallel panel exits 0" || bad "parallel panel exited $rc"
[ "$par" -le 4 ] \
  && ok "8 seats × 1s at concurrency 8 took ${par}s (≤4s)" \
  || bad "8 seats × 1s at concurrency 8 took ${par}s; expected ≤4s (fan-out serialized?)"

t0=$SECONDS
run_panel "assessor typist stylist packager" 1 "$TR/rd-ser" "$TR/fan-ser" 1 >/dev/null 2>&1
ser=$((SECONDS - t0))
[ "$ser" -ge 3 ] \
  && ok "the same seats at concurrency 1 serialize (${ser}s for 4 × 1s)" \
  || bad "concurrency 1 took only ${ser}s; the knob is not bounding anything"

hr; echo "SUBTEST 2 — concurrency is bounded by GARDEN_PANEL_CONCURRENCY"; hr
run_panel "$SEATS8" 3 "$TR/rd-b3" "$TR/fan-b3" 1 >/dev/null 2>&1
maxb3="$(sort -n "$TR/fan-b3/inflight.log" | tail -1)"
[ "${maxb3:-0}" -le 3 ] \
  && ok "never more than 3 seats in flight (observed max ${maxb3})" \
  || bad "observed ${maxb3} seats in flight with GARDEN_PANEL_CONCURRENCY=3"
[ "${maxb3:-0}" -ge 2 ] \
  && ok "the bound is actually used (observed max ${maxb3} > 1)" \
  || bad "observed max ${maxb3} in flight; seats ran one at a time"
maxpar="$(sort -n "$TR/fan-par/inflight.log" | tail -1)"
[ "${maxpar:-0}" -le 8 ] \
  && ok "concurrency 8 never exceeded its bound (observed max ${maxpar})" \
  || bad "observed ${maxpar} seats in flight with GARDEN_PANEL_CONCURRENCY=8"

hr; echo "SUBTEST 3 — the aggregate is byte-stable and in seat-list order"; hr
run_panel "$SEATS8" 1 "$TR/rd-o1" "$TR/fan-o1" 0 >/dev/null 2>&1
run_panel "$SEATS8" 8 "$TR/rd-o8" "$TR/fan-o8" 0 >/dev/null 2>&1
cmp -s "$TR/rd-o1/round-1.md" "$TR/rd-o8/round-1.md" \
  && ok "round-1.md is byte-identical at concurrency 1 and 8" \
  || bad "round-1.md differs by concurrency: $(diff "$TR/rd-o1/round-1.md" "$TR/rd-o8/round-1.md" | head -5)"
got="$(grep '^### ' "$TR/rd-o8/round-1.md" | sed 's/^### //' | tr '\n' ' ' | sed 's/ *$//')"
[ "$got" = "$SEATS8" ] \
  && ok "blocks appear in \$seats order, not completion order" \
  || bad "aggregate order is '$got'; expected '$SEATS8'"
[ "$(grep -c '^### ' "$TR/rd-o8/round-1.md")" = 8 ] \
  && ok "every seat's block reached the aggregate exactly once" \
  || bad "aggregate holds $(grep -c '^### ' "$TR/rd-o8/round-1.md") blocks; expected 8"

hr; echo "SUBTEST 4 — one always-empty seat fails the parallel panel loudly"; hr
out4="$(run_panel "$SEATS8" 8 "$TR/rd-f" "$TR/fan-f" 0 prover 2>&1)"; rc4=$?
[ "$rc4" -ne 0 ] && ok "a failing seat → panel exits non-zero ($rc4)" \
  || bad "a failing seat → panel exited 0 (fail-open regression!)"
printf '%s' "$out4" | grep -q "seat prover (empty verdict after 2 attempts" \
  && ok "fails LOUD naming the failing seat and its attempt count" \
  || bad "missing the per-seat empty-verdict diagnostic; got: $out4"
printf '%s' "$out4" | grep -q 'PASSED' \
  && bad "panel printed PASSED with an empty seat (fail-open regression!)" \
  || ok "panel never announced PASSED / un-drafted"
[ -s "$TR/rd-f/round-1.typist.md" ] \
  && ok "healthy seats still ran and filed their blocks" \
  || bad "a peer seat produced no block; the fan-out aborted early"
[ "$(cat "$TR/rd-f/round-1.prover.md.status" 2>/dev/null)" = fail ] \
  && ok "the failing seat recorded status 'fail' for the join pass" \
  || bad "prover status is '$(cat "$TR/rd-f/round-1.prover.md.status" 2>/dev/null)'; expected fail"

hr; echo "SUBTEST 5 — a garbage concurrency value falls back, never wedges"; hr
out5="$(run_panel "assessor typist" "lots" "$TR/rd-g" "$TR/fan-g" 0 2>&1)"; rc5=$?
[ "$rc5" -eq 0 ] && ok "non-numeric GARDEN_PANEL_CONCURRENCY → panel still passes" \
  || bad "non-numeric concurrency broke the panel (rc=$rc5): $out5"
out6="$(run_panel "assessor typist" 0 "$TR/rd-z" "$TR/fan-z" 0 2>&1)"; rc6=$?
[ "$rc6" -eq 0 ] && ok "GARDEN_PANEL_CONCURRENCY=0 clamps to 1 instead of stalling" \
  || bad "concurrency 0 broke the panel (rc=$rc6): $out6"

hr
echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
