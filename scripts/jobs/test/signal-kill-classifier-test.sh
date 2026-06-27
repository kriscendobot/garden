#!/bin/bash
# signal-kill-classifier-test.sh — regression guard for the signal-kill branch of
# the gardener handler-failure classifier (gardener.sh transient-vs-real decision).
#
# Regression: the classifier only treated signal-kill exit codes (143 SIGTERM /
# 137 SIGKILL/OOM / 130 SIGINT) as transient on the EMPTY-$capture branch (via
# is_transient_empty_failure). A gardener killed mid-job that had already flushed
# partial output to $capture (progress lines, or the folded tail of $report)
# skipped that branch and was falsely escalated to the gardener inbox as a
# kind:error REAL failure — exactly what happened on 2026-06-27 to job
# garden-deliberate-deploy-no-shared-tree-development (rc=143, escalated). An
# external signal-kill is never a deterministic job defect (deploy-window restart,
# drain-fleet, OOM, shutdown, or claim-TTL kill); the reaper already requeues the
# job after GARDEN_CLAIM_TTL. The fix classifies a signal-kill rc as transient
# BEFORE the `[ ! -s "$capture" ]` empty/non-empty split, so capture content is
# irrelevant for these codes.
#
# SUBTEST 1 drives the pure helper is_external_kill_rc (common.sh) directly,
# mirroring empty-output-classifier-test.sh's pure-helper coverage. SUBTEST 2 is
# an integration test: it runs the real gardener.sh against a throwaway board with
# a stub handler that exits rc=143 AFTER writing NON-EMPTY output, and asserts the
# job is logged as a transient outage (kind:progress, no inbox escalation, left in
# doin) rather than escalated as kind:error.
#
# Usage: signal-kill-classifier-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env (a live gardener running this test as a board job would
# otherwise splice its own GARDEN_*/JOURNAL_*/SELF_HEAL_* state — clone, remote,
# offline rc — underneath the fixture; see run-test.sh § hermetic baseline).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

# shellcheck source=../common.sh
source "$JOBS/common.sh"

# ============================================================================
hr; echo "SUBTEST 1 — is_external_kill_rc: signal codes only, capture-agnostic"; hr
assert_kill()   { if is_external_kill_rc "$1"; then ok "rc=$1 → external signal-kill ($2)"; else bad "rc=$1 NOT classified signal-kill; expected kill ($2)"; fi; }
assert_nokill() { if is_external_kill_rc "$1"; then bad "rc=$1 classified signal-kill; expected not ($2)"; else ok "rc=$1 → not a signal-kill ($2)"; fi; }
assert_kill 143 "SIGTERM — systemd stop / deploy-window restart / drain"
assert_kill 130 "SIGINT"
assert_kill 137 "SIGKILL — OOM / hard kill / claim-TTL reaper"
# The offline rc is deliberately NOT a signal-kill: it stays gated on its own
# paths (sync_clone clean-skip, the empty-capture branch), not this helper.
assert_nokill "${GARDEN_OFFLINE_RC:-75}" "offline rc is connectivity, not a process kill"
assert_nokill 127 "missing external tool — the jq-outage signature, deterministic"
assert_nokill 126 "non-executable external tool, deterministic"
assert_nokill 1   "bare failure, deterministic"
assert_nokill 0   "success is not a kill"

# ============================================================================
hr; echo "SUBTEST 2 — integration: rc=143 with NON-EMPTY capture → transient, no escalation"; hr
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-signalkill.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
BARE="$TR/journal.git"; BRANCH=journal2
git_id=(-c user.name=test -c user.email=test@localhost)

# Seed a throwaway origin with the board structure + one job.
git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"
( cd "$SEED"
  mkdir -p jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors
  for d in jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors; do touch "$d/.gitkeep"; done
  printf '# killjob\n\ndo the work for killjob\n' > "jobs/todo/killjob.md" )
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m "seed: 1 job + structure"
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH"

# Run the REAL gardener.sh: oneshot, stub handler that exits 143 AFTER writing
# non-empty stdout + $report (so $capture is non-empty when the classifier runs).
env GARDEN_HOST="killhost" GARDEN_STATE="$TR/state" \
    GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_STUB_RC=143 \
    GARDEN_STUB_SENTINEL="$TR/sentinel" \
    GARDEN_JOB_HANDLER="$HERE/signal-kill-handler-stub.sh" \
    "$JOBS/gardener.sh" 1 > "$TR/gardener.log" 2>&1 || true

CLONE="$TR/state/gardeners/1/journal"

# (a) the handler genuinely ran and flushed NON-EMPTY output (to its stdout, which
# gardener.sh diverts into $capture, AND to $report) before exiting 143 — so the
# classifier saw a NON-EMPTY $capture, the path this fix is about. The gardener
# discards $capture on a transient verdict, so we observe the flush via the stub's
# side sentinel instead of the gardener log.
if [ -s "$TR/sentinel" ]; then
  ok "handler ran and flushed non-empty output before the kill (non-empty-capture path exercised)"
else
  bad "handler sentinel empty/absent; non-empty-capture path may not have run"
fi

# (b) classified TRANSIENT: the gardener logged the transient-outage line for rc=143.
if grep -Eq "transient.*rc=143|rc=143.*transient" "$TR/gardener.log"; then
  ok "rc=143 with non-empty capture logged as transient outage"
else
  bad "rc=143 with non-empty capture NOT logged transient; log: $(grep -i 'handler' "$TR/gardener.log" | tail -2)"
fi

# (c) NO inbox escalation: report-error.sh appends to <clone>/inboxes/<host>/gardener.md;
# a transient classification must NOT create it.
if [ -e "$CLONE/inboxes/killhost/gardener.md" ]; then
  bad "gardener inbox escalation file created — signal-kill was falsely escalated"
else
  ok "no gardener inbox escalation file (signal-kill not escalated)"
fi

# (d) NO kind:error journal entry referencing the job (the loud escalation path
# emits journal-entry.sh error); a transient note is kind:progress instead.
nerr=$(grep -rl 'handler FAILED' "$CLONE/entries" 2>/dev/null | grep -c 'error' || true)
if [ "${nerr:-0}" -eq 0 ]; then
  ok "no kind:error journal entry for the failed handler"
else
  bad "$nerr kind:error journal entr(y/ies) emitted for a signal-killed handler"
fi

# (e) the job stays in doin for the reaper's TTL requeue (not completed to tada,
# not escalated away).
V="$TR/verify"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V" 2>/dev/null
if [ -f "$V/jobs/doin/killjob.md" ] && [ ! -f "$V/jobs/tada/killjob.md" ]; then
  ok "job left in doin (TTL requeue), not completed to tada"
else
  bad "job not left in doin (doin=$([ -f "$V/jobs/doin/killjob.md" ] && echo y || echo n) tada=$([ -f "$V/jobs/tada/killjob.md" ] && echo y || echo n))"
fi

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
