#!/bin/bash
# handler-budget-test.sh — regression guard for the OPTIONAL per-job handler
# budget header (gardener.sh, the `handler-timeout: <seconds>` resolution just
# before the `timeout --signal=TERM --kill-after=... "$handler_budget" <handler>`
# call site).
#
# A job may declare a longer run-to-completion budget than the default
# GARDEN_HANDLER_TIMEOUT so a legitimately long "run to completion" job (whose
# NAME promises completion — e.g.
# garden-issue-9-run-contract-control-upgrade-test-to-completion) is not
# structurally SIGTERM-killed at the fixed default cap. The header is honored ONLY
# within the invariant that keeps a claim single-owner:
#     handler_budget + GARDEN_HANDLER_KILL_AFTER < GARDEN_CLAIM_TTL
# so the largest a single claim can hold is CLAIM_TTL - KILL_AFTER - 1.
#
# SUBTEST 1 — HONOR: a job declaring a budget LARGER than the (tiny) default, but
#   within the invariant, runs to completion. The handler sleeps past the default
#   budget then writes the completion sentinel; with the default it would be killed
#   (rc=124, left in doin), so a doin→tada completion PROVES the declared budget was
#   used. The "honoring" log line is asserted too.
# SUBTEST 2 — CLAMP + ESCALATE: a job declaring a budget that EXCEEDS what one claim
#   can hold (over CLAIM_TTL - KILL_AFTER - 1) is NOT silently raised into the
#   invariant (that would let the reaper requeue the same base onto a second gardener
#   mid-run — duplicate execution). Instead the budget is clamped to the safe max AND
#   the maintainer is alerted with the "run detached or split" guidance. Both are
#   asserted (the "clamping to max and escalating" log line and the recorded alert).
# SUBTEST 3 — IGNORE INVALID: a non-numeric / zero header (0 would disable `timeout`
#   entirely, breaking the invariant) is ignored and the default budget stands.
#
# Usage: handler-budget-test.sh
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

TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-hbudget.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
git_id=(-c user.name=test -c user.email=test@localhost)
BRANCH=journal2

# Committed stubs (this sandbox mounts /tmp noexec, so handlers must live in the
# repo test dir and be referenced via $HERE, like the other gardener test stubs).
#   STUB  — sleeps GARDEN_STUB_SLEEP, writes a report, then the completion sentinel.
#   ALERT — a GARDEN_ALERT_CMD recorder: appends key+msg to $GARDEN_ALERT_RECORD.
STUB="$HERE/budget-sleep-complete-handler-stub.sh"
ALERT="$HERE/budget-alert-record-stub.sh"

# seed_board <workdir> <jobname> <body> — a throwaway origin with the board
# structure and one todo job carrying <body>.
seed_board() {
  local dir="$1" job="$2" body="$3"
  local bare="$dir/journal.git" seed="$dir/seed"
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$BRANCH"
  ( cd "$seed"
    mkdir -p jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors
    for d in jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors; do touch "$d/.gitkeep"; done
    # A job with NO `tier:` is unclaimable by ANY worker kind: job_tier fails on a
    # headerless body, so job_eligible_for_kind (claim-job.sh) returns 1 and every
    # gardener logs "pinned to a model this gardener cannot honor; skipping
    # (backend-fit)". These fixtures were headerless, so the job was never claimed
    # and every assertion below failed for a reason unrelated to handler budgets.
    # Real producers always stamp a tier — automatic_route_body rewrites every
    # automatic body to `tier: mentor` — so seed the claimable shape here, unless
    # the caller's body already carries its own frontmatter.
    if [ "${body%%$'\n'*}" = "---" ]; then
      printf '%s' "$body" > "jobs/todo/$job.md"
    else
      { printf -- '---\ntier: mentor\ndispatch: automatic\n---\n'; printf '%s' "$body"; } > "jobs/todo/$job.md"
    fi )
  git -C "$seed" add -A
  git -C "$seed" "${git_id[@]}" commit -q -m "seed: 1 job + structure"
  git -C "$seed" remote add origin "$bare"
  git -C "$seed" push -q -u origin "$BRANCH"
  echo "$bare"
}

# ============================================================================
hr; echo "SUBTEST 1 — a declared budget LARGER than the default (within the invariant) is HONORED and the job COMPLETES"; hr
D1="$TR/s1"; mkdir -p "$D1"
# default budget 1s; declared 5s; stub sleeps 3s → completes only if 5s is honored.
BARE1="$(seed_board "$D1" honorjob "$(printf '# honorjob\nhandler-timeout: 5\n\ndo the work for honorjob\n')")"
env JOURNAL_REMOTE="$BARE1" JOURNAL_BRANCH="$BRANCH" \
    GARDEN="honorhost" GARDEN_STATE="$D1/state" \
    GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_HANDLER_TIMEOUT=1 GARDEN_STUB_SLEEP=3 \
    GARDEN_JOB_HANDLER="$STUB" \
    "$JOBS/gardener.sh" 1 > "$D1/gardener.log" 2>&1 || true

if grep -Eq "declared handler-timeout=5s .*honoring" "$D1/gardener.log"; then
  ok "declared budget logged as honored (in place of the default)"
else
  bad "no 'honoring' log line. log: $(grep -i 'handler-timeout\|budget\|working' "$D1/gardener.log" | tail -3)"
fi
V1="$D1/verify"; git clone -q --single-branch --branch "$BRANCH" "$BARE1" "$V1" 2>/dev/null
if [ -f "$V1/jobs/tada/honorjob.md" ] && [ ! -f "$V1/jobs/doin/honorjob.md" ]; then
  ok "job completed to tada (the 5s budget outlived the 3s handler; the 1s default would have killed it)"
else
  bad "job not completed to tada (doin=$([ -f "$V1/jobs/doin/honorjob.md" ] && echo y || echo n) tada=$([ -f "$V1/jobs/tada/honorjob.md" ] && echo y || echo n)) — declared budget may not have been used"
fi

# ============================================================================
hr; echo "SUBTEST 2 — a declared budget EXCEEDING one claim is CLAMPED and ESCALATED (not silently raised)"; hr
D2="$TR/s2"; mkdir -p "$D2"
# CLAIM_TTL=100, KILL_AFTER=10 → max budget = 89. Declared 5000 → clamp+escalate.
BARE2="$(seed_board "$D2" bigjob "$(printf '# bigjob\nhandler-timeout: 5000\n\ndo the work for bigjob\n')")"
REC="$D2/alerts.txt"; : > "$REC"
env JOURNAL_REMOTE="$BARE2" JOURNAL_BRANCH="$BRANCH" \
    GARDEN="bighost" GARDEN_STATE="$D2/state" \
    GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_HANDLER_TIMEOUT=1 \
    GARDEN_CLAIM_TTL=100 GARDEN_HANDLER_KILL_AFTER=10 GARDEN_STUB_SLEEP=0 \
    GARDEN_ALERT_CMD="$ALERT" GARDEN_ALERT_RECORD="$REC" \
    GARDEN_JOB_HANDLER="$STUB" \
    "$JOBS/gardener.sh" 1 > "$D2/gardener.log" 2>&1 || true

if grep -Eq "declared handler-timeout=5000s > claim budget max 89s; clamping to max and escalating" "$D2/gardener.log"; then
  ok "over-budget request logged as clamped-to-max + escalating (not silently raised into the invariant)"
else
  bad "no clamp/escalate log line. log: $(grep -i 'handler-timeout\|budget\|clamp' "$D2/gardener.log" | tail -3)"
fi
if grep -q "exceeds what a single claim can hold" "$REC" && grep -qi "detached" "$REC" && grep -qi "split" "$REC"; then
  ok "maintainer alert recorded with the 'run detached or split' guidance"
else
  bad "maintainer alert not recorded / missing guidance. record: $(cat "$REC")"
fi

# ============================================================================
hr; echo "SUBTEST 3 — a zero / non-numeric header is IGNORED (default budget stands, no escalation)"; hr
D3="$TR/s3"; mkdir -p "$D3"
BARE3="$(seed_board "$D3" zerojob "$(printf '# zerojob\nhandler-timeout: 0\n\ndo the work for zerojob\n')")"
REC3="$D3/alerts.txt"; : > "$REC3"
env JOURNAL_REMOTE="$BARE3" JOURNAL_BRANCH="$BRANCH" \
    GARDEN="zerohost" GARDEN_STATE="$D3/state" \
    GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_HANDLER_TIMEOUT=5 GARDEN_STUB_SLEEP=0 \
    GARDEN_ALERT_CMD="$ALERT" GARDEN_ALERT_RECORD="$REC3" \
    GARDEN_JOB_HANDLER="$STUB" \
    "$JOBS/gardener.sh" 1 > "$D3/gardener.log" 2>&1 || true

if grep -Eq "declared handler-timeout=|clamping to max" "$D3/gardener.log"; then
  bad "a zero/invalid header was acted on; expected it to be ignored (default budget stands)"
else
  ok "zero/invalid header ignored (no budget log line; the default budget is used)"
fi
if [ -s "$REC3" ]; then
  bad "maintainer alerted for an ignored header. record: $(cat "$REC3")"
else
  ok "no maintainer escalation for an ignored header"
fi
V3="$D3/verify"; git clone -q --single-branch --branch "$BRANCH" "$BARE3" "$V3" 2>/dev/null
if [ -f "$V3/jobs/tada/zerojob.md" ]; then
  ok "job completed normally under the default budget"
else
  bad "job did not complete under the default budget"
fi

# ============================================================================
hr; echo "SUBTEST 4 — a DEFAULT-budget job that DETERMINISTICALLY overruns (rc=124 at the wall) alerts the maintainer ONCE with split/detached guidance, deduped across the two pre-doom overrun cycles"; hr
D4="$TR/s4"; mkdir -p "$D4"
# NO handler-timeout header (default budget stands). Default budget 1s; stub sleeps
# 3s → SIGTERM-killed at the 1s wall (rc=124, elapsed≈1 ≥ budget−epsilon) → a
# DETERMINISTIC deadline overrun, NOT a declared-over-budget clamp. Under the default
# budget this gets no clamp-path pre-run alert, so the deadline-overrun branch must be
# the one that surfaces the "too big for one claim" diagnosis.
BARE4="$(seed_board "$D4" overrunjob "$(printf '# overrunjob\n\ndo the work for overrunjob\n')")"
REC4="$D4/alerts.txt"; : > "$REC4"
STATE4="$D4/state"
# One overrun cycle: default budget 1s, stub sleeps 3s → rc=124 at the wall. Reuses
# the SAME GARDEN_STATE across calls so the alert throttle marker persists.
run_overrun_cycle() {
  env JOURNAL_REMOTE="$BARE4" JOURNAL_BRANCH="$BRANCH" \
      GARDEN="overrunhost" GARDEN_STATE="$STATE4" \
      GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_HANDLER_TIMEOUT=1 GARDEN_STUB_SLEEP=3 \
      GARDEN_ALERT_CMD="$ALERT" GARDEN_ALERT_RECORD="$REC4" \
      GARDEN_JOB_HANDLER="$STUB" \
      "$JOBS/gardener.sh" 1 > "$1" 2>&1 || true
}
# Move the job the gardener left in doin back to todo on the bare, so a SECOND
# gardener claims the SAME base for the second overrun cycle (the reaper's requeue,
# reproduced deterministically offline).
requeue_doin_to_todo() {
  local w="$D4/requeue"; rm -rf "$w"
  git clone -q --single-branch --branch "$BRANCH" "$BARE4" "$w"
  ( cd "$w"
    f="$(ls jobs/doin/ 2>/dev/null | grep -v '^\.gitkeep$' | head -1)"
    [ -n "$f" ] || exit 0
    git "${git_id[@]}" mv "jobs/doin/$f" "jobs/todo/$f"
    git "${git_id[@]}" commit -q -m "requeue $f for 2nd overrun cycle"
    git push -q origin "$BRANCH" )
  rm -rf "$w"
}

run_overrun_cycle "$D4/gardener1.log"
if grep -Eq "deterministic deadline overrun" "$D4/gardener1.log"; then
  ok "default-budget handler classified as a deterministic deadline overrun (rc=124 at the wall)"
else
  bad "no deadline-overrun log line. log: $(grep -i 'deadline\|overrun\|budget\|rc=124' "$D4/gardener1.log" | tail -3)"
fi
if [ "$(grep -c '^KEY=handler-budget-overrun-overrunjob$' "$REC4")" = 1 ]; then
  ok "maintainer alerted exactly once on the first overrun cycle, under the shared dedup key"
else
  bad "expected exactly one alert on cycle 1. record: $(cat "$REC4")"
fi
if grep -qi "DETERMINISTICALLY overran" "$REC4" && grep -qi "detached" "$REC4" && grep -qi "split" "$REC4"; then
  ok "alert carries the actionable split/detached diagnosis the reaper's generic doom report omits"
else
  bad "alert missing the split/detached diagnosis. record: $(cat "$REC4")"
fi

# Second overrun cycle within the throttle window: requeue the same base and run
# again against the SAME GARDEN_STATE (so the throttle marker persists). Both
# surfaces of the one root cause share the `handler-budget-overrun-<base>` key, so
# the alert must be DEDUPED — the record still holds exactly ONE entry across both
# cycles, confirming the throttle collapses the two pre-doom overrun cycles.
requeue_doin_to_todo
run_overrun_cycle "$D4/gardener2.log"
if grep -Eq "deterministic deadline overrun" "$D4/gardener2.log"; then
  ok "second cycle also overran deterministically (the same root cause repeats before doom)"
else
  bad "second cycle did not re-overrun. log: $(grep -i 'deadline\|overrun\|rc=124' "$D4/gardener2.log" | tail -3)"
fi
if [ "$(grep -c '^KEY=handler-budget-overrun-overrunjob$' "$REC4")" = 1 ]; then
  ok "alert deduped across the two pre-doom overrun cycles (the shared throttle key collapsed them to one)"
else
  bad "expected the alert to stay deduped at one entry across both cycles. record: $(cat "$REC4")"
fi

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
