#!/bin/bash
# completion-signal-test.sh — regression guard for the DETERMINISTIC job-completion
# signal (common.sh § job completion signal; gardener.sh doin→tada gate).
#
# THE GAP THIS CLOSES: completion used to be gated on the handler EXIT CODE, not on
# real completion — gardener.sh ran complete-job.sh (doin→tada) whenever the handler
# exited 0, and complete-job.sh moved the job with no validation. So a `claude` that
# exited 0 WITHOUT finishing — quota/usage cut mid-response, an API error swallowed
# to a clean exit, or a run that just "did not reach a satisfying conclusion" — was
# recorded as DONE and lost in tada, where the reaper never requeues it.
#
# THE FIX: the worker emits an explicit completion signal (GARDEN_COMPLETION_MARKER
# as its report's final line) as its final deterministic act; the handler confirms
# it and writes the completion sentinel (GARDEN_COMPLETION_SENTINEL); gardener.sh
# completes the job ONLY if that sentinel is present. If the handler exits with ANY
# code and the sentinel is ABSENT, gardener.sh requeues the job (via the reaper's
# single-writer reap-now path) instead of completing it — bounded by the doom
# counter so a job that never completes escalates to the maintainer, never loops
# forever.
#
# SUBTEST 1 — pure helpers report_has_completion_marker / strip_completion_marker.
# SUBTEST 2 — (b) handler exits 0 WITH the signal → job completed to tada.
# SUBTEST 2A — an exact orchestration-failure signal is mechanically stamped
#              into leading frontmatter and removed from the human report.
# SUBTEST 3 — (a) handler exits 0 WITHOUT the signal → NOT in tada; left in doin
#             with a reap-now hint; the reaper then requeues it doin→todo.
# SUBTEST 4 — (c) each of the four named exit modes (API error / rate limit / quota
#             / clean-but-unsatisfying exit-0) → requeue, NOT tada; and the requeue
#             is BOUNDED by the doom threshold (a job that never completes is
#             dropped from the board and surfaced to the maintainer, not requeued
#             forever).
#
# Usage: completion-signal-test.sh
set -euo pipefail
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env (a live gardener running this test as a board job would
# otherwise splice its own GARDEN_*/JOURNAL_* state underneath the fixture).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

# shellcheck source=../common.sh
source "$JOBS/common.sh"

STUB="$HERE/completion-signal-handler-stub.sh"

# seed_board <dir> <base> — make a throwaway origin with the board structure and
# one todo job named <base>; echoes the bare-repo path. Each subtest gets its own.
seed_board() {
  local tr="$1" base="$2" bare="$1/journal.git" seed="$1/seed" branch=journal2
  local -a git_id=(-c user.name=test -c user.email=test@localhost)
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$branch"
  ( cd "$seed"
    mkdir -p jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors
    for d in jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors; do touch "$d/.gitkeep"; done
    printf '# %s\n\ndo the work for %s\n' "$base" "$base" > "jobs/todo/$base.md" )
  git -C "$seed" add -A
  git -C "$seed" "${git_id[@]}" commit -q -m "seed: 1 job + structure"
  git -C "$seed" remote add origin "$bare"
  git -C "$seed" push -q -u origin "$branch"
  printf '%s\n' "$bare"
}

# ============================================================================
hr; echo "SUBTEST 1 — pure helpers: marker detection is last-line-anchored, strip is clean"; hr
T1="$(mktemp -d "${TMPDIR:-/tmp}/garden-compsig1.XXXXXX")"; trap 'rm -rf "$T1"' EXIT

r="$T1/r"
printf 'did the work\nchanged files\n%s\n' "$GARDEN_COMPLETION_MARKER" > "$r"
report_has_completion_marker "$r" && ok "marker as the last line → completion detected" \
  || bad "marker as last line not detected"

printf 'did the work\n%s\nthen kept talking\n' "$GARDEN_COMPLETION_MARKER" > "$r"
report_has_completion_marker "$r" && bad "marker mid-report forged completion (must be last line only)" \
  || ok "marker mid-report does NOT count (last-line-anchored, unforgeable)"

printf 'did the work\nno marker here\n' > "$r"
report_has_completion_marker "$r" && bad "absent marker falsely detected" \
  || ok "absent marker → not complete"

# trailing blanks after the marker still count (worker's final act + a newline)
printf 'work\n%s\n\n\n' "$GARDEN_COMPLETION_MARKER" > "$r"
report_has_completion_marker "$r" && ok "marker followed by trailing blanks still detected" \
  || bad "trailing blanks after the marker defeated detection"

# strip removes the marker (and surrounding trailing blanks) but keeps the body
printf 'line one\nline two\n\n%s\n\n' "$GARDEN_COMPLETION_MARKER" > "$r"
strip_completion_marker "$r"
{ grep -qxF 'line one' "$r" && grep -qxF 'line two' "$r" && ! grep -qF "$GARDEN_COMPLETION_MARKER" "$r"; } \
  && ok "strip drops the marker line, preserves the report body" \
  || bad "strip damaged the body or left the marker ($(tr '\n' '|' <"$r"))"

printf 'work finished without the gated outcome\n%s\n' "$GARDEN_ORCHESTRATION_FAILURE_MARKER" > "$r"
report_has_orchestration_failure_marker "$r" \
  && ok "exact final failure signal is detected for mechanical stamping" \
  || bad "exact final failure signal was missed"
printf '%s\n' "$GARDEN_ORCHESTRATION_FAILURE_MARKER" 'more prose' > "$r"
report_has_orchestration_failure_marker "$r" \
  && bad "mid-report failure signal was accepted" \
  || ok "failure signal is last-line-anchored"
printf 'partial\n%s\n' '<<<GARDEN-JOB-HANDED-OFF: successor-job>>>' > "$r"
[ "$(report_handoff_successor "$r")" = successor-job ] \
  && ok "exact final handoff signal yields its successor basename" \
  || bad "handoff signal was not parsed"
printf '%s\n' '<<<GARDEN-JOB-HANDED-OFF: successor-job>>>' 'more prose' > "$r"
report_handoff_successor "$r" >/dev/null \
  && bad "mid-report handoff signal was accepted" \
  || ok "handoff signal is last-line-anchored"

# ============================================================================
hr; echo "SUBTEST 2 — (b) handler exits 0 WITH the signal → completed to tada"; hr
T2="$(mktemp -d "${TMPDIR:-/tmp}/garden-compsig2.XXXXXX")"
BARE2="$(seed_board "$T2" donejob)"
env GARDEN="okhost" GARDEN_STATE="$T2/state" JOURNAL_REMOTE="$BARE2" JOURNAL_BRANCH=journal2 \
    GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 \
    GARDEN_STUB_RC=0 GARDEN_STUB_SIGNAL=1 \
    GARDEN_JOB_HANDLER="$STUB" \
    "$JOBS/gardener.sh" 1 > "$T2/gardener.log" 2>&1 || true
V2="$T2/verify"; git clone -q --single-branch --branch journal2 "$BARE2" "$V2" 2>/dev/null
{ [ -f "$V2/jobs/tada/donejob.md" ] && [ ! -e "$V2/jobs/doin/donejob.md" ] && [ ! -e "$V2/jobs/todo/donejob.md" ]; } \
  && ok "signaled completion moved the job doin→tada" \
  || bad "signaled job not in tada (tada=$([ -f "$V2/jobs/tada/donejob.md" ] && echo y || echo n) doin=$([ -e "$V2/jobs/doin/donejob.md" ] && echo y || echo n) todo=$([ -e "$V2/jobs/todo/donejob.md" ] && echo y || echo n))"
rm -rf "$T2"

# ============================================================================
hr; echo "SUBTEST 2A — orchestration failure signal → mechanically stamped frontmatter"; hr
T2A="$(mktemp -d "${TMPDIR:-/tmp}/garden-compsig2a.XXXXXX")"
BARE2A="$(seed_board "$T2A" failedchild)"
env GARDEN="failhost" GARDEN_STATE="$T2A/state" JOURNAL_REMOTE="$BARE2A" JOURNAL_BRANCH=journal2 \
    GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 \
    GARDEN_STUB_RC=0 GARDEN_STUB_SIGNAL=1 GARDEN_STUB_ORCHESTRATION_FAILED=1 \
    GARDEN_JOB_HANDLER="$STUB" \
    "$JOBS/gardener.sh" 1 > "$T2A/gardener.log" 2>&1 || true
V2A="$T2A/verify"; git clone -q --single-branch --branch journal2 "$BARE2A" "$V2A" 2>/dev/null
{ [ -f "$V2A/jobs/tada/failedchild.md" ] \
  && sed -n '1,3p' "$V2A/jobs/tada/failedchild.md" | grep -qx 'orchestration-failed: true' \
  && ! grep -qF "$GARDEN_ORCHESTRATION_FAILURE_MARKER" "$V2A/jobs/tada/failedchild.md" \
  && tada_failed "$V2A/jobs/tada/failedchild.md"; } \
  && ok "gardener/complete-job translated the exact signal into parsed frontmatter" \
  || bad "failure signal was not translated cleanly ($(sed -n '1,8p' "$V2A/jobs/tada/failedchild.md" 2>/dev/null | tr '\n' '|'))"
rm -rf "$T2A"

# ============================================================================
hr; echo "SUBTEST 2B: evidenced handoff signal becomes a mechanically stamped partial disposition"; hr
T2B="$(mktemp -d "${TMPDIR:-/tmp}/garden-compsig2b.XXXXXX")"
BARE2B="$(seed_board "$T2B" handoffjob)"
U2B="$T2B/update"; git clone -q --single-branch --branch journal2 "$BARE2B" "$U2B"
printf 'successor owns the remainder\n' > "$U2B/jobs/todo/successor-job.md"
git -C "$U2B" add jobs/todo/successor-job.md
git -C "$U2B" -c user.name=test -c user.email=test@localhost commit -q -m 'post successor'
git -C "$U2B" push -q origin HEAD:journal2
env GARDEN="handoffhost" GARDEN_STATE="$T2B/state" JOURNAL_REMOTE="$BARE2B" JOURNAL_BRANCH=journal2 \
    GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_STUB_RC=0 GARDEN_STUB_SIGNAL=1 \
    GARDEN_STUB_HANDOFF_SUCCESSOR=successor-job GARDEN_JOB_HANDLER="$STUB" \
    "$JOBS/gardener.sh" 1 > "$T2B/gardener.log" 2>&1 || true
V2B="$T2B/verify"; git clone -q --single-branch --branch journal2 "$BARE2B" "$V2B" 2>/dev/null
{ [ -f "$V2B/jobs/tada/handoffjob.md" ] \
  && sed -n '1,4p' "$V2B/jobs/tada/handoffjob.md" | grep -qx 'handed-off: successor-job' \
  && sed -n '1,4p' "$V2B/jobs/tada/handoffjob.md" | grep -qx 'deliverable-complete: false' \
  && ! grep -qF '<<<GARDEN-JOB-HANDED-OFF:' "$V2B/jobs/tada/handoffjob.md"; } \
  && ok "gardener/complete-job translated an evidenced handoff into partial-disposition frontmatter" \
  || bad "handoff signal was not translated cleanly ($(sed -n '1,8p' "$V2B/jobs/tada/handoffjob.md" 2>/dev/null | tr '\n' '|'))"
rm -rf "$T2B"

# ============================================================================
hr; echo "SUBTEST 2C: an unposted handoff is rejected and remains unfinished"; hr
T2C="$(mktemp -d "${TMPDIR:-/tmp}/garden-compsig2c.XXXXXX")"
BARE2C="$(seed_board "$T2C" unevidenced)"
env GARDEN="handoffhost" GARDEN_STATE="$T2C/state" JOURNAL_REMOTE="$BARE2C" JOURNAL_BRANCH=journal2 \
    GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_STUB_RC=0 GARDEN_STUB_SIGNAL=1 \
    GARDEN_STUB_HANDOFF_SUCCESSOR=missing-successor GARDEN_JOB_HANDLER="$STUB" \
    "$JOBS/gardener.sh" 1 > "$T2C/gardener.log" 2>&1 || true
V2C="$T2C/verify"; git clone -q --single-branch --branch journal2 "$BARE2C" "$V2C" 2>/dev/null
{ [ -f "$V2C/jobs/doin/unevidenced.md" ] \
  && [ ! -e "$V2C/jobs/tada/unevidenced.md" ] \
  && grep -q "not durably posted" "$T2C/gardener.log"; } \
  && ok "missing successor blocked the handoff completion and left the claim unfinished" \
  || bad "unevidenced handoff escaped the durable-successor gate"
rm -rf "$T2C"

# ============================================================================
hr; echo "SUBTEST 3 — (a) handler exits 0 WITHOUT the signal → requeued, NOT tada"; hr
T3="$(mktemp -d "${TMPDIR:-/tmp}/garden-compsig3.XXXXXX")"
BARE3="$(seed_board "$T3" gapjob)"
env GARDEN="gaphost" GARDEN_STATE="$T3/state" JOURNAL_REMOTE="$BARE3" JOURNAL_BRANCH=journal2 \
    GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 \
    GARDEN_STUB_RC=0 GARDEN_STUB_SIGNAL=0 \
    GARDEN_JOB_HANDLER="$STUB" \
    "$JOBS/gardener.sh" 1 > "$T3/gardener.log" 2>&1 || true

# The gardener must NOT complete it (the whole point): not in tada, left in doin.
V3="$T3/verify"; git clone -q --single-branch --branch journal2 "$BARE3" "$V3" 2>/dev/null
{ [ ! -e "$V3/jobs/tada/gapjob.md" ] && [ -f "$V3/jobs/doin/gapjob.md" ]; } \
  && ok "exit-0-without-signal NOT completed to tada; left in doin" \
  || bad "exit-0-no-signal mishandled (tada=$([ -e "$V3/jobs/tada/gapjob.md" ] && echo y || echo n) doin=$([ -f "$V3/jobs/doin/gapjob.md" ] && echo y || echo n))"
grep -q 'exit-0-unsatisfying' "$T3/gardener.log" \
  && ok "gardener logged the exit-0-unsatisfying requeue path" \
  || bad "gardener did not log the exit-0-unsatisfying path ($(grep -i 'handler' "$T3/gardener.log" | tail -2))"
if [ -f "$V3/jobs/doin/gapjob.md" ] && grep -Eq '^<!-- garden-reap-now -->$' "$V3/jobs/doin/gapjob.md"; then
  ok "exit-0-no-signal stamped a reap-now hint (reaper requeues before TTL)"
else
  bad "no reap-now hint on the doin claim (job would idle the full TTL)"
fi

# The reaper then requeues it doin→todo (the deterministic requeue completes).
env GARDEN="reaphost" GARDEN_STATE="$T3/reaper-state" GARDEN_CLAIM_TTL=3600 \
    JOURNAL_REMOTE="$BARE3" JOURNAL_BRANCH=journal2 \
    "$JOBS/reaper.sh" > "$T3/reaper.log" 2>&1 || true
R3="$T3/reaper-verify"; git clone -q --single-branch --branch journal2 "$BARE3" "$R3" 2>/dev/null
{ [ -f "$R3/jobs/todo/gapjob.md" ] && [ ! -e "$R3/jobs/doin/gapjob.md" ]; } \
  && ok "reaper requeued the exit-0-unsatisfying job doin→todo" \
  || bad "reaper did not requeue (todo=$([ -f "$R3/jobs/todo/gapjob.md" ] && echo y || echo n) doin=$([ -e "$R3/jobs/doin/gapjob.md" ] && echo y || echo n))"
[ -f "$R3/jobs/todo/gapjob.md" ] && grep -Eq '^<!-- garden-reaped: 1 -->$' "$R3/jobs/todo/gapjob.md" \
  && ok "requeue stamped the doom-cycle counter (garden-reaped: 1)" \
  || bad "doom-cycle counter not stamped (would bypass the doom bound)"
rm -rf "$T3"

# ============================================================================
hr; echo "SUBTEST 4 — (c) all four exit modes → requeue, bounded by the doom threshold"; hr
# Drive each named mode through the REAL gardener and assert it is requeued
# (not completed to tada). API error / rate limit / quota are non-zero with a
# transient claude signature in the capture; exit-0-unsatisfying is the new clean
# exit-0 path. All four leave the job in doin with a reap-now hint.
run_mode() {  # run_mode <label> <base> <rc> <signal> <capture>
  local label="$1" base="$2" rc="$3" sig="$4" cap="$5"
  local tr bare
  tr="$(mktemp -d "${TMPDIR:-/tmp}/garden-compsig4.XXXXXX")"
  bare="$(seed_board "$tr" "$base")"
  # GARDEN_MIN_PLAUSIBLE_OVERRUN_SECS=0 disables the very-short-elapsed floor: these
  # stubs emit a transient signature and exit INSTANTLY (a test artifact), so with the
  # floor live the sub-floor elapsed would reclassify them a real failure. This subtest
  # isolates the SIGNATURE→transient-requeue classification, an axis orthogonal to
  # elapsed; the floor has its own guard in elapsed-constancy-classifier-test.sh.
  env GARDEN="modehost" GARDEN_STATE="$tr/state" JOURNAL_REMOTE="$bare" JOURNAL_BRANCH=journal2 \
      GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_MIN_PLAUSIBLE_OVERRUN_SECS=0 \
      GARDEN_STUB_RC="$rc" GARDEN_STUB_SIGNAL="$sig" GARDEN_STUB_CAPTURE="$cap" \
      GARDEN_JOB_HANDLER="$STUB" \
      "$JOBS/gardener.sh" 1 > "$tr/gardener.log" 2>&1 || true
  local v="$tr/verify"; git clone -q --single-branch --branch journal2 "$bare" "$v" 2>/dev/null
  if [ ! -e "$v/jobs/tada/$base.md" ] && [ -f "$v/jobs/doin/$base.md" ] \
       && grep -Eq '^<!-- garden-reap-now -->$' "$v/jobs/doin/$base.md"; then
    ok "$label → requeued (not tada; left in doin with a reap-now hint)"
  else
    bad "$label → NOT requeued as expected (tada=$([ -e "$v/jobs/tada/$base.md" ] && echo y || echo n) doin=$([ -f "$v/jobs/doin/$base.md" ] && echo y || echo n) hint=$([ -f "$v/jobs/doin/$base.md" ] && grep -Eq '^<!-- garden-reap-now -->$' "$v/jobs/doin/$base.md" && echo y || echo n))"
  fi
  rm -rf "$tr"
}
run_mode "API error (rc=1, 5xx signature)"        apierr  1 0 "Error: api error (HTTP 500) from the model endpoint"
run_mode "rate limit (rc=1, 429 signature)"       ratelim 1 0 "Error: rate limit exceeded (429), retry later"
run_mode "quota exhaustion (rc=1, usage-limit)"   quota   1 0 "You have hit your usage limit; resets 3pm (UTC)"
run_mode "clean-but-unsatisfying exit-0"          unsat   0 0 ""

# --- doom bound: a job that NEVER completes is dropped, not requeued forever --
hr; echo "  doom bound — a never-completing job escalates after the threshold"; hr
TP="$(mktemp -d "${TMPDIR:-/tmp}/garden-compsig-doom.XXXXXX")"
BAREP="$(seed_board "$TP" doomjob)"
THRESH=3
# Loop the gardener+reaper cycle: each round the gardener claims and exits-0-without-
# signal (requeue), the reaper requeues doin→todo and increments the doom counter.
# After THRESH cycles the reaper must DROP the job (not requeue) and surface it to
# the maintainer inbox.
for cycle in $(seq 1 "$THRESH"); do
  env GARDEN="doomhost" GARDEN_STATE="$TP/state" JOURNAL_REMOTE="$BAREP" JOURNAL_BRANCH=journal2 \
      GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 \
      GARDEN_STUB_RC=0 GARDEN_STUB_SIGNAL=0 \
      GARDEN_JOB_HANDLER="$STUB" \
      "$JOBS/gardener.sh" 1 > "$TP/gardener-$cycle.log" 2>&1 || true
  env GARDEN="doomreaper" GARDEN_STATE="$TP/reaper-state" GARDEN_CLAIM_TTL=3600 \
      GARDEN_REAP_DOOM_THRESHOLD="$THRESH" GARDEN_NO_MAINTAINER_ALERT= \
      JOURNAL_REMOTE="$BAREP" JOURNAL_BRANCH=journal2 \
      "$JOBS/reaper.sh" > "$TP/reaper-$cycle.log" 2>&1 || true
done
VP="$TP/verify"; git clone -q --single-branch --branch journal2 "$BAREP" "$VP" 2>/dev/null
# After the doom threshold the job is neither requeued (not in todo/doin) nor
# completed (not in tada) — it is PARKED in plan/ under a held gate so the work
# survives for a human to resume, rather than being dropped from the board.
{ [ ! -e "$VP/jobs/todo/doomjob.md" ] && [ ! -e "$VP/jobs/doin/doomjob.md" ] && [ ! -e "$VP/jobs/tada/doomjob.md" ] \
  && [ -f "$VP/jobs/plan/doomjob.md" ]; } \
  && ok "a job that never completes is PARKED in plan/ (held) after the doom threshold (not requeued, not in tada, not dropped)" \
  || bad "never-completing job not parked in plan/ (todo=$([ -e "$VP/jobs/todo/doomjob.md" ] && echo y || echo n) doin=$([ -e "$VP/jobs/doin/doomjob.md" ] && echo y || echo n) tada=$([ -e "$VP/jobs/tada/doomjob.md" ] && echo y || echo n) plan=$([ -f "$VP/jobs/plan/doomjob.md" ] && echo y || echo n))"
# The alert is surfaced to the maintainer via doom-notice.sh (an amend-or-post
# keyed sibling of inbox-send.sh): it lands in inbox/maintainer/unread. The intent
# is preserved — "never silently lost" is the guarantee.
pmsg="$(grep -rl 'doomjob' "$VP/inbox" 2>/dev/null | head -1)"
{ [ -n "$pmsg" ] && grep -qi 'DOOM' "$pmsg"; } \
  && ok "the never-completing job was surfaced to the maintainer as DOOM (never silently lost)" \
  || bad "no doom alert surfaced for the never-completing job (inbox tree: $(find "$VP/inbox" -type f 2>/dev/null | tr '\n' ' '))"
rm -rf "$TP"

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
