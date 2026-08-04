#!/bin/bash
# panel-single-round-test.sh — regression guard for panel.sh's SINGLE-ROUND MODE
# (GARDEN_PANEL_SINGLE_ROUND=1), the enabling primitive for the staged gauntlet
# (designs/staged-gauntlet.md).
#
# THE PROBLEM: the gauntlet ran as ONE claimed job whose handler had to span the
# WHOLE clean → panel → fix-loop → un-draft chain, including an UNBOUNDED number of
# panel rounds (panel.sh's internal `while :` up to GARDEN_PANEL_MAX_ROUNDS, with a
# fixer between rounds). No handler budget fits an unbounded loop; nine jobs doomed
# on deadline-overrun on 2026-07-28, one with a 14000s budget already at the
# GARDEN_CLAIM_TTL ceiling. The fix splits the gauntlet into claim-sized stages; one
# panel ROUND becomes its own stage.
#
# THE PRIMITIVE: GARDEN_PANEL_SINGLE_ROUND=1 makes panel.sh run EXACTLY ONE round,
# emit its disposition (`pass` or `must-fix`) as the terminal line's last token, and
# STOP — never invoking the fixer, the appellate, or the un-draft. The deterministic
# gauntlet driver reads that disposition to decide the next claim-sized stage.
#
# SUBTEST 1 — pass in single-round mode: exit 0, terminal token `pass`, exactly ONE
#             round ran (no round-2), and NEITHER the fixer NOR the un-draft hook ran.
# SUBTEST 2 — must-fix in single-round mode: exit 0, terminal token `must-fix`, exactly
#             ONE round ran (it did NOT loop to a fixer), and no hook ran. This is the
#             load-bearing difference from classic mode, which would loop here.
# SUBTEST 3 — fail-closed: a decider that never yields a valid token fails LOUDLY
#             (non-zero) and never un-drafts — no guessed disposition.
# SUBTEST 4 — classic mode unchanged: with the flag UNSET, a `pass` disposition still
#             runs the un-draft hook and announces PASSED (the primitive is inert).
#
# Hermetic: seat / decider / fixer / un-draft are all env-stubbed (committed in-repo
# stubs, since the test scratch is a noexec mount). No real `claude -p`, no network.
#
# Usage: panel-single-round-test.sh

# The ok/bad idiom is the intended A && pass || fail (SC2015, safe: ok never fails).
# shellcheck disable=SC2015
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PANEL="$(cd "$HERE/../gardening" && pwd)/panel.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/panel-single-round.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }
trap 'rm -rf "$TR"' EXIT

STUB_SEAT="$HERE/panel-parallel-fanout-stub.sh"   # emits an approve block per seat
STUB_DECIDE="$HERE/panel-decide-stub.sh"          # prints $DECIDE_VERDICT (default pass)
STUB_HOOK="$HERE/panel-hook-record-stub.sh"       # records that fixer/un-draft ran

SEATS="assessor typist"                            # a tiny code panel keeps it fast
mkdir -p "$TR/wt"                                  # non-git worktree → code panel

# run_panel <single?0|1> <verdict> <rundir> <fandir> <hooklog>
run_panel() {
  local single="$1" verdict="$2" rundir="$3" fandir="$4" hooklog="$5"
  FAN_DIR="$fandir" FAN_SLEEP=0 \
  DECIDE_VERDICT="$verdict" \
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
    bash "$PANEL" "$TR/wt" 777 HEAD~1
}

last_token() { printf '%s\n' "$1" | awk 'NF{l=$0} END{print l}' | awk '{print $NF}'; }

hr; echo "SUBTEST 1 — single-round pass: one round, no fixer, no un-draft"; hr
out1="$(run_panel 1 pass "$TR/rd1" "$TR/fan1" "$TR/hook1.log" 2>&1)"; rc1=$?
[ "$rc1" -eq 0 ] && ok "single-round pass exits 0" || bad "single-round pass exited $rc1: $out1"
[ "$(last_token "$out1")" = pass ] \
  && ok "terminal line's last token is 'pass'" \
  || bad "terminal token was '$(last_token "$out1")' (want pass); out: $out1"
[ -f "$TR/rd1/round-1.md" ] && ok "round 1 ran" || bad "round 1 did not run"
[ ! -f "$TR/rd1/round-2.md" ] \
  && ok "did NOT run a second round (single-round honored)" \
  || bad "a round-2.md exists; single-round mode looped"
[ ! -f "$TR/hook1.log" ] \
  && ok "neither the fixer nor the un-draft hook ran" \
  || bad "a hook ran in single-round mode: $(cat "$TR/hook1.log")"

hr; echo "SUBTEST 2 — single-round must-fix: reports must-fix, does NOT loop to a fixer"; hr
out2="$(run_panel 1 must-fix "$TR/rd2" "$TR/fan2" "$TR/hook2.log" 2>&1)"; rc2=$?
[ "$rc2" -eq 0 ] && ok "single-round must-fix exits 0" || bad "single-round must-fix exited $rc2: $out2"
[ "$(last_token "$out2")" = must-fix ] \
  && ok "terminal line's last token is 'must-fix'" \
  || bad "terminal token was '$(last_token "$out2")' (want must-fix); out: $out2"
[ ! -f "$TR/rd2/round-2.md" ] \
  && ok "must-fix did NOT loop to a second round (the classic-mode difference)" \
  || bad "a round-2.md exists; single-round must-fix looped to the fixer"
[ ! -f "$TR/hook2.log" ] \
  && ok "the fixer hook did NOT run on a single-round must-fix" \
  || bad "the fixer ran in single-round mode: $(cat "$TR/hook2.log")"

hr; echo "SUBTEST 3 — fail-closed: an un-parseable disposition fails loud, never un-drafts"; hr
out3="$(run_panel 1 garbagetoken "$TR/rd3" "$TR/fan3" "$TR/hook3.log" 2>&1)"; rc3=$?
[ "$rc3" -ne 0 ] \
  && ok "a decider that never yields must-fix/pass fails non-zero ($rc3)" \
  || bad "single-round fail-open: exited 0 on a garbage disposition: $out3"
[ ! -f "$TR/hook3.log" ] \
  && ok "no un-draft on an un-parseable disposition" \
  || bad "the un-draft hook ran despite no valid disposition: $(cat "$TR/hook3.log")"

hr; echo "SUBTEST 4 — classic mode (flag unset) is UNCHANGED: pass still un-drafts"; hr
out4="$(run_panel 0 pass "$TR/rd4" "$TR/fan4" "$TR/hook4.log" 2>&1)"; rc4=$?
[ "$rc4" -eq 0 ] && ok "classic pass exits 0" || bad "classic pass exited $rc4: $out4"
printf '%s' "$out4" | grep -q 'PASSED' \
  && ok "classic mode announces PASSED" \
  || bad "classic mode did not announce PASSED: $out4"
{ [ -f "$TR/hook4.log" ] && grep -q 'panel-hook-record-stub.sh 777$' "$TR/hook4.log"; } \
  && ok "classic mode ran the un-draft hook (inert primitive did not break it)" \
  || bad "classic mode did not run the un-draft hook: $(cat "$TR/hook4.log" 2>/dev/null)"

hr
echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
