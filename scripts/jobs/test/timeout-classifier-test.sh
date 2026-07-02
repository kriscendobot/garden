#!/bin/bash
# timeout-classifier-test.sh — regression guard for the handler runtime bound
# (gardener.sh
#  `timeout --signal=TERM --kill-after="$GARDEN_HANDLER_KILL_AFTER" "$GARDEN_HANDLER_TIMEOUT" <handler...>`)
# and its interaction with the transient-vs-real failure classifier.
#
# A job handler is bounded at a single call site: a wedged/runaway `claude -p`
# (network hang, infinite tool loop) would otherwise run forever, pinning one of the
# ~100 scarce gardener instances and its $BUSY_MARKER — which also stalls every
# deploy-garden.sh quiesce until GARDEN_DEPLOY_DRAIN_TIMEOUT — and after
# GARDEN_CLAIM_TTL the reaper requeues the SAME base while the original handler is
# still running, executing the job concurrently on two gardeners. gardener.sh wraps
# the handler in `timeout --signal=TERM --kill-after=<grace> "$GARDEN_HANDLER_TIMEOUT"`
# with the invariant GARDEN_HANDLER_TIMEOUT + GARDEN_HANDLER_KILL_AFTER <
# GARDEN_CLAIM_TTL. The --kill-after grace is what makes the bound HARD: a handler
# that IGNORES SIGTERM (a hard deadlock, or a child wedged in an uninterruptible
# state) would, under a bare `timeout`, block the wrapper forever and wedge the
# worker past GARDEN_HANDLER_TIMEOUT; --kill-after escalates to an unconditional
# SIGKILL after the grace, so no handler outlives the reaper's stale-claim window.
#
# The discrimination is deliberate, and BOTH expiry paths are transient. A handler
# that RESPECTS SIGTERM dies at the deadline and `timeout` reports rc=124 — a
# WALL-CLOCK-TIMEOUT kill (the supervisor wrapper terminated it), which
# is_handler_timeout_rc (common.sh) classifies transient ALONGSIDE the OS-signal
# kills is_external_kill_rc covers (143 deploy/drain SIGTERM, 130 SIGINT, 137
# OOM/SIGKILL). A handler that IGNORES SIGTERM is SIGKILLed by --kill-after and
# surfaces as rc=137, already an external signal-kill transient via
# is_external_kill_rc. Either way an inherently-long handler (a shepherd driving CI
# to green at the 2400s window — shepherd-kriscendobot-agoric-sdk-pr7) is NOT
# false-escalated to the gardener inbox as a defect on every reaper requeue: it gets
# ONE kind:progress note and stays in doin. A genuinely DEADLOCKED handler still
# surfaces, because it times out every cycle and the reaper's
# `<!-- garden-reaped: N -->` poison counter escalates it as poison after the
# threshold rather than spamming a real-error.
#
# SUBTEST 1 drives the pure helpers (common.sh) directly: rc=124 is a handler-timeout
# kill (transient) but NOT a signal-kill, while rc=143 and rc=137 are signal-kills
# but NOT handler-timeouts — the two classifiers are disjoint and complementary.
# SUBTEST 2 is an integration test for the SIGTERM-RESPECTING path: it runs the real
# gardener.sh with a tiny GARDEN_HANDLER_TIMEOUT against a stub that flushes non-empty
# output then hangs, and asserts (a) the timeout wrapper fired (handler exited
# rc=124), (b) the failure was logged as a transient outage and NOT escalated to the
# gardener inbox as kind:error, and (c) the job was left in doin for the reaper.
# SUBTEST 3 is an integration test for the SIGTERM-IGNORING path (the wedge the grace
# closes): it runs the real gardener.sh against a stub that swallows SIGTERM, and
# asserts the worker RETURNS (an outer timeout does not fire), the --kill-after kill
# surfaces as rc=137, and it is classified transient (no inbox escalation, job left
# in doin).
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
# The --kill-after SIGKILL escalation (the new HARD bound for a SIGTERM-ignoring
# handler) surfaces as rc=137 — an external signal-kill, so it stays transient via
# is_external_kill_rc (and is NOT a handler-timeout 124). No new branch is needed.
if is_external_kill_rc 137; then
  ok "rc=137 (--kill-after SIGKILL escalation) classified external signal-kill → transient"
else
  bad "rc=137 NOT classified signal-kill; a kill-after escalation would be falsely escalated as a real failure"
fi
if is_handler_timeout_rc 137; then
  bad "rc=137 classified as a handler-timeout; expected NOT (137 is a SIGKILL, handled by is_external_kill_rc)"
else
  ok "rc=137 → not a handler-timeout (a signal-kill, classified by is_external_kill_rc)"
fi

# ============================================================================
hr; echo "SUBTEST 1b — deadline_overrun_count reads the gardener's overrun marker; the elapsed-at-the-wall arithmetic gates it"; hr
# The gardener stamps `<!-- garden-deadline-overrun: N -->` on a claim whose handler
# hit its OWN wall (rc=124 AND elapsed within GARDEN_HANDLER_DEADLINE_EPSILON of
# GARDEN_HANDLER_TIMEOUT). deadline_overrun_count reads that counter for the reaper's
# early-poison decision. Assert the reader round-trips and defaults to 0.
tmpj="$(mktemp "${TMPDIR:-/tmp}/garden-overrun-marker.XXXXXX")"
printf '# j\n\nbody\n' > "$tmpj"
if [ "$(deadline_overrun_count "$tmpj")" = 0 ]; then
  ok "deadline_overrun_count → 0 on a job with no overrun marker"
else
  bad "deadline_overrun_count nonzero on an unmarked job (got $(deadline_overrun_count "$tmpj"))"
fi
printf '# j\n\nbody\n\n<!-- garden-deadline-overrun: 2 -->\n' > "$tmpj"
if [ "$(deadline_overrun_count "$tmpj")" = 2 ]; then
  ok "deadline_overrun_count → 2 on a job carrying the overrun marker"
else
  bad "deadline_overrun_count wrong on a marked job (got $(deadline_overrun_count "$tmpj"), want 2)"
fi
rm -f "$tmpj"
# The elapsed-at-the-wall predicate gardener.sh evaluates for an rc=124 handler is
# `elapsed >= GARDEN_HANDLER_TIMEOUT - GARDEN_HANDLER_DEADLINE_EPSILON`. Exercise the
# arithmetic directly so a regression in the guard band is caught: an elapsed AT the
# wall trips it (deterministic overrun), one comfortably BELOW the band does not
# (only a genuine wall-hit gets the fast-poison treatment).
at_wall_branch() { [ "$1" -ge "$(( $2 - $3 ))" ]; }  # elapsed timeout epsilon
if at_wall_branch 2395 2400 60; then
  ok "elapsed=2395 (within the ±60 band of a 2400s wall) → deadline-overrun branch"
else
  bad "elapsed=2395 did NOT trip the at-the-wall branch for a 2400s wall / 60s epsilon"
fi
if at_wall_branch 2401 2400 60; then
  ok "elapsed=2401 (SIGTERM→SIGKILL grace overshoot) still → deadline-overrun branch"
else
  bad "elapsed=2401 did NOT trip the at-the-wall branch (a grace-window overshoot must still count)"
fi
if at_wall_branch 100 2400 60; then
  bad "elapsed=100 (far below the wall) tripped the at-the-wall branch; the epsilon guard is too wide"
else
  ok "elapsed=100 (far below a 2400s wall) → NOT the deadline-overrun branch (guard excludes non-wall kills)"
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

# (f) THE DEADLINE-OVERRUN BRANCH: the handler hit its OWN wall (rc=124 at the wall),
# so the gardener stamped the deadline-overrun counter on the still-in-doin claim —
# proving the elapsed-at-the-wall branch fired (not the plain reap-now transient path).
if [ -f "$V/jobs/doin/hangjob.md" ] && grep -Eq '^<!-- garden-deadline-overrun: 1 -->$' "$V/jobs/doin/hangjob.md"; then
  ok "deadline-overrun counter stamped on the doin claim (garden-deadline-overrun: 1)"
else
  bad "no deadline-overrun marker on the doin claim; the elapsed-at-the-wall branch did not stamp. doin: $([ -f "$V/jobs/doin/hangjob.md" ] && grep -c overrun "$V/jobs/doin/hangjob.md" || echo missing)"
fi
# (g) the reap-now hint is stamped ALONGSIDE it, so the reaper requeues before the TTL.
if [ -f "$V/jobs/doin/hangjob.md" ] && grep -Eq '^<!-- garden-reap-now -->$' "$V/jobs/doin/hangjob.md"; then
  ok "reap-now hint stamped alongside the overrun counter (early reaper requeue)"
else
  bad "no reap-now hint alongside the overrun counter; the two markers must ride together"
fi
# (h) the distinctive deadline-overrun progress note was journaled (names the wall-clock budget).
if grep -rlq 'hit its OWN wall-clock budget' "$CLONE/entries" 2>/dev/null; then
  ok "deadline-overrun progress note journaled (names the handler wall-clock budget)"
else
  bad "no deadline-overrun progress note naming the wall-clock budget"
fi

# ============================================================================
hr; echo "SUBTEST 3 — integration: a SIGTERM-IGNORING handler is killed by --kill-after (rc=137), worker RETURNS, classified TRANSIENT"; hr
# This is the wedge the --kill-after grace closes. A handler that swallows SIGTERM
# would, under a bare `timeout`, block the wrapper forever — pinning the gardener
# worker past GARDEN_HANDLER_TIMEOUT and breaking the reaper-window invariant. With
# --kill-after the wrapper escalates to an unconditional SIGKILL after the grace, so
# the worker is GUARANTEED to return; the kill surfaces as rc=137 (external-kill
# transient → reaper requeues, no inbox escalation).
TR3="$(mktemp -d "${TMPDIR:-/tmp}/garden-killafter.XXXXXX")"; trap 'rm -rf "$TR" "$TR3"' EXIT
BARE3="$TR3/journal.git"
git init -q --bare "$BARE3"
SEED3="$TR3/seed"; git init -q "$SEED3"
git -C "$SEED3" checkout -q -b "$BRANCH"
( cd "$SEED3"
  mkdir -p jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors
  for d in jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors; do touch "$d/.gitkeep"; done
  printf '# wedgejob\n\ndo the work for wedgejob\n' > "jobs/todo/wedgejob.md" )
git -C "$SEED3" add -A
git -C "$SEED3" "${git_id[@]}" commit -q -m "seed: 1 job + structure"
git -C "$SEED3" remote add origin "$BARE3"
git -C "$SEED3" push -q -u origin "$BRANCH"

# Wrap the WHOLE gardener.sh run in an OUTER timeout: if --kill-after were missing,
# the inner timeout would block forever on the SIGTERM-ignoring handler and the
# gardener would never return — the outer timeout would then fire (rc=124) and this
# assertion fails. The outer bound (30s) is comfortably above the inner
# GARDEN_HANDLER_TIMEOUT(1)+GARDEN_HANDLER_KILL_AFTER(1) so only a genuine wedge trips it.
set +e
timeout 30 env JOURNAL_REMOTE="$BARE3" JOURNAL_BRANCH="$BRANCH" \
    GARDEN="wedgehost" GARDEN_STATE="$TR3/state" \
    GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_HANDLER_TIMEOUT=1 GARDEN_HANDLER_KILL_AFTER=1 \
    GARDEN_JOB_HANDLER="$HERE/timeout-ignore-term-handler-stub.sh" \
    "$JOBS/gardener.sh" 1 > "$TR3/gardener.log" 2>&1
outer_rc=$?
set -e

# (a) the gardener worker RETURNED — the outer timeout did NOT have to fire.
if [ "$outer_rc" -eq 124 ]; then
  bad "gardener wedged: outer timeout fired (rc=124) — --kill-after did not release a SIGTERM-ignoring handler"
else
  ok "gardener returned without wedging (outer timeout did not fire; --kill-after escalated the stuck handler)"
fi

CLONE3="$TR3/state/gardeners/1/journal"

# (b) the --kill-after escalation surfaced as rc=137.
if grep -Eq "handler FAILED \(rc=137\)|rc=137" "$TR3/gardener.log"; then
  ok "SIGTERM-ignoring handler killed by --kill-after (handler exited rc=137)"
else
  bad "rc=137 not observed; --kill-after may not have escalated. log: $(grep -i 'handler\|working\|transient' "$TR3/gardener.log" | tail -3)"
fi

# (c) classified TRANSIENT (external signal-kill), NOT escalated to the inbox.
if grep -Eq "looks transient \(rc=137" "$TR3/gardener.log"; then
  ok "rc=137 logged as a transient outage (reaper requeue, no escalation)"
else
  bad "rc=137 not logged as a transient verdict; a kill-after escalation should be transient"
fi
if [ -e "$CLONE3/inboxes/wedgehost/gardener.md" ]; then
  bad "gardener inbox escalation file created for rc=137; an external-kill transient must NOT escalate"
else
  ok "no gardener inbox escalation for rc=137 (transient, left for the reaper)"
fi

# (d) the job stays in doin (transient leaves it for the reaper; not completed).
V3="$TR3/verify"; git clone -q --single-branch --branch "$BRANCH" "$BARE3" "$V3" 2>/dev/null
if [ -f "$V3/jobs/doin/wedgejob.md" ] && [ ! -f "$V3/jobs/tada/wedgejob.md" ]; then
  ok "job left in doin (not completed to tada on a transient kill)"
else
  bad "job not left in doin (doin=$([ -f "$V3/jobs/doin/wedgejob.md" ] && echo y || echo n) tada=$([ -f "$V3/jobs/tada/wedgejob.md" ] && echo y || echo n))"
fi

# ============================================================================
hr; echo "SUBTEST 4 — reaper requeues a BELOW-threshold overrun (1) and PRESERVES the marker so it accumulates"; hr
# SUBTEST 2's gardener left hangjob in doin carrying `<!-- garden-deadline-overrun: 1 -->`
# and the reap-now hint. Run the REAL reaper against that same origin: overrun 1 is
# below GARDEN_REAP_OVERRUN_THRESHOLD (2), so the job is requeued doin→todo (driven by
# the reap-now hint, before TTL) — and the deadline-overrun marker MUST survive the
# requeue (clean_body strips only the reap-count and reap-now markers) so the count
# accumulates to 2 on the next wall-hit and THEN poisons.
env GARDEN="reaphost" GARDEN_STATE="$TR/reaper-state" GARDEN_CLAIM_TTL=3600 \
    "$JOBS/reaper.sh" > "$TR/reaper.log" 2>&1 || true
R="$TR/reaper-verify"; rm -rf "$R"
git clone -q --single-branch --branch "$BRANCH" "$BARE" "$R" 2>/dev/null
if [ -f "$R/jobs/todo/hangjob.md" ] && [ ! -f "$R/jobs/doin/hangjob.md" ]; then
  ok "reaper requeued the overrun-1 job doin→todo (below the overrun poison threshold)"
else
  bad "overrun-1 job not requeued (todo=$([ -f "$R/jobs/todo/hangjob.md" ] && echo y || echo n) doin=$([ -f "$R/jobs/doin/hangjob.md" ] && echo y || echo n)); log: $(grep -iE 'poison|reap|stale' "$TR/reaper.log" | tail -3)"
fi
if [ -f "$R/jobs/todo/hangjob.md" ] && grep -Eq '^<!-- garden-deadline-overrun: 1 -->$' "$R/jobs/todo/hangjob.md"; then
  ok "deadline-overrun marker PRESERVED across the requeue (count accumulates cycle over cycle)"
else
  bad "deadline-overrun marker lost on requeue; the count would never reach the poison threshold"
fi
if [ -f "$R/jobs/todo/hangjob.md" ] && ! grep -Eq '^<!-- garden-reap-now -->$' "$R/jobs/todo/hangjob.md"; then
  ok "reap-now hint stripped from the requeued job (no premature re-reap on the next claim)"
else
  bad "reap-now hint persisted into the requeued job (a healthy re-claim would be reaped instantly)"
fi

# ============================================================================
hr; echo "SUBTEST 5 — reaper POISONS a deadline-overrun job at the LOWER overrun threshold (2), naming the budget signature"; hr
# A job that has hit its own wall TWICE (`<!-- garden-deadline-overrun: 2 -->`) is
# conclusively over budget: the reaper must POISON it at GARDEN_REAP_OVERRUN_THRESHOLD
# (2) — dropping it from the board — WITHOUT waiting the full GARDEN_REAP_POISON_THRESHOLD
# (5) cycles, and the alert must name the deterministic-overrun signature.
TR5="$(mktemp -d "${TMPDIR:-/tmp}/garden-overrun-poison.XXXXXX")"; trap 'rm -rf "$TR" "$TR3" "$TR5"' EXIT
BARE5="$TR5/journal.git"
git init -q --bare "$BARE5"
SEED5="$TR5/seed"; git init -q "$SEED5"
git -C "$SEED5" checkout -q -b "$BRANCH"
( cd "$SEED5"
  mkdir -p jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors
  for d in jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors; do touch "$d/.gitkeep"; done
  # A doin claim that has hit its own wall twice, with the reap-now hint so the reaper
  # promotes it to the stale set on this tick (age ≪ TTL).
  {
    printf '# overrunjob\n\ndo the work for overrunjob\n\n'
    printf '<!-- garden-deadline-overrun: 2 -->\n'
    printf '<!-- garden-reap-now -->\n'
    printf -- '---\nclaim:\n  host: reaphost5\n  gardener: 1\n  claimed_at: 2026-07-01T00:00:00Z\n'
  } > "jobs/doin/overrunjob.md"
  # A real claim always has a matching work/<spine> record (claim-job writes it); the
  # reaper's orphaned-worktree cleanup seds it, so seed one so the requeue proceeds.
  printf 'worktree_dir:\n' > "work/overrunjob" )
git -C "$SEED5" add -A
git -C "$SEED5" "${git_id[@]}" commit -q -m "seed: 1 doin overrun-2 claim"
git -C "$SEED5" remote add origin "$BARE5"
git -C "$SEED5" push -q -u origin "$BRANCH"

env GARDEN="reaphost5" GARDEN_STATE="$TR5/state" JOURNAL_REMOTE="$BARE5" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_CLAIM_TTL=3600 GARDEN_REAP_OVERRUN_THRESHOLD=2 GARDEN_REAP_POISON_THRESHOLD=5 \
    "$JOBS/reaper.sh" > "$TR5/reaper.log" 2>&1 || true

R5="$TR5/verify"; git clone -q --single-branch --branch "$BRANCH" "$BARE5" "$R5" 2>/dev/null
# (a) PARKED in plan/ under a held gate (not requeued to todo, not left in doin, not
# dropped) at the lower overrun threshold — the work survives for a human to resume.
if [ ! -f "$R5/jobs/todo/overrunjob.md" ] && [ ! -f "$R5/jobs/doin/overrunjob.md" ] \
   && [ -f "$R5/jobs/plan/overrunjob.md" ]; then
  ok "overrun-2 job POISONED at the lower overrun threshold and PARKED in plan/ (held, not requeued)"
else
  bad "overrun-2 job not parked in plan/ (todo=$([ -f "$R5/jobs/todo/overrunjob.md" ] && echo y || echo n) doin=$([ -f "$R5/jobs/doin/overrunjob.md" ] && echo y || echo n) plan=$([ -f "$R5/jobs/plan/overrunjob.md" ] && echo y || echo n)); log: $(grep -iE 'poison|reap|stale' "$TR5/reaper.log" | tail -3)"
fi
# the parked plan is gated go-ahead (held) and names the deterministic-overrun signature.
{ [ -f "$R5/jobs/plan/overrunjob.md" ] && grep -qx 'gate: go-ahead' "$R5/jobs/plan/overrunjob.md" \
  && grep -qx 'poison_signature: deadline-overrun' "$R5/jobs/plan/overrunjob.md"; } \
  && ok "parked overrun poison plan is held (go-ahead) and carries the deadline-overrun signature" \
  || bad "parked overrun poison plan missing held gate / overrun signature"
# (b) the reaper log names the deterministic-overrun poison (not a generic per-cycle poison).
if grep -Eq 'POISON \(deadline-overrun\)' "$TR5/reaper.log"; then
  ok "reaper logged the deadline-overrun poison signature (names the handler wall-clock budget)"
else
  bad "reaper did not log a deadline-overrun poison; log: $(grep -iE 'poison' "$TR5/reaper.log" | tail -3)"
fi

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
