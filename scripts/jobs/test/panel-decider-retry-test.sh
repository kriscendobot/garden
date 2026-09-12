#!/bin/bash
# panel-decider-retry-test.sh — regression guard for the FOREPERSON-DECIDER
# retry in panel.sh (scripts/jobs/gardening/panel.sh, the disposition gate).
#
# THE BUG (diagnose-panel-seat-error-rate): the disposition step was written with a
# 2-attempt retry loop ("retry the decider once on garbage, then FAIL LOUDLY"), but
# the attempt was a BARE assignment from a command substitution:
#
#     raw="$(decide_disposition "$agg")"
#
# Under `set -euo pipefail`, a NON-ZERO exit from the substitution (the foreperson
# `claude -p` overloaded / rate-limited / 5xx) gives the assignment that non-zero
# status and ABORTS the whole panel — BEFORE the loop can retry. PANEL_DISPOSITION
# is left at its default `error`, panel.sh exits non-zero, and the gauntlet's panel
# stage fails and halts. Historical `disposition: error` records with completed
# seats are consistent with this path, but their discarded decider stderr cannot
# establish which one took it. This test establishes the control-flow bug itself.
# It is the same transient-provider-failure class the per-seat path was hardened
# against, missed at the decision hook. The fix tolerates the non-zero exit
# (`|| _decide_rc=$?`) so the existing retry loop actually runs.
#
# SUBTEST 1 — RECOVERS: a decider that exits non-zero ONCE then succeeds. The panel
#             must reach a real disposition (exit 0, terminal token `pass`), and the
#             decider must have been invoked TWICE (the retry ran). Before the fix
#             the panel aborted after ONE invocation with a non-zero exit.
# SUBTEST 2 — LOUD, CORRECTLY ATTRIBUTED: a decider that ALWAYS exits non-zero must
#             fail non-zero (never un-draft) AND record disposition `decider-error`,
#             NOT the default `error` — proving the two exhausted attempts ran and
#             the terminal path (not a `set -e` abort) was taken.
#
# Hermetic: seat / decider / record are env-stubbed committed in-repo files (the
# test scratch is a noexec mount). No real `claude -p`, no network.
#
# Usage: panel-decider-retry-test.sh

# The ok/bad idiom is the intended A && pass || fail (SC2015, safe: ok never fails).
# shellcheck disable=SC2015
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PANEL="$(cd "$HERE/../gardening" && pwd)/panel.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/panel-decider-retry.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }
trap 'rm -rf "$TR"' EXIT

STUB_SEAT="$HERE/panel-parallel-fanout-stub.sh"   # emits an approve block per seat
STUB_DECIDE="$HERE/panel-decide-stub.sh"          # flaky when DECIDE_FAIL_TIMES set
STUB_RECORD="$HERE/panel-record-capture-stub.sh"  # copies record-meta to RECORD_META_OUT

SEATS="assessor typist"                            # a tiny code panel keeps it fast
mkdir -p "$TR/wt"                                  # non-git worktree → code panel

last_token() { printf '%s\n' "$1" | awk 'NF{l=$0} END{print l}' | awk '{print $NF}'; }

# run_panel <rundir> <fandir> <count-file> <fail-times> <verdict> <record-meta-out>
run_panel() {
  local rundir="$1" fandir="$2" cfile="$3" ftimes="$4" verdict="$5" metaout="$6"
  FAN_DIR="$fandir" FAN_SLEEP=0 \
  DECIDE_VERDICT="$verdict" \
  DECIDE_FAIL_TIMES="$ftimes" DECIDE_COUNT_FILE="$cfile" \
  RECORD_META_OUT="$metaout" \
  GARDEN_PANEL_SINGLE_ROUND=1 \
  GARDEN_CODE_SEATS="$SEATS" \
  GARDEN_PANEL_CONCURRENCY=2 \
  GARDEN_PANEL_SEAT="$STUB_SEAT" \
  GARDEN_PANEL_DECIDE="$STUB_DECIDE" \
  GARDEN_PANEL_APPELLATE=":" \
  GARDEN_PANEL_FIXER="true" \
  GARDEN_PANEL_UNDRAFT="true" \
  GARDEN_PANEL_SEAT_ATTEMPTS=2 \
  GARDEN_PANEL_SEAT_BACKOFF=0 \
  GARDEN_PANEL_DECIDE_BACKOFF=0 \
  GARDEN_PANEL_RECORD="$STUB_RECORD" \
  GARDEN_PANEL_RELATED_DESIGN=":" \
  GARDEN_PANEL_RUNDIR="$rundir" \
    bash "$PANEL" "$TR/wt" 777 HEAD~1
}

hr; echo "SUBTEST 1 — a decider that fails ONCE then succeeds RECOVERS"; hr
: > "$TR/count1"
out1="$(run_panel "$TR/rd1" "$TR/fan1" "$TR/count1" 1 pass "$TR/meta1" 2>&1)"; rc1=$?
[ "$rc1" -eq 0 ] \
  && ok "panel recovered and exited 0 despite one decider failure" \
  || bad "panel exited $rc1 on a single transient decider failure (the set -e abort bug): $out1"
[ "$(last_token "$out1")" = pass ] \
  && ok "terminal token is 'pass' after the retry" \
  || bad "terminal token was '$(last_token "$out1")' (want pass); out: $out1"
c1="$(cat "$TR/count1" 2>/dev/null || echo 0)"
[ "$c1" -eq 2 ] \
  && ok "the decider was invoked twice (the retry loop actually ran)" \
  || bad "the decider was invoked $c1 time(s), not 2 — the retry did not run (set -e aborted first)"

hr; echo "SUBTEST 2 — a persistently-failing decider fails LOUD as 'decider-error', not default 'error'"; hr
: > "$TR/count2"
out2="$(run_panel "$TR/rd2" "$TR/fan2" "$TR/count2" 99 pass "$TR/meta2" 2>&1)"; rc2=$?
[ "$rc2" -ne 0 ] \
  && ok "a persistently-failing decider fails non-zero ($rc2)" \
  || bad "panel exited 0 despite the decider never succeeding: $out2"
c2="$(cat "$TR/count2" 2>/dev/null || echo 0)"
[ "$c2" -eq 2 ] \
  && ok "both decider attempts ran before failing (count=$c2)" \
  || bad "the decider ran $c2 time(s), not the 2 attempts the loop promises"
disp2="$(sed -n 's/^disposition=//p' "$TR/meta2" 2>/dev/null | head -1)"
[ "$disp2" = "decider-error" ] \
  && ok "recorded disposition is 'decider-error' (correctly attributed, not the default 'error')" \
  || bad "recorded disposition is '$disp2' (want decider-error; default 'error' means the set -e abort still happens)"

hr
echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
