#!/bin/bash
# timeout-classifier-test.sh — regression guard for the handler runtime bound
# (gardener.sh `timeout --signal=TERM "$GARDEN_HANDLER_TIMEOUT" <handler...>`) and
# its interaction with the transient-vs-real failure classifier.
#
# Today a job handler has no upper runtime bound: a wedged/runaway `claude -p`
# (network hang, infinite tool loop) runs forever, pinning one of the ~100 scarce
# gardener instances and its $BUSY_MARKER — which also stalls every
# deploy-garden.sh quiesce until GARDEN_DEPLOY_DRAIN_TIMEOUT — and after
# GARDEN_CLAIM_TTL the reaper requeues the SAME base while the original handler is
# still running, executing the job concurrently on two gardeners. gardener.sh now
# wraps the handler in `timeout --signal=TERM "$GARDEN_HANDLER_TIMEOUT"` with the
# invariant GARDEN_HANDLER_TIMEOUT < GARDEN_CLAIM_TTL, so no handler outlives the
# reaper's stale-claim window.
#
# The discrimination is deliberate: a genuine external kill (deploy drain) arrives
# as rc=143 and stays transient via is_external_kill_rc, while `timeout`'s own
# rc=124 on expiry is a NON-signal code that falls through to the real-failure
# branch and escalates to the gardener inbox NOW — a true self-hang is surfaced
# immediately instead of silently TTL-requeuing for ~5h.
#
# SUBTEST 1 drives the pure helpers (common.sh) directly: rc=124 is neither an
# external signal-kill nor a transient empty failure, so it is classified REAL.
# SUBTEST 2 is an integration test: it runs the real gardener.sh with a tiny
# GARDEN_HANDLER_TIMEOUT against a stub handler that flushes non-empty output then
# hangs, and asserts (a) the timeout wrapper fired (handler exited rc=124) and
# (b) the failure was escalated to the gardener inbox as kind:error, NOT logged as
# a transient outage.
#
# Usage: timeout-classifier-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env (a live gardener running this test as a board job would
# otherwise splice its own GARDEN_*/JOURNAL_*/SELF_HEAL_* state underneath the
# fixture; see run-test.sh § hermetic baseline).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

# shellcheck source=../common.sh
source "$JOBS/common.sh"

# ============================================================================
hr; echo "SUBTEST 1 — rc=124 (timeout) is classified REAL, not transient"; hr
# 124 is `timeout`'s expiry code: NOT a signal-kill (is_external_kill_rc covers
# only 143/130/137) and NOT a transient empty failure (those are 143/130/137 and
# the offline rc). So whether $capture is empty or not, rc=124 falls through to
# the real-failure escalation branch.
if is_external_kill_rc 124; then
  bad "rc=124 classified as external signal-kill; expected NOT (timeout expiry is a self-hang, not a deploy kill)"
else
  ok "rc=124 → not an external signal-kill (falls through to real-failure branch)"
fi
if is_transient_empty_failure 124; then
  bad "rc=124 classified transient on empty capture; expected REAL (deterministic self-hang)"
else
  ok "rc=124 → not a transient empty failure (escalates now, not after the reaper TTL)"
fi
# Sanity: a genuine deploy-drain kill (143) is still transient, so the bound does
# not mask a legitimate external restart as a real failure.
if is_external_kill_rc 143; then
  ok "rc=143 (deploy-drain SIGTERM) still classified external signal-kill → transient"
else
  bad "rc=143 NOT classified signal-kill; deploy-drain kill would be falsely escalated"
fi

# ============================================================================
hr; echo "SUBTEST 2 — integration: a hung handler is bounded by timeout (rc=124) and escalated REAL"; hr
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-timeout.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
BARE="$TR/journal.git"; BRANCH=journal2
git_id=(-c user.name=test -c user.email=test@localhost)

# Seed a throwaway origin with the board structure + one job.
git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"
( cd "$SEED"
  mkdir -p jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors
  for d in jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors; do touch "$d/.gitkeep"; done
  printf '# hangjob\n\ndo the work for hangjob\n' > "jobs/todo/hangjob.md" )
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m "seed: 1 job + structure"
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH"

# Run the REAL gardener.sh: oneshot, with a 2s handler bound, against a stub that
# flushes non-empty output then hangs forever. The timeout wrapper must fire at 2s
# and the handler must exit rc=124.
env GARDEN_HOST="hanghost" GARDEN_STATE="$TR/state" \
    GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_HANDLER_TIMEOUT=2 \
    GARDEN_JOB_HANDLER="$HERE/timeout-handler-stub.sh" \
    "$JOBS/gardener.sh" 1 > "$TR/gardener.log" 2>&1 || true

CLONE="$TR/state/gardeners/1/journal"

# (a) the timeout wrapper fired — the handler was reported as exiting rc=124.
if grep -Eq "handler FAILED \(rc=124\)|rc=124" "$TR/gardener.log"; then
  ok "hung handler bounded by timeout (handler exited rc=124)"
else
  bad "rc=124 not observed; the timeout wrapper may not have fired. log: $(grep -i 'handler\|working' "$TR/gardener.log" | tail -3)"
fi

# (b) classified REAL: escalated to the gardener inbox, NOT logged transient.
# Match the transient-VERDICT line ("looks transient") specifically — the generic
# "classifying transient-vs-real" log line names rc=124 too but is not a verdict.
if grep -Eq "looks transient \(rc=124" "$TR/gardener.log"; then
  bad "rc=124 falsely logged as a transient outage; expected real-failure escalation"
else
  ok "rc=124 NOT logged as a transient verdict"
fi
if [ -e "$CLONE/inboxes/hanghost/gardener.md" ]; then
  ok "gardener inbox escalation file created (self-hang surfaced now, not TTL-deferred)"
else
  bad "no gardener inbox escalation file; a real rc=124 failure was not escalated"
fi

# (c) a kind:error journal entry referencing the failed handler (the loud path).
nerr=$(grep -rl 'handler FAILED' "$CLONE/entries" 2>/dev/null | grep -c 'error' || true)
if [ "${nerr:-0}" -ge 1 ]; then
  ok "kind:error journal entry emitted for the timed-out handler"
else
  bad "no kind:error journal entry for the timed-out handler"
fi

# (d) the job stays in doin (real failures leave it for the reaper; not completed).
V="$TR/verify"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V" 2>/dev/null
if [ -f "$V/jobs/doin/hangjob.md" ] && [ ! -f "$V/jobs/tada/hangjob.md" ]; then
  ok "job left in doin (not completed to tada on a real failure)"
else
  bad "job not left in doin (doin=$([ -f "$V/jobs/doin/hangjob.md" ] && echo y || echo n) tada=$([ -f "$V/jobs/tada/hangjob.md" ] && echo y || echo n))"
fi

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
