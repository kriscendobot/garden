#!/bin/bash
# panel-run-record-test.sh — end-to-end guard for the durable COMPACT panel-run
# record (scripts/jobs/gardening/panel.sh emitting via scripts/jobs/panel-run-record.sh).
#
# THE GAP (issue #62 follow-up, @jcorbin's cross-analysis): the scripted review
# panel is the garden's primary evaluator, yet it left NO durable evidence — the
# per-seat verdicts, round aggregates and appellate block went to a scratch rundir
# torn down with the job's worktree. Nothing in journal2 recorded which seats
# reviewed which PR, how many fix-loop rounds it took, or the must-fix items, so
# the garden could not audit its own evaluator.
#
# THE FIX: on panel termination (pass, the max-rounds bound, OR a fail) panel.sh
# BEST-EFFORT pushes ONE compact record per run to journal2 via a deterministic
# writer (no `claude -p`). This test drives the REAL panel.sh with the seat /
# decide / fixer / un-draft hooks stubbed and a THROWAWAY journal, asserting:
#
#   SUBTEST 1 — a clean PASS lands a record (rounds=1, disposition=passed) and the
#               seat's scratch PROSE does NOT appear in it (only the verdict class
#               and a truncated must-fix title are compact enough to be durable).
#   SUBTEST 2 — a must-fix→pass loop lands a record with the CORRECT round count
#               (rounds=2, disposition=passed), the must-fix title captured, and
#               the seat prose still absent.
#   SUBTEST 3 — a FAILURE (never converges → the max-rounds bound) lands a record
#               with disposition=max-rounds-exceeded.
#   SUBTEST 4 — re-emitting the SAME run is idempotent (one file, byte-identical).
#   SUBTEST 5 — a simulated push failure (journal remote unreachable) WARNs and
#               NEVER fails the panel (a clean pass still exits 0 + un-drafts).
#
# Hermetic: every judgment hook is env-stubbed (no live `claude -p`, no network to
# GitHub) and the journal is a throwaway bare repo. Backoff is zeroed.
#
# Usage: panel-run-record-test.sh
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
PANEL="$JOBS/gardening/panel.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env (this may run AS a board job under a live gardener) so it
# cannot splice its own GARDEN_* state or a real journal remote under the fixture.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1 GARDEN_ROOT="$ROOT" GARDEN_NO_MAINTAINER_ALERT=1

TR="$(mktemp -d "${TMPDIR:-/tmp}/panel-run-record.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

git_id=(-c user.name=test -c user.email=test@localhost)

# seed_board <tr-sub> — a throwaway bare journal2 origin with the panel-runs/ dir.
# Echoes the bare repo path.
seed_board() {
  local sub="$1"; local bare="$sub/journal.git" seed="$sub/seed" branch=journal2
  mkdir -p "$sub"
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$branch"
  ( cd "$seed"
    mkdir -p panel-runs; touch panel-runs/.gitkeep )
  git -C "$seed" add -A
  git -C "$seed" "${git_id[@]}" commit -q -m seed
  git -C "$seed" remote add origin "$bare"
  git -C "$seed" push -q -u origin "$branch"
  printf '%s\n' "$bare"
}
verify_clone() { git clone -q --single-branch --branch journal2 "$1" "$2" 2>/dev/null; }

STUB_SEAT="$HERE/panel-run-record-seat-stub.sh"
STUB_DECIDE="$HERE/panel-run-record-decide-stub.sh"
STUB_FIXER="$HERE/panel-run-record-fixer-stub.sh"
SENTINEL="SEATPROSE_MUST_NOT_LEAK_9c1f"

# run_panel <sub> <bare> <pr> <extra-env...>  — run panel.sh against a throwaway
# journal, a single CODE seat, and the stubbed hooks. Extra `KEY=VAL` args tune the
# scenario (SEAT_MODE, FIX_MARKER, GARDEN_PANEL_MAX_ROUNDS, GARDEN_PANEL_REPO, …).
run_panel() {
  local sub="$1" bare="$2" pr="$3"; shift 3
  mkdir -p "$sub/wt"      # non-git worktree → sense falls to the (broader) code panel
  env \
    GARDEN=trh GARDEN_STATE="$sub/state" \
    JOURNAL_REMOTE="$bare" JOURNAL_BRANCH=journal2 \
    GARDEN_PRODUCER_CLONE="$sub/state/producer/journal" \
    GARDEN_CODE_SEATS="typist" \
    GARDEN_PANEL_SEAT="$STUB_SEAT" \
    GARDEN_PANEL_DECIDE="$STUB_DECIDE" \
    GARDEN_PANEL_FIXER="$STUB_FIXER" \
    GARDEN_PANEL_APPELLATE=":" \
    GARDEN_PANEL_UNDRAFT="true" \
    GARDEN_PANEL_SEAT_BACKOFF=0 \
    GARDEN_POST_ATTEMPTS=3 \
    PROSE_SENTINEL="$SENTINEL" \
    GARDEN_PANEL_RUNDIR="$sub/rundir" \
    "$@" \
    bash "$PANEL" "$sub/wt" "$pr" HEAD~1
}

# the single record file under panel-runs/<slug>/, or empty
record_path() { find "$1/panel-runs" -type f -name '*.md' 2>/dev/null | grep -v '.gitkeep' | head -1; }

# ============================================================================
hr; echo "SUBTEST 1 — a clean PASS lands a compact record; seat prose does not leak"; hr
S1="$TR/s1"; B1="$(seed_board "$S1")"
out1="$(run_panel "$S1" "$B1" 101 SEAT_MODE=approve GARDEN_PANEL_REPO=acme/widget 2>"$S1/err")"; rc1=$?
[ "$rc1" -eq 0 ] && ok "clean-pass panel exits 0" || bad "panel exited $rc1; err: $(cat "$S1/err")"
printf '%s' "$out1" | grep -q 'PASSED' && ok "panel announced PASSED (quiet-success line)" \
  || bad "panel did not announce PASSED; out: $out1"
V1="$TR/v1"; verify_clone "$B1" "$V1"
REC1="$(record_path "$V1")"
if [ -n "$REC1" ]; then
  ok "a panel-run record landed on journal2 ($(echo "$REC1" | sed "s#$V1/##"))"
  case "$REC1" in *"/panel-runs/acme-widget-101/"*) ok "record keyed under panel-runs/acme-widget-101/" ;;
    *) bad "record not keyed by repo-pr slug: $REC1" ;; esac
  grep -qE '^disposition: passed$'   "$REC1" && ok "disposition: passed" || bad "wrong/absent disposition"
  grep -qE '^rounds: 1$'             "$REC1" && ok "rounds: 1 for a clean pass" || bad "wrong round count"
  grep -qE '^panel_kind: code$'      "$REC1" && ok "panel_kind: code recorded" || bad "panel_kind absent"
  grep -qE '^kind: panel-run$'       "$REC1" && ok "record self-identifies (kind: panel-run)" || bad "kind field absent"
  grep -qE '^epoch:'                 "$REC1" && ok "epoch: field reserved for evaluation-epoch id" || bad "epoch field not reserved"
  grep -qE 'typist=pass'             "$REC1" && ok "per-seat verdict CLASS recorded (typist=pass)" || bad "seat verdict class absent"
  grep -q  "$SENTINEL"               "$REC1" && bad "seat PROSE leaked into the record!" || ok "seat prose does NOT appear (compact record)"
else
  bad "no panel-run record landed (record.log: $(tail -3 "$S1/rundir/record.log" 2>/dev/null | tr '\n' '|'))"
fi

# ============================================================================
hr; echo "SUBTEST 2 — a must-fix→pass loop records the correct round count"; hr
S2="$TR/s2"; B2="$(seed_board "$S2")"
run_panel "$S2" "$B2" 202 FIX_MARKER="$S2/fixed" GARDEN_PANEL_REPO=acme/widget >/dev/null 2>"$S2/err"; rc2=$?
[ "$rc2" -eq 0 ] && ok "must-fix→pass panel converges and exits 0" || bad "panel exited $rc2; err: $(cat "$S2/err")"
V2="$TR/v2"; verify_clone "$B2" "$V2"
REC2="$(record_path "$V2")"
if [ -n "$REC2" ]; then
  grep -qE '^rounds: 2$'           "$REC2" && ok "rounds: 2 (round 1 must-fix, round 2 pass)" || bad "wrong round count: $(grep '^rounds:' "$REC2")"
  grep -qE '^disposition: passed$' "$REC2" && ok "disposition: passed after the loop" || bad "wrong disposition"
  grep -q 'empty-input case'       "$REC2" && ok "the must-fix TITLE is captured (greppable for recurrence)" || bad "must-fix title absent"
  grep -qE 'typist=must-fix'       "$REC2" && ok "round-1 must-fix verdict class recorded" || bad "must-fix class absent"
  grep -qE 'typist=pass'           "$REC2" && ok "round-2 pass verdict class recorded" || bad "round-2 pass class absent"
  grep -q  "$SENTINEL"             "$REC2" && bad "seat prose leaked!" || ok "seat prose still absent across the loop"
else
  bad "no record for the fix loop (record.log: $(tail -3 "$S2/rundir/record.log" 2>/dev/null | tr '\n' '|'))"
fi

# ============================================================================
hr; echo "SUBTEST 3 — a FAILURE (max-rounds bound) still lands a record"; hr
S3="$TR/s3"; B3="$(seed_board "$S3")"
run_panel "$S3" "$B3" 303 SEAT_MODE=request GARDEN_PANEL_MAX_ROUNDS=2 GARDEN_PANEL_REPO=acme/widget >/dev/null 2>"$S3/err"; rc3=$?
[ "$rc3" -ne 0 ] && ok "never-converging panel FAILS loudly (exit $rc3)" || bad "panel should have failed at the round bound"
V3="$TR/v3"; verify_clone "$B3" "$V3"
REC3="$(record_path "$V3")"
if [ -n "$REC3" ]; then
  ok "a record lands even on failure (evaluator evidence is not lost on a stuck PR)"
  grep -qE '^disposition: max-rounds-exceeded$' "$REC3" && ok "disposition: max-rounds-exceeded" || bad "wrong disposition: $(grep '^disposition:' "$REC3")"
  grep -qE '^rounds: 2$' "$REC3" && ok "rounds: 2 (the max bound's completed rounds)" || bad "wrong round count: $(grep '^rounds:' "$REC3")"
else
  bad "no record on the failure path (record.log: $(tail -3 "$S3/rundir/record.log" 2>/dev/null | tr '\n' '|'))"
fi

# ============================================================================
hr; echo "SUBTEST 4 — re-emitting the SAME run is idempotent"; hr
# Re-run the writer directly against subtest 1's rundir + journal: same run-id, so
# the second emit stages no change and pushes nothing (no duplicate record).
env GARDEN=trh GARDEN_STATE="$S1/state" GARDEN_TEST=1 GARDEN_ROOT="$ROOT" \
    JOURNAL_REMOTE="$B1" JOURNAL_BRANCH=journal2 \
    GARDEN_PRODUCER_CLONE="$S1/state/producer/journal2b" \
    bash "$JOBS/panel-run-record.sh" emit "$S1/rundir" >/dev/null 2>"$S1/reemit.err" || true
V1b="$TR/v1b"; verify_clone "$B1" "$V1b"
n_records="$(find "$V1b/panel-runs" -type f -name '*.md' 2>/dev/null | grep -vc '.gitkeep')"
[ "$n_records" = "1" ] && ok "re-emit is idempotent — exactly ONE record on journal2 (no duplicate)" \
  || bad "re-emit produced $n_records records (expected 1)"
grep -q 'idempotent no-op' "$S1/reemit.err" && ok "the re-emit reported an idempotent no-op" \
  || ok "re-emit landed no duplicate (idempotent by content)"

# ============================================================================
hr; echo "SUBTEST 5 — a push failure WARNs without failing the panel"; hr
S5="$TR/s5"; mkdir -p "$S5"
# Point the journal remote at a NONEXISTENT bare repo so ensure_clone/clone fails.
out5="$(run_panel "$S5" "$TR/does-not-exist.git" 505 SEAT_MODE=approve GARDEN_PANEL_REPO=acme/widget 2>"$S5/err")"; rc5=$?
[ "$rc5" -eq 0 ] && ok "panel still exits 0 despite the journal being unreachable (best-effort)" \
  || bad "a failed record push failed the panel (exit $rc5)! err: $(cat "$S5/err")"
printf '%s' "$out5" | grep -q 'PASSED' && ok "the panel still un-drafted / announced PASSED" \
  || bad "panel did not complete its terminal step on a record-push failure"
grep -qi 'WARN' "$S5/rundir/record.log" 2>/dev/null && ok "the push failure is a diagnosable WARN (not a silent swallow)" \
  || bad "no WARN captured for the failed push; record.log: $(cat "$S5/rundir/record.log" 2>/dev/null)"

hr
echo "panel-run-record-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
