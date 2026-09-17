#!/bin/bash
# post-loop-wallclock-deadline-test.sh — the overall wall-clock deadline on the
# push-CAS retry loops of post-job.sh and post-plan.sh
# (improve-post-job-push-loop-wallclock-deadline).
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

echo "----------------------------------------------------------------"
echo "post-loop wall-clock deadline: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
