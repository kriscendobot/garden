#!/bin/bash
# productive-cycle-test.sh — regression guard for the PRODUCTIVE-CYCLE poison fix
# (surfaced by the xs2rust press-driver, 2026-07-03).
#
# THE GAP THIS CLOSES: the reaper poisons a job after GARDEN_REAP_POISON_THRESHOLD
# requeue cycles on the assumption that a handler requeued that many times "fails
# every time". But a long builder on the SANCTIONED RESUME TREADMILL — push green
# commits each cycle, exit WITHOUT the completion signal before the handler wall, and
# resume on the next claim — trips the SAME counter even though EVERY cycle lands real
# progress. xs2rust-endor-build-stage3-arrays was false-poisoned this way: its HEAD
# advanced across the "failing" cycles, yet the counter climbed to the threshold and
# the job was dropped.
#
# THE FIX: a cycle in which a per-job worktree HEAD advanced (the handler committed
# real work) is PRODUCTIVE. The gardener detects it (it owns the worktree locally) and
# stamps `<!-- garden-productive-cycle -->` on its still-in-doin claim; the reaper
# RESETS the reap/poison counter for a productive cycle instead of incrementing it, so
# only cycles with NO progress accumulate. A genuinely-failing job (no HEAD movement)
# never earns the marker and still poisons at the threshold.
#
# SUBTEST 1 — pure helpers job_worktree_heads / job_cycle_productive: a persisted
#             worktree that ADVANCES is productive; an unchanged one, or a freshly-
#             appearing (setup-only) worktree, is NOT.
# SUBTEST 2 — end-to-end gardener: a resumed worktree whose HEAD advances during an
#             exit-0-without-signal cycle → the gardener stamps the productive marker
#             on its doin claim (a no-progress cycle does NOT).
# SUBTEST 3 — reaper: a stale claim flagged productive is REQUEUED with the counter
#             RESET (not poisoned), while an identical NON-productive claim POISONS at
#             the same threshold — the resume-treadmill false-positive is gone, the
#             genuine-failure case preserved.
#
# Usage: productive-cycle-test.sh
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

STUB="$HERE/completion-signal-handler-stub.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-productive.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
git_id=(-c user.name=test -c user.email=test@localhost)

# mkwt <path> — create a git worktree-like repo at <path> with one commit; echo its HEAD.
mkwt() {
  local p="$1"; mkdir -p "$p"; git init -q "$p"
  git -C "$p" "${git_id[@]}" commit -q --allow-empty -m base
  git -C "$p" rev-parse HEAD
}
advance() { git -C "$1" "${git_id[@]}" commit -q --allow-empty -m more; }  # advance a repo's HEAD

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
hr; echo "SUBTEST 1 — pure helpers: HEAD-advance detection is progress, not setup"; hr
export GARDEN_SCRATCH="$TR/scratch1"; mkdir -p "$GARDEN_SCRATCH"
# shellcheck source=../common.sh
source "$JOBS/common.sh"

h0="$(mkwt "$GARDEN_SCRATCH/gardener-wt-jobA")"
before="$(job_worktree_heads jobA)"
grep -q "gardener-wt-jobA:$h0" <<<"$before" && ok "job_worktree_heads reports the garden worktree HEAD" \
  || bad "job_worktree_heads missed the worktree (got: $before)"

# (a) HEAD advances across the run → productive.
advance "$GARDEN_SCRATCH/gardener-wt-jobA"
after="$(job_worktree_heads jobA)"
job_cycle_productive "$before" "$after" && ok "a persisted worktree that ADVANCED its HEAD → productive" \
  || bad "advanced HEAD not detected as productive"

# (b) HEAD unchanged across the run → NOT productive (a wedged/idle cycle).
before2="$after"
after2="$(job_worktree_heads jobA)"
job_cycle_productive "$before2" "$after2" && bad "unchanged HEAD falsely flagged productive" \
  || ok "a persisted worktree with UNCHANGED HEAD → not productive"

# (c) a worktree that only APPEARS in `after` (freshly created setup, no commit) does
# NOT count — merely creating a checkout is not progress.
before3="$(job_worktree_heads jobB)"   # empty: jobB has no worktree yet
mkwt "$GARDEN_SCRATCH/gardener-wt-jobB" >/dev/null
after3="$(job_worktree_heads jobB)"
job_cycle_productive "$before3" "$after3" && bad "a newly-created worktree falsely flagged productive" \
  || ok "a worktree that only appears in 'after' (setup) → not productive"

# ============================================================================
hr; echo "SUBTEST 2 — gardener stamps the productive marker on a resumed, advancing cycle"; hr
# A resumed worktree persists from a prior cycle; the handler exits 0 WITHOUT the
# completion signal (the treadmill) but advances the worktree HEAD → productive.
T2="$TR/e2e-prod"; mkdir -p "$T2"
BARE2="$(seed_board "$T2" growjob)"
export GARDEN_SCRATCH="$T2/scratch"; mkdir -p "$GARDEN_SCRATCH"
mkwt "$GARDEN_SCRATCH/gardener-wt-growjob" >/dev/null   # pre-existing (resumed) worktree
env GARDEN="growhost" GARDEN_STATE="$T2/state" JOURNAL_REMOTE="$BARE2" JOURNAL_BRANCH=journal2 \
    GARDEN_SCRATCH="$GARDEN_SCRATCH" GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 \
    GARDEN_STUB_RC=0 GARDEN_STUB_SIGNAL=0 GARDEN_STUB_ADVANCE_HEAD=1 \
    GARDEN_JOB_HANDLER="$STUB" \
    "$JOBS/gardener.sh" 1 > "$T2/gardener.log" 2>&1 || true
V2="$T2/verify"; git clone -q --single-branch --branch journal2 "$BARE2" "$V2" 2>/dev/null
if [ -f "$V2/jobs/doin/growjob.md" ] && grep -Eq '^<!-- garden-productive-cycle -->$' "$V2/jobs/doin/growjob.md"; then
  ok "advancing exit-0 cycle → gardener stamped the productive-cycle marker on the doin claim"
else
  bad "productive marker NOT stamped on an advancing cycle ($(grep -i 'productive\|handler' "$T2/gardener.log" | tail -3))"
fi

# The contrast: same setup but the handler makes NO progress → no productive marker.
T2b="$TR/e2e-noprog"; mkdir -p "$T2b"
BARE2b="$(seed_board "$T2b" stalljob)"
export GARDEN_SCRATCH="$T2b/scratch"; mkdir -p "$GARDEN_SCRATCH"
mkwt "$GARDEN_SCRATCH/gardener-wt-stalljob" >/dev/null
env GARDEN="stallhost" GARDEN_STATE="$T2b/state" JOURNAL_REMOTE="$BARE2b" JOURNAL_BRANCH=journal2 \
    GARDEN_SCRATCH="$GARDEN_SCRATCH" GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 \
    GARDEN_STUB_RC=0 GARDEN_STUB_SIGNAL=0 GARDEN_STUB_ADVANCE_HEAD=0 \
    GARDEN_JOB_HANDLER="$STUB" \
    "$JOBS/gardener.sh" 1 > "$T2b/gardener.log" 2>&1 || true
V2b="$T2b/verify"; git clone -q --single-branch --branch journal2 "$BARE2b" "$V2b" 2>/dev/null
if [ -f "$V2b/jobs/doin/stalljob.md" ] && ! grep -Eq '^<!-- garden-productive-cycle -->$' "$V2b/jobs/doin/stalljob.md"; then
  ok "a no-progress exit-0 cycle → NO productive marker (still requeued via reap-now)"
else
  bad "productive marker wrongly present on a no-progress cycle"
fi

# ============================================================================
hr; echo "SUBTEST 3 — reaper: productive claim resets the counter; non-productive poisons"; hr
T3="$TR/reaper"; mkdir -p "$T3"
BARE3="$(seed_board "$T3" xjob)"   # board structure (job body reused as fixtures below)
export JOURNAL_REMOTE="$BARE3" JOURNAL_BRANCH=journal2
export GARDEN=reaphost GARDEN_STATE="$T3/state"
export GARDEN_POST_ATTEMPTS=50 GARDEN_REAP_PUSH_ATTEMPTS=50
export GARDEN_REAP_POISON_THRESHOLD=1 GARDEN_REAP_OVERRUN_THRESHOLD=2 GARDEN_CLAIM_TTL=3600

# place_stale <base> <productive:0|1> — a STALE claim in doin (claimed_at past TTL),
# optionally carrying the productive-cycle marker in its body.
place_stale() {
  local base="$1" productive="${2:-0}" wt; wt="$(mktemp -d "$T3/edit.XXXXXX")"
  git clone -q --single-branch --branch journal2 "$BARE3" "$wt"
  {
    printf '# %s\n\nthe original work body for %s\n\n' "$base" "$base"
    [ "$productive" = "1" ] && printf '<!-- garden-productive-cycle -->\n'
    printf -- '---\nclaim:\n  host: reaphost\n  gardener: 7\n  claimed_at: 2020-01-01T00:00:00Z\n'
  } > "$wt/jobs/doin/$base.md"
  printf 'worktree_dir: %s\n' "$T3/nonexistent-wt-$base" > "$wt/work/$base"
  git -C "$wt" add "jobs/doin/$base.md" "work/$base"
  git -C "$wt" "${git_id[@]}" commit -q -m "place stale $base"
  git -C "$wt" push -q origin "HEAD:journal2"
  rm -rf "$wt"
}
resync3() { rm -rf "$T3/v"; git clone -q --single-branch --branch journal2 "$BARE3" "$T3/v"; }

# A productive stale claim must NOT poison even at threshold 1: it requeues to todo
# with the counter RESET to 0 and the productive marker stripped (re-earned next cycle).
place_stale prodjob 1
"$JOBS/reaper.sh" > "$T3/reap-prod.log" 2>&1 || { echo "  (reaper rc=$?)"; sed 's/^/    /' "$T3/reap-prod.log"; }
resync3
prod_ok=1
[ -f "$T3/v/jobs/todo/prodjob.md" ] || { prod_ok=0; echo "    prodjob not requeued to todo/"; }
[ -f "$T3/v/jobs/plan/prodjob.md" ] && { prod_ok=0; echo "    prodjob was POISONED (parked in plan/) despite progress"; }
[ -f "$T3/v/jobs/doin/prodjob.md" ] && { prod_ok=0; echo "    prodjob still in doin/"; }
if [ -f "$T3/v/jobs/todo/prodjob.md" ]; then
  grep -Eq '^<!-- garden-reaped: 0 -->$' "$T3/v/jobs/todo/prodjob.md" || { prod_ok=0; echo "    reap counter not reset to 0"; }
  grep -Eq '^<!-- garden-productive-cycle -->$' "$T3/v/jobs/todo/prodjob.md" && { prod_ok=0; echo "    productive marker not stripped on requeue"; }
fi
[ "$prod_ok" -eq 1 ] \
  && ok "a PRODUCTIVE cycle at threshold 1 → requeued to todo (counter reset to 0, marker stripped), NOT poisoned" \
  || bad "productive-cycle reset failed (todo=$([ -f "$T3/v/jobs/todo/prodjob.md" ] && echo y || echo n) plan=$([ -f "$T3/v/jobs/plan/prodjob.md" ] && echo y || echo n))"

# The genuine-failure case is preserved: a NON-productive stale claim poisons at the
# same threshold — parked in plan/ (held), gone from doin, not in todo.
place_stale failjob 0
"$JOBS/reaper.sh" > "$T3/reap-fail.log" 2>&1 || { echo "  (reaper rc=$?)"; sed 's/^/    /' "$T3/reap-fail.log"; }
resync3
fail_ok=1
[ -f "$T3/v/jobs/plan/failjob.md" ] || { fail_ok=0; echo "    failjob not poisoned/parked in plan/"; }
[ -f "$T3/v/jobs/todo/failjob.md" ] && { fail_ok=0; echo "    failjob leaked into todo/ (should have poisoned)"; }
[ -f "$T3/v/jobs/doin/failjob.md" ] && { fail_ok=0; echo "    failjob still in doin/"; }
[ -f "$T3/v/jobs/plan/failjob.md" ] && { grep -q '^poisoned: true$' "$T3/v/jobs/plan/failjob.md" || { fail_ok=0; echo "    plan entry missing poisoned provenance"; }; }
[ "$fail_ok" -eq 1 ] \
  && ok "a NON-productive cycle still POISONS at the threshold (parked in plan/, held) — genuine-failure case preserved" \
  || bad "non-productive poison broke (plan=$([ -f "$T3/v/jobs/plan/failjob.md" ] && echo y || echo n) todo=$([ -f "$T3/v/jobs/todo/failjob.md" ] && echo y || echo n))"

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
