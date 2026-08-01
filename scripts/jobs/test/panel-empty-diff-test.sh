#!/bin/bash
# panel-empty-diff-test.sh — regression guard for panel.sh's EMPTY-DIFF
# short-circuit: a PR whose diff against its base is empty has no review surface,
# so the panel passes it without dispatching a single seat.
#
# THE PROBLEM: a diagnostic baseline PR's head is an empty commit on a frozen
# snapshot (endojs/endo-but-for-bots#847, `chore(ci): establish current master
# baseline`: 0 files, 0 lines). panel.sh's sense_panel_kind falls to the CODE
# panel on "no changed files", so such a PR dispatched all 28 code seats to review
# nothing — 28 `claude -p` calls whose only honest verdict is a vacuous approve,
# on a fleet whose worker pool is throttled for quota.
#
# THE GATE: deterministic and narrow. It fires only when git AGREES the diff is
# empty — the diff command exited 0 (so a merge base exists) and both endpoints
# resolve to commits. Any ambiguity (git error, missing base, non-git worktree)
# leaves the normal panel running, matching sense_panel_kind's bias toward
# over-reviewing.
#
# SUBTEST 1 — empty diff, classic mode: exit 0, NO seat ran, NO round aggregate
#             was written, and the un-draft hook DID run (the terminal step is
#             still owed).
# SUBTEST 2 — empty diff, single-round mode: exit 0, terminal token `pass` (the
#             contract the staged-gauntlet driver reads), no seat, and NO un-draft
#             (single-round never un-drafts).
# SUBTEST 3 — NON-empty diff is unaffected: seats run and a round aggregate exists.
# SUBTEST 4 — fail-closed on ambiguity: a NON-git worktree does NOT trip the gate;
#             the normal panel runs. This pins the "an empty diff we could not
#             confirm is treated as a diff" rule.
#
# Hermetic: seat / decider / un-draft are env-stubbed with committed in-repo stubs
# (the test scratch is a noexec mount). No real `claude -p`, no network.
#
# Usage: panel-empty-diff-test.sh

# The ok/bad idiom is the intended A && pass || fail (SC2015, safe: ok never fails).
# shellcheck disable=SC2015
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PANEL="$(cd "$HERE/../gardening" && pwd)/panel.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/panel-empty-diff.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }
trap 'rm -rf "$TR"' EXIT

STUB_SEAT="$HERE/panel-parallel-fanout-stub.sh"   # emits an approve block per seat
STUB_DECIDE="$HERE/panel-decide-stub.sh"          # prints $DECIDE_VERDICT (default pass)
STUB_HOOK="$HERE/panel-hook-record-stub.sh"       # records that fixer/un-draft ran

SEATS="assessor typist"                            # a tiny code panel keeps it fast

# A worktree whose HEAD is an EMPTY commit on top of its base — the baseline-PR
# shape. `base` is the parent ref, so `base...HEAD` is genuinely empty.
mkdir -p "$TR/empty"
(
  set -e
  cd "$TR/empty"
  git init -q .
  git config user.name garden-test; git config user.email garden-test@example.invalid
  echo seed > seed.txt; git add seed.txt
  git commit -qm 'base commit'
  git commit -q --allow-empty -m 'chore: establish baseline'
) || { echo "FATAL: could not build the empty-diff fixture"; exit 1; }

# A worktree whose HEAD DOES change a file — the ordinary shape.
mkdir -p "$TR/nonempty"
(
  set -e
  cd "$TR/nonempty"
  git init -q .
  git config user.name garden-test; git config user.email garden-test@example.invalid
  echo seed > seed.txt; git add seed.txt
  git commit -qm 'base commit'
  echo change >> seed.txt; git add seed.txt
  git commit -qm 'feat: change a line'
) || { echo "FATAL: could not build the non-empty-diff fixture"; exit 1; }

mkdir -p "$TR/nongit"                              # not a git repo at all

# run_panel <worktree> <single?0|1> <rundir> <fandir> <hooklog>
run_panel() {
  local wt="$1" single="$2" rundir="$3" fandir="$4" hooklog="$5"
  FAN_DIR="$fandir" FAN_SLEEP=0 \
  DECIDE_VERDICT=pass \
  PANEL_HOOK_LOG="$hooklog" \
  GARDEN_PANEL_SINGLE_ROUND="$single" \
  GARDEN_CODE_SEATS="$SEATS" \
  GARDEN_PANEL_CONCURRENCY=2 \
  GARDEN_PANEL_SEAT="$STUB_SEAT" \
  GARDEN_PANEL_DECIDE="$STUB_DECIDE" \
  GARDEN_PANEL_APPELLATE=":" \
  GARDEN_PANEL_FIXER="$STUB_HOOK" \
  GARDEN_PANEL_UNDRAFT="$STUB_HOOK" \
  GARDEN_PANEL_SEAT_ATTEMPTS=2 \
  GARDEN_PANEL_SEAT_BACKOFF=0 \
  GARDEN_PANEL_RECORD=":" \
  GARDEN_PANEL_RUNDIR="$rundir" \
    bash "$PANEL" "$wt" 847 HEAD~1
}

last_token() { printf '%s\n' "$1" | awk 'NF{l=$0} END{print l}' | awk '{print $NF}'; }

hr; echo "SUBTEST 1 — empty diff, classic mode: no seats, still un-drafts"; hr
out1="$(run_panel "$TR/empty" 0 "$TR/rd1" "$TR/fan1" "$TR/hook1.log" 2>&1)"; rc1=$?
[ "$rc1" -eq 0 ] && ok "empty-diff panel exits 0" || bad "empty-diff panel exited $rc1: $out1"
[ ! -e "$TR/fan1/inflight.log" ] \
  && ok "NO seat was dispatched (no \`claude -p\` spent on an empty diff)" \
  || bad "seats ran on an empty diff: $(cat "$TR/fan1/inflight.log")"
[ ! -f "$TR/rd1/round-1.md" ] \
  && ok "no round aggregate was written (zero rounds)" \
  || bad "a round-1.md exists; the panel ran a round over an empty diff"
{ [ -f "$TR/hook1.log" ] && grep -q 'panel-hook-record-stub.sh 847$' "$TR/hook1.log"; } \
  && ok "the un-draft hook ran (the terminal step is still owed)" \
  || bad "the un-draft hook did not run: $(cat "$TR/hook1.log" 2>/dev/null)"
printf '%s' "$out1" | grep -q 'PASSED after 0 round' \
  && ok "announces PASSED after 0 rounds" \
  || bad "did not announce a 0-round pass: $out1"

hr; echo "SUBTEST 2 — empty diff, single-round mode: 'pass' token, no un-draft"; hr
out2="$(run_panel "$TR/empty" 1 "$TR/rd2" "$TR/fan2" "$TR/hook2.log" 2>&1)"; rc2=$?
[ "$rc2" -eq 0 ] && ok "single-round empty-diff panel exits 0" || bad "exited $rc2: $out2"
[ "$(last_token "$out2")" = pass ] \
  && ok "terminal line's last token is 'pass' (the driver's contract)" \
  || bad "terminal token was '$(last_token "$out2")' (want pass); out: $out2"
[ ! -e "$TR/fan2/inflight.log" ] \
  && ok "NO seat was dispatched in single-round mode either" \
  || bad "seats ran: $(cat "$TR/fan2/inflight.log")"
[ ! -f "$TR/hook2.log" ] \
  && ok "single-round did NOT un-draft" \
  || bad "the un-draft hook ran in single-round mode: $(cat "$TR/hook2.log")"

hr; echo "SUBTEST 3 — a NON-empty diff still runs the full panel"; hr
out3="$(run_panel "$TR/nonempty" 0 "$TR/rd3" "$TR/fan3" "$TR/hook3.log" 2>&1)"; rc3=$?
[ "$rc3" -eq 0 ] && ok "non-empty-diff panel exits 0" || bad "exited $rc3: $out3"
[ -f "$TR/rd3/round-1.md" ] \
  && ok "a round ran over a real diff" \
  || bad "no round-1.md; the gate swallowed a real diff"
[ -e "$TR/fan3/inflight.log" ] \
  && ok "seats were dispatched over a real diff" \
  || bad "no seat ran on a non-empty diff"

hr; echo "SUBTEST 4 — fail-closed: a non-git worktree does NOT trip the gate"; hr
out4="$(run_panel "$TR/nongit" 0 "$TR/rd4" "$TR/fan4" "$TR/hook4.log" 2>&1)"; rc4=$?
[ "$rc4" -eq 0 ] && ok "non-git panel exits 0" || bad "exited $rc4: $out4"
[ -f "$TR/rd4/round-1.md" ] \
  && ok "an unconfirmable empty diff is treated as a diff (normal panel ran)" \
  || bad "the gate fired on ambiguity; no round-1.md: $out4"

hr
echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
