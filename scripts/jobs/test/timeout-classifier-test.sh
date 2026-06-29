#!/bin/bash
# timeout-classifier-test.sh — regression guard for the handler runtime bound
# (gardener.sh `timeout --signal=TERM "$GARDEN_HANDLER_TIMEOUT" <handler...>`) and
# its interaction with the transient-vs-real failure classifier.
#
# A job handler is bounded at a single call site: a wedged/runaway `claude -p`
# (network hang, infinite tool loop) would otherwise run forever, pinning one of the
# ~100 scarce gardener instances and its $BUSY_MARKER — which also stalls every
# deploy-garden.sh quiesce until GARDEN_DEPLOY_DRAIN_TIMEOUT — and after
# GARDEN_CLAIM_TTL the reaper requeues the SAME base while the original handler is
# still running, executing the job concurrently on two gardeners. gardener.sh wraps
# the handler in `timeout --signal=TERM "$GARDEN_HANDLER_TIMEOUT"` with the invariant
# GARDEN_HANDLER_TIMEOUT < GARDEN_CLAIM_TTL, so no handler outlives the reaper's
# stale-claim window.
#
# The discrimination is deliberate: a handler killed by its own timeout wrapper exits
# rc=124, which is conceptually a WALL-CLOCK-TIMEOUT kill — the supervisor wrapper
# terminated it, a fourth external-kill source alongside the OS-signal codes
# (143 deploy/drain SIGTERM, 130 SIGINT, 137 OOM/SIGKILL). is_handler_timeout_rc
# (common.sh) classifies 124 transient ALONGSIDE the signal-kills via
# is_external_kill_rc, so an inherently-long handler (a shepherd driving CI to green
# at the 2400s window — shepherd-kriscendobot-agoric-sdk-pr7) is NOT false-escalated
# to the gardener inbox as a defect on every reaper requeue. It gets ONE kind:progress
# note and stays in doin; a genuinely DEADLOCKED handler still surfaces, because it
# times out every cycle and the reaper's `<!-- garden-reaped: N -->` poison counter
# escalates it as poison after the threshold rather than spamming a real-error.
#
# SUBTEST 1 drives the pure helpers (common.sh) directly: rc=124 is a handler-timeout
# kill (transient) but NOT a signal-kill, while rc=143 is a signal-kill but NOT a
# handler-timeout — the two classifiers are disjoint and complementary.
# SUBTEST 2 is an integration test: it runs the real gardener.sh with a tiny
# GARDEN_HANDLER_TIMEOUT against a stub handler that flushes non-empty output then
# hangs, and asserts (a) the timeout wrapper fired (handler exited rc=124),
# (b) the failure was logged as a transient outage and NOT escalated to the gardener
# inbox as kind:error, and (c) the job was left in doin for the reaper.
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
hr; echo "SUBTEST 1 — rc=124 (timeout) is classified TRANSIENT via is_handler_timeout_rc"; hr
# 124 is `timeout`'s expiry code: a dedicated WALL-CLOCK-TIMEOUT classification
# (is_handler_timeout_rc), kept disjoint from is_external_kill_rc (signal codes
# 143/130/137 only) so each helper stays semantically pure. gardener.sh branches
# is_handler_timeout_rc into the SAME transient path as the signal-kills, BEFORE the
# empty/non-empty capture split, so capture content is irrelevant for rc=124.
if is_handler_timeout_rc 124; then
  ok "rc=124 → handler-timeout kill (transient: ONE progress note, no inbox escalation)"
else
  bad "rc=124 NOT classified as a handler-timeout kill; an inherently-long handler would be false-escalated every cycle"
fi
if is_external_kill_rc 124; then
  bad "rc=124 classified as an OS signal-kill; expected NOT (124 is timeout's own code, handled by is_handler_timeout_rc)"
else
  ok "rc=124 → not an OS signal-kill (the two classifiers are disjoint)"
fi
# The dedicated timeout branch precedes the empty-capture test, so is_transient_empty_failure
# never sees 124; assert it stays unchanged (124 absent) so the helpers don't overlap.
if is_transient_empty_failure 124; then
  bad "is_transient_empty_failure now matches 124; expected unchanged (124 is handled by the dedicated timeout branch)"
else
  ok "rc=124 → not in is_transient_empty_failure (handled earlier by is_handler_timeout_rc)"
fi
# Complementary direction: a genuine signal-kill is NOT a handler-timeout, and is
# still transient via is_external_kill_rc.
if is_handler_timeout_rc 143; then
  bad "rc=143 classified as a handler-timeout; expected NOT (143 is a deploy-drain SIGTERM, handled by is_external_kill_rc)"
else
  ok "rc=143 → not a handler-timeout (a signal-kill, classified by is_external_kill_rc)"
fi
if is_external_kill_rc 143; then
  ok "rc=143 (deploy-drain SIGTERM) still classified external signal-kill → transient"
else
  bad "rc=143 NOT classified signal-kill; deploy-drain kill would be falsely escalated"
fi

# ============================================================================
hr; echo "SUBTEST 2 — integration: a hung handler is bounded by timeout (rc=124) and classified TRANSIENT"; hr
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
env GARDEN="hanghost" GARDEN_STATE="$TR/state" \
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

# (b) classified TRANSIENT: logged as a transient outage, NOT escalated. Match the
# transient-VERDICT line ("looks transient") specifically — the generic
# "classifying transient-vs-real" log line names rc=124 too but is not a verdict.
if grep -Eq "looks transient \(rc=124" "$TR/gardener.log"; then
  ok "rc=124 logged as a transient handler outage (no per-cycle real-error escalation)"
else
  bad "rc=124 NOT logged as a transient verdict; an inherently-long handler would be false-escalated"
fi

# (c) NOT escalated to the gardener inbox as a real failure.
if [ -e "$CLONE/inboxes/hanghost/gardener.md" ]; then
  bad "gardener inbox escalation file created; expected NONE (a wall-clock timeout is transient, not a defect)"
else
  ok "no gardener inbox escalation file (timeout is transient; reaper poison-counter surfaces a genuine deadlock)"
fi

# (d) NO kind:error journal entry for the timed-out handler (the loud path is skipped);
# instead a kind:progress transient note is emitted.
nerr=$(grep -rl 'handler FAILED' "$CLONE/entries" 2>/dev/null | grep -c 'error' || true)
if [ "${nerr:-0}" -eq 0 ]; then
  ok "no kind:error journal entry emitted for the timed-out handler"
else
  bad "kind:error journal entry emitted for a rc=124 timeout; expected only a kind:progress transient note"
fi
nprog=$(grep -rl 'transient handler outage' "$CLONE/entries" 2>/dev/null | grep -c 'progress' || true)
if [ "${nprog:-0}" -ge 1 ]; then
  ok "kind:progress transient-outage note emitted for the timed-out handler"
else
  bad "no kind:progress transient-outage note for the timed-out handler"
fi

# (e) the job stays in doin (transient failures leave it for the reaper; not completed).
V="$TR/verify"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V" 2>/dev/null
if [ -f "$V/jobs/doin/hangjob.md" ] && [ ! -f "$V/jobs/tada/hangjob.md" ]; then
  ok "job left in doin (not completed to tada on a timeout)"
else
  bad "job not left in doin (doin=$([ -f "$V/jobs/doin/hangjob.md" ] && echo y || echo n) tada=$([ -f "$V/jobs/tada/hangjob.md" ] && echo y || echo n))"
fi

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
