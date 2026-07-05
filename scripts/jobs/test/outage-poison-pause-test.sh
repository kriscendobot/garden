#!/bin/bash
# outage-poison-pause-test.sh — regression guard for the SUSTAINED-OUTAGE poison
# pause (fu-investigate-poisoned-garden-infra-jobs-2, 2026-07-05).
#
# THE GAP THIS CLOSES: the reaper poisons a job after GARDEN_REAP_POISON_THRESHOLD
# requeue cycles on the assumption that a handler requeued that many times "fails
# every time". But during a fleet-wide correlated outage (a Claude quota/usage cut,
# an API-overload storm) MANY handlers transient-fail at once for reasons that have
# nothing to do with any one job's content. Left alone, a healthy job racks up the
# full poison threshold of purely-environmental cycles and is parked + paged — the
# 2026-07-01 storm that poisoned a dozen unrelated jobs.
#
# THE FIX: the shared FLEET BRAKE already distinguishes a correlated storm (many
# transient failures across the pool) from a one-off blip. When a gardener transient-
# fails while the brake is ENGAGED it stamps `<!-- garden-outage-cycle -->` on its
# still-in-doin claim; the reaper READS it and PAUSES the poison counter for that
# cycle — HOLDS it at the prior value (neither incrementing toward the threshold nor
# resetting it), and never poisons on an outage cycle. Once the outage clears the
# gardener stops stamping the marker and a still-failing job poisons on its own
# non-outage cycles. The marker is re-earned each cycle (clean_body strips it).
#
# SUBTEST 1 — pure helpers has_outage_cycle_hint / stamp_outage_cycle_hint: the
#             predicate detects the marker; the stamper inserts it into a doin claim
#             body (above the claim block) idempotently and lands it on the board.
# SUBTEST 2 — end-to-end gardener: a transient handler failure WITH the fleet brake
#             engaged → the gardener stamps the outage-cycle marker on its doin claim;
#             the same failure with the brake DISENGAGED does NOT.
# SUBTEST 3 — reaper: a stale claim flagged outage is REQUEUED with the counter HELD
#             (not incremented, not reset) and NOT poisoned even at/over threshold,
#             while an identical NON-outage claim POISONS at the same threshold — the
#             environmental-storm false-poison is gone, the genuine-failure case kept.
#
# Usage: outage-poison-pause-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env (a live gardener running this test as a board job would
# otherwise splice its own GARDEN_*/JOURNAL_* state underneath the fixture).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

STUB="$HERE/signal-kill-handler-stub.sh"   # exits GARDEN_STUB_RC (default 143) → transient
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-outage.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
git_id=(-c user.name=test -c user.email=test@localhost)

# seed_board <dir> <base> — throwaway origin with the board structure + one todo job.
seed_board() {
  local tr="$1" base="$2" bare="$1/journal.git" seed="$1/seed" branch=journal2
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$branch"
  ( cd "$seed"
    mkdir -p jobs/todo jobs/doin jobs/tada jobs/plan work repos msgs hosts entries schedules cursors \
             inbox/maintainer/unread inbox/maintainer/read
    for d in jobs/todo jobs/doin jobs/tada jobs/plan work repos msgs hosts entries schedules cursors \
             inbox/maintainer/unread inbox/maintainer/read; do touch "$d/.gitkeep"; done
    printf '# %s\n\ndo the work for %s\n' "$base" "$base" > "jobs/todo/$base.md" )
  git -C "$seed" add -A
  git -C "$seed" "${git_id[@]}" commit -q -m "seed: 1 job + structure"
  git -C "$seed" remote add origin "$bare"
  git -C "$seed" push -q -u origin "$branch"
  printf '%s\n' "$bare"
}

# ============================================================================
hr; echo "SUBTEST 1 — pure helpers: stamp inserts the marker; predicate detects it"; hr
export GARDEN_SCRATCH="$TR/scratch1"; mkdir -p "$GARDEN_SCRATCH"
export GARDEN=hosth1
T1="$TR/helpers"; mkdir -p "$T1"
BARE1="$(seed_board "$T1" hjob)"
export JOURNAL_REMOTE="$BARE1" JOURNAL_BRANCH=journal2
# shellcheck source=../common.sh
source "$JOBS/common.sh"

# Place a claim in doin (with a trailing claim block, the shape stamp targets).
# Set a committer identity on the clone the way ensure_clone would (stamp_* commits
# from this clone via commit_and_push, which uses the clone's local git identity).
CL="$T1/clone"; git clone -q --single-branch --branch journal2 "$BARE1" "$CL"
git -C "$CL" config user.name test; git -C "$CL" config user.email test@localhost
{
  printf '# hjob\n\nthe body for hjob\n\n'
  printf -- '---\nclaim:\n  host: hosth1\n  gardener: 3\n  claimed_at: 2020-01-01T00:00:00Z\n'
} > "$CL/jobs/doin/hjob.md"
git -C "$CL" rm -q jobs/todo/hjob.md
git -C "$CL" add jobs/doin/hjob.md
git -C "$CL" "${git_id[@]}" commit -q -m "place claim"
git -C "$CL" push -q origin HEAD:journal2

has_outage_cycle_hint "$CL/jobs/doin/hjob.md" \
  && bad "predicate false-positive on an un-stamped claim" \
  || ok "has_outage_cycle_hint → false on an un-stamped claim"

( stamp_outage_cycle_hint "$CL" "jobs/doin/hjob.md" ) \
  && ok "stamp_outage_cycle_hint landed" || bad "stamp_outage_cycle_hint failed"

# Re-clone to confirm it landed on the board, and that the marker sits in the BODY
# (above the claim block), not below it.
V1="$T1/verify"; git clone -q --single-branch --branch journal2 "$BARE1" "$V1"
if has_outage_cycle_hint "$V1/jobs/doin/hjob.md"; then
  ok "outage marker present on the board copy after stamping"
else
  bad "outage marker not on the board copy"
fi
# marker line number < claim block line number (it is in the body)
mline="$(grep -n '^<!-- garden-outage-cycle -->$' "$V1/jobs/doin/hjob.md" | head -1 | cut -d: -f1)"
cline="$(grep -n '^claim:$' "$V1/jobs/doin/hjob.md" | head -1 | cut -d: -f1)"
[ -n "$mline" ] && [ -n "$cline" ] && [ "$mline" -lt "$cline" ] \
  && ok "marker sits in the body, above the claim block" \
  || bad "marker misplaced (marker line=$mline claim line=$cline)"

# Idempotent: a second stamp is a no-op (no duplicate marker).
( stamp_outage_cycle_hint "$CL" "jobs/doin/hjob.md" ) >/dev/null 2>&1 || true
V1b="$T1/verify2"; git clone -q --single-branch --branch journal2 "$BARE1" "$V1b"
n="$(grep -c '^<!-- garden-outage-cycle -->$' "$V1b/jobs/doin/hjob.md" || true)"
[ "$n" = "1" ] && ok "stamp is idempotent (exactly one marker)" || bad "duplicate markers after re-stamp (n=$n)"

# ============================================================================
hr; echo "SUBTEST 2 — gardener stamps the outage marker iff the fleet brake is engaged"; hr
# (a) BRAKE ENGAGED: a transient handler failure while the brake is over threshold →
#     the gardener stamps the outage-cycle marker on its doin claim.
T2="$TR/e2e-outage"; mkdir -p "$T2"
BARE2="$(seed_board "$T2" outjob)"
# Threshold 1: the single transient failure this run records tips the density over the
# bar, so fleet_brake_engaged is true at the post-failure check. (At CLAIM time the
# ledger is empty → density 0 → no pause, so the job is still claimed and run.) The
# brake window/pause are tiny so the post-failure engaged brake drains in a couple of
# seconds (in production it holds the pool for the real outage window); the run is
# `timeout`-bounded so a regression that wedges the loop fails loudly rather than hanging.
env GARDEN="outhost" GARDEN_STATE="$T2/state" JOURNAL_REMOTE="$BARE2" JOURNAL_BRANCH=journal2 \
    GARDEN_SCRATCH="$T2/scratch" GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 \
    GARDEN_FLEET_BRAKE_THRESHOLD=1 GARDEN_FLEET_BRAKE_WINDOW_SECS=2 GARDEN_FLEET_BRAKE_PAUSE_SECS=1 \
    GARDEN_ELAPSED_CONSTANCY_CYCLES=0 \
    GARDEN_STUB_RC=143 GARDEN_JOB_HANDLER="$STUB" \
    timeout 60 "$JOBS/gardener.sh" 1 > "$T2/gardener.log" 2>&1 || true
V2="$T2/verify"; git clone -q --single-branch --branch journal2 "$BARE2" "$V2" 2>/dev/null
if [ -f "$V2/jobs/doin/outjob.md" ] && grep -Eq '^<!-- garden-outage-cycle -->$' "$V2/jobs/doin/outjob.md"; then
  ok "transient failure UNDER an engaged brake → gardener stamped the outage-cycle marker"
else
  bad "outage marker NOT stamped under an engaged brake ($(grep -i 'brake\|outage\|handler' "$T2/gardener.log" | tail -3))"
fi

# (b) BRAKE DISENGAGED (threshold 0 disables the brake): the same transient failure
#     must NOT stamp the marker — a lone blip is not a fleet-wide outage.
T2b="$TR/e2e-noout"; mkdir -p "$T2b"
BARE2b="$(seed_board "$T2b" solojob)"
env GARDEN="solohost" GARDEN_STATE="$T2b/state" JOURNAL_REMOTE="$BARE2b" JOURNAL_BRANCH=journal2 \
    GARDEN_SCRATCH="$T2b/scratch" GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 \
    GARDEN_FLEET_BRAKE_THRESHOLD=0 \
    GARDEN_ELAPSED_CONSTANCY_CYCLES=0 \
    GARDEN_STUB_RC=143 GARDEN_JOB_HANDLER="$STUB" \
    "$JOBS/gardener.sh" 1 > "$T2b/gardener.log" 2>&1 || true
V2b="$T2b/verify"; git clone -q --single-branch --branch journal2 "$BARE2b" "$V2b" 2>/dev/null
if [ -f "$V2b/jobs/doin/solojob.md" ] && ! grep -Eq '^<!-- garden-outage-cycle -->$' "$V2b/jobs/doin/solojob.md"; then
  ok "transient failure with the brake DISENGAGED → NO outage marker (still left in doin for the reaper)"
else
  bad "outage marker wrongly present with the brake disengaged"
fi

# ============================================================================
hr; echo "SUBTEST 3 — reaper: outage claim HOLDS the counter (not poisoned); non-outage poisons"; hr
T3="$TR/reaper"; mkdir -p "$T3"
BARE3="$(seed_board "$T3" xjob)"   # board structure (job body reused as fixtures below)
export JOURNAL_REMOTE="$BARE3" JOURNAL_BRANCH=journal2
export GARDEN=reaphost GARDEN_STATE="$T3/state"
export GARDEN_POST_ATTEMPTS=50 GARDEN_REAP_PUSH_ATTEMPTS=50
export GARDEN_REAP_POISON_THRESHOLD=3 GARDEN_REAP_OVERRUN_THRESHOLD=2 GARDEN_CLAIM_TTL=3600

# place_stale <base> <outage:0|1> [reaped:N] — a STALE claim in doin (claimed_at past
# TTL), optionally carrying the outage marker and/or a prior reap-count marker
# (`<!-- garden-reaped: N -->`, only when N>0) in its body.
place_stale() {
  local base="$1" outage="${2:-0}" reaped="${3:-0}" wt; wt="$(mktemp -d "$T3/edit.XXXXXX")"
  git clone -q --single-branch --branch journal2 "$BARE3" "$wt"
  {
    printf '# %s\n\nthe original work body for %s\n\n' "$base" "$base"
    [ "$outage" = "1" ] && printf '<!-- garden-outage-cycle -->\n'
    [ "$reaped" -gt 0 ] && printf '<!-- garden-reaped: %s -->\n' "$reaped"
    printf -- '---\nclaim:\n  host: reaphost\n  gardener: 7\n  claimed_at: 2020-01-01T00:00:00Z\n'
  } > "$wt/jobs/doin/$base.md"
  printf 'worktree_dir: %s\n' "$T3/nonexistent-wt-$base" > "$wt/work/$base"
  git -C "$wt" add "jobs/doin/$base.md" "work/$base"
  git -C "$wt" "${git_id[@]}" commit -q -m "place stale $base"
  git -C "$wt" push -q origin "HEAD:journal2"
  rm -rf "$wt"
}
resync3() { rm -rf "$T3/v"; git clone -q --single-branch --branch journal2 "$BARE3" "$T3/v"; }

# An OUTAGE stale claim already AT the poison threshold (reaped:3, threshold 3) must
# NOT poison: it requeues to todo with the counter HELD at 3 (not incremented to 4,
# not reset to 0) and the outage marker stripped (re-earned next cycle).
place_stale outjob 1 3
"$JOBS/reaper.sh" > "$T3/reap-out.log" 2>&1 || { echo "  (reaper rc=$?)"; sed 's/^/    /' "$T3/reap-out.log"; }
resync3
out_ok=1
[ -f "$T3/v/jobs/todo/outjob.md" ] || { out_ok=0; echo "    outjob not requeued to todo/"; }
[ -f "$T3/v/jobs/plan/outjob.md" ] && { out_ok=0; echo "    outjob was POISONED (parked in plan/) despite the outage pause"; }
[ -f "$T3/v/jobs/doin/outjob.md" ] && { out_ok=0; echo "    outjob still in doin/"; }
if [ -f "$T3/v/jobs/todo/outjob.md" ]; then
  grep -Eq '^<!-- garden-reaped: 3 -->$' "$T3/v/jobs/todo/outjob.md" || { out_ok=0; echo "    reap counter not HELD at 3 ($(grep -o 'garden-reaped: [0-9]*' "$T3/v/jobs/todo/outjob.md" | head -1))"; }
  grep -Eq '^<!-- garden-outage-cycle -->$' "$T3/v/jobs/todo/outjob.md" && { out_ok=0; echo "    outage marker not stripped on requeue"; }
fi
[ "$out_ok" -eq 1 ] \
  && ok "an OUTAGE cycle AT threshold 3 → requeued to todo (counter HELD at 3, marker stripped), NOT poisoned" \
  || bad "outage-cycle pause failed (todo=$([ -f "$T3/v/jobs/todo/outjob.md" ] && echo y || echo n) plan=$([ -f "$T3/v/jobs/plan/outjob.md" ] && echo y || echo n))"

# The genuine-failure case is preserved: a NON-outage stale claim at the same reaped
# count increments to threshold and POISONS — parked in plan/ (held), gone from doin,
# not in todo.
place_stale failjob 0 2   # reaped 2, +1 this cycle = 3 = threshold → poison
"$JOBS/reaper.sh" > "$T3/reap-fail.log" 2>&1 || { echo "  (reaper rc=$?)"; sed 's/^/    /' "$T3/reap-fail.log"; }
resync3
fail_ok=1
[ -f "$T3/v/jobs/plan/failjob.md" ] || { fail_ok=0; echo "    failjob not poisoned/parked in plan/"; }
[ -f "$T3/v/jobs/todo/failjob.md" ] && { fail_ok=0; echo "    failjob leaked into todo/ (should have poisoned)"; }
[ -f "$T3/v/jobs/doin/failjob.md" ] && { fail_ok=0; echo "    failjob still in doin/"; }
[ -f "$T3/v/jobs/plan/failjob.md" ] && { grep -q '^poisoned: true$' "$T3/v/jobs/plan/failjob.md" || { fail_ok=0; echo "    plan entry missing poisoned provenance"; }; }
[ "$fail_ok" -eq 1 ] \
  && ok "a NON-outage cycle still increments and POISONS at the threshold (parked in plan/, held) — genuine-failure case preserved" \
  || bad "non-outage poison broke (plan=$([ -f "$T3/v/jobs/plan/failjob.md" ] && echo y || echo n) todo=$([ -f "$T3/v/jobs/todo/failjob.md" ] && echo y || echo n))"

# An OUTAGE cycle also HOLDS (does not reset) a partial count: reaped 2 + outage →
# requeued holding 2 (a reset would erase legitimate prior no-progress failures).
place_stale holdjob 1 2
"$JOBS/reaper.sh" > "$T3/reap-hold.log" 2>&1 || { echo "  (reaper rc=$?)"; sed 's/^/    /' "$T3/reap-hold.log"; }
resync3
hold_ok=1
[ -f "$T3/v/jobs/todo/holdjob.md" ] || { hold_ok=0; echo "    holdjob not requeued to todo/"; }
if [ -f "$T3/v/jobs/todo/holdjob.md" ]; then
  grep -Eq '^<!-- garden-reaped: 2 -->$' "$T3/v/jobs/todo/holdjob.md" \
    || { hold_ok=0; echo "    counter not HELD at 2 ($(grep -o 'garden-reaped: [0-9]*' "$T3/v/jobs/todo/holdjob.md" | head -1))"; }
fi
[ "$hold_ok" -eq 1 ] \
  && ok "an OUTAGE cycle HOLDS a partial count (reaped 2 → held 2, not reset to 0, not bumped to 3)" \
  || bad "outage hold-not-reset failed"

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
