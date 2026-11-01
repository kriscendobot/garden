#!/bin/bash
# post-loop-wallclock-deadline-test.sh — the overall wall-clock deadline on the
# push-CAS retry loops of post-job.sh, post-plan.sh, and post-orchestration.sh
# (improve-post-job-push-loop-wallclock-deadline,
# improve-post-orchestration-loop-deadline).
#
# The gap it closes: both loops were bounded only by attempt COUNT
# (GARDEN_POST_ATTEMPTS), not elapsed wall-clock time. Each attempt's sync_clone can
# burn up to ~GARDEN_FETCH_TIMEOUT+GARDEN_FETCH_KILL_AFTER seconds, so a degraded
# (not cleanly offline) journal could keep the loop grinding for tens of minutes —
# past a watcher unit's TimeoutStartSec (e.g. the comment-watcher's 900s), ending in
# a blunt SIGKILL + Failed unit that self-heal-run.sh never classifies (the kill hits
# the wrapper itself). The fix: a GARDEN_POST_DEADLINE_SECS bound, checked at the top
# of each attempt; once exceeded the loop bails EX_TEMPFAIL (GARDEN_OFFLINE_RC), the
# same clean offline-style skip sync_clone takes on a real outage.
#
# Asserts, for BOTH post-job.sh and post-plan.sh:
#   1. With the deadline already exceeded (GARDEN_POST_DEADLINE_SECS=0), the loop
#      bails on the FIRST attempt with exit code GARDEN_OFFLINE_RC and writes NO job
#      (it never reaches sync_clone/commit for that attempt).
#   2. With the default (ample) deadline, a healthy post still succeeds and lands the
#      job — the deadline never trims a fast, well-connected loop.
# And for post-orchestration.sh (whose every attempt holds the producer clone lock,
# so an unbounded loop starves every other producer — the 2026-11-01 30-minute hold):
#   4. A blown deadline bails rc=75 on the first attempt and records nothing.
#   5. A degraded journal (every push fails) with a 50-attempt budget gives up at the
#      wall-clock deadline with rc=75, quickly, records nothing, and releases the
#      producer clone so the next producer can post.
#   6. A healthy orchestration still records under the default deadline.
#
# Hermetic: a throwaway bare journal; no real garden, journal, or network.
#
# Usage: post-loop-wallclock-deadline-test.sh

# shellcheck disable=SC2015
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/post-loop-wallclock-deadline-test.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
trap 'rm -rf "$TR"' EXIT

# Scrub any ambient fleet GARDEN_*/JOURNAL_* so a live gardener invoking this test
# cannot splice the real journal under it (the run-test.sh isolation rationale).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_)' || true) 2>/dev/null || true

# --- throwaway journal ------------------------------------------------------
BARE="$TR/journal.git"; git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"; git -C "$SEED" checkout -q -b journal2
( cd "$SEED"
  mkdir -p jobs/plan jobs/todo jobs/doin jobs/tada jobs/index
  touch jobs/plan/.gitkeep jobs/todo/.gitkeep jobs/doin/.gitkeep \
        jobs/tada/.gitkeep jobs/index/.gitkeep
  git add -A
  git -c user.name=test -c user.email=test@localhost commit -q -m seed
  git remote add origin "$BARE"
  git push -q -u origin journal2 )

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
       GARDEN_STATE="$TR/state" GARDEN_PRODUCER_CLONE="$TR/state/producer/journal" \
       GARDEN=idhost GARDEN_ROLE=gardener GARDEN_NO_MAINTAINER_ALERT=1

tree()     { git -C "$BARE" ls-tree -r --name-only journal2; }
has_todo() { tree | grep -qx "jobs/todo/$1.md"; }
has_plan() { tree | grep -qx "jobs/plan/$1.md"; }
bodyfile() { local f; f="$(mktemp "$TR/body.XXXXXX")"; printf '%s\n' "$1" > "$f"; printf '%s' "$f"; }

echo "================================================================"
echo "POST-LOOP WALL-CLOCK DEADLINE"
echo "================================================================"

# --- 1: post-job.sh bails EX_TEMPFAIL past the deadline, writes no job -------
GARDEN_POST_DEADLINE_SECS=0 "$JOBS/post-job.sh" past-deadline-job \
  "$(bodyfile 'should never land — deadline already blown')" >/dev/null 2>&1
rc=$?
[ "$rc" -eq 75 ] && ok "1a post-job.sh bailed with GARDEN_OFFLINE_RC (75), got $rc" \
                 || bad "1a post-job.sh exit code was $rc, expected 75"
! has_todo past-deadline-job && ok "1b post-job.sh wrote no job past the deadline" \
                             || bad "1b post-job.sh wrote a job despite the blown deadline"

# --- 2: post-plan.sh bails EX_TEMPFAIL past the deadline, parks no job -------
GARDEN_POST_DEADLINE_SECS=0 "$JOBS/post-plan.sh" past-deadline-plan \
  "$(bodyfile 'should never park — deadline already blown')" >/dev/null 2>&1
rc=$?
[ "$rc" -eq 75 ] && ok "2a post-plan.sh bailed with GARDEN_OFFLINE_RC (75), got $rc" \
                 || bad "2a post-plan.sh exit code was $rc, expected 75"
! has_plan past-deadline-plan && ok "2b post-plan.sh parked no job past the deadline" \
                              || bad "2b post-plan.sh parked a job despite the blown deadline"

# --- 3: default (ample) deadline still lets a healthy post through ----------
"$JOBS/post-job.sh" healthy-job "$(bodyfile 'a normal, fast post')" >/dev/null 2>&1
rc=$?
[ "$rc" -eq 0 ] && ok "3a post-job.sh succeeded under the default deadline (rc=0)" \
               || bad "3a post-job.sh rc was $rc under the default deadline"
has_todo healthy-job && ok "3b post-job.sh landed the healthy job" \
                     || bad "3b post-job.sh did not land the healthy job"

"$JOBS/post-plan.sh" healthy-plan "$(bodyfile 'a normal, fast park')" >/dev/null 2>&1
rc=$?
[ "$rc" -eq 0 ] && ok "3c post-plan.sh succeeded under the default deadline (rc=0)" \
               || bad "3c post-plan.sh rc was $rc under the default deadline"
has_plan healthy-plan && ok "3d post-plan.sh parked the healthy job" \
                      || bad "3d post-plan.sh did not park the healthy job"

has_orch() { tree | grep -qx "jobs/orch/$1.md"; }

# --- 4: post-orchestration.sh bails EX_TEMPFAIL past the deadline -----------
"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-past --role gardener oc-past </dev/null >/dev/null 2>&1
GARDEN_POST_DEADLINE_SECS=0 "$JOBS/post-orchestration.sh" --serial orch-past oc-past </dev/null \
  >/dev/null 2>&1
rc=$?
[ "$rc" -eq 75 ] && ok "4a post-orchestration.sh bailed with GARDEN_OFFLINE_RC (75), got $rc" \
                 || bad "4a post-orchestration.sh exit code was $rc, expected 75"
! has_orch orch-past && ok "4b post-orchestration.sh recorded nothing past the deadline" \
                     || bad "4b post-orchestration.sh recorded despite the blown deadline"

# --- 5: a degraded journal (every push fails) ends at the deadline ----------
"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-degraded --role gardener oc-deg </dev/null >/dev/null 2>&1
start=$SECONDS
GARDEN_PUSH_CMD=false GARDEN_POST_ATTEMPTS=50 GARDEN_POST_DEADLINE_SECS=1 \
  "$JOBS/post-orchestration.sh" --serial orch-degraded oc-deg </dev/null > "$TR/degraded.out" 2>&1
rc=$?
elapsed=$((SECONDS - start))
[ "$rc" -eq 75 ] && ok "5a degraded post-orchestration.sh gave up with rc=75" \
                 || { cat "$TR/degraded.out"; bad "5a degraded post-orchestration.sh rc was $rc, expected 75"; }
[ "$elapsed" -lt 30 ] && ok "5b gave up in ${elapsed}s, not the whole 50-attempt budget" \
                      || bad "5b degraded give-up took ${elapsed}s"
grep -q 'wall-clock deadline' "$TR/degraded.out" \
  && ok "5c the deadline give-up was logged" || bad "5c the deadline give-up was not logged"
! has_orch orch-degraded && ok "5d nothing was recorded through the failing push" \
                         || bad "5d an orchestration landed despite the failing push"
"$JOBS/post-job.sh" after-degraded "$(bodyfile 'producer clone is free again')" >/dev/null 2>&1
rc=$?
{ [ "$rc" -eq 0 ] && has_todo after-degraded; } \
  && ok "5e the next producer posted through the released clone" \
  || bad "5e the next producer could not post after the deadline give-up (rc=$rc)"

# --- 6: default deadline still records a healthy orchestration --------------
"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-healthy --role gardener oc-ok </dev/null >/dev/null 2>&1
"$JOBS/post-orchestration.sh" --serial orch-healthy oc-ok </dev/null >/dev/null 2>&1
rc=$?
{ [ "$rc" -eq 0 ] && has_orch orch-healthy; } \
  && ok "6 post-orchestration.sh recorded the healthy orchestration (rc=0)" \
  || bad "6 healthy post-orchestration.sh rc=$rc or no record"

echo "----------------------------------------------------------------"
echo "post-loop wall-clock deadline: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
