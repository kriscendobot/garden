#!/bin/bash
# stale-lock-test.sh — regression guard for the producer-clone stale-lock recovery.
#
# PRODUCER WEDGE (2026-06-26): two post-plan.sh runs raced the shared producer
# clone's journal.lock; when they were killed a 0-byte journal.lock remained and
# silently wedged EVERY later post — blocked, no timeout, no recovery, until a
# manual `rm -f .../producer/journal.lock`. flock frees a dead holder on fd close,
# but a KILLED holder whose child inherited the fd keeps the lock alive (an
# orphan), so flock alone could not recover. clone_lock is now STALE-AWARE: the
# holder stamps "PID EPOCH" into the lock file and a waiter that times out
# reclaims the lock when that holder is dead or older than GARDEN_LOCK_TTL.
#
# The checks assert three properties with a REAL held flock and a controlled
# stamp: (1) a fresh live holder is NEVER stolen from (exclusion preserved);
# (2) a dead-PID stamp is reclaimed (the orphaned-child case); (3) an ancient
# stamp from a live-but-hung holder is reclaimed via the TTL. A 4th end-to-end
# check confirms a stale tombstone left on a real producer clone does not wedge a
# fresh post.
#
# Usage: stale-lock-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

TR=/home/kris/.garden-stale-lock-test
rm -rf "$TR"; mkdir -p "$TR"

# shellcheck source=../common.sh
source "$JOBS/common.sh"

# hold_lock <lockfile> <stamp> — background a process that takes the real flock on
# <lockfile>, writes <stamp> ("PID EPOCH") as the holder's identity, and sleeps so
# the lock stays held for the duration of the subtest. Echoes the holder PID.
hold_lock() {
  local lf="$1" stamp="$2"
  # Redirect the holder's stdio to /dev/null so it does NOT keep the caller's
  # command-substitution pipe open (which would block $(hold_lock ...) for 30s).
  ( exec {h}<>"$lf"; flock "$h"; printf '%s\n' "$stamp" >&"$h"; sleep 30 ) >/dev/null 2>&1 &
  echo $!
}
# race_waiter <dir> — run clone_lock against <dir> with a 1s wait / 1 retry / 2
# steals budget in a subshell (so its held fd + env never leak). Echoes elapsed
# seconds on stderr-free stdout via the caller; returns clone_lock's rc.
race_waiter() {
  ( export GARDEN_LOCK_WAIT=1 GARDEN_LOCK_RETRIES=1 GARDEN_LOCK_STEALS=2 GARDEN_LOCK_TTL=300
    clone_lock "$1" ) >/dev/null 2>&1
}

# ============================================================================
hr; echo "SUBTEST 1 — a fresh LIVE holder is NOT stolen from (exclusion held)"; hr
D1="$TR/d1"; mkdir -p "$D1"; LF1="$D1.lock"
h1="$(hold_lock "$LF1" "$$ $(date +%s)")"   # live pid ($$ is this test) + fresh time
sleep 1
start="$(date +%s)"
if race_waiter "$D1"; then wrc=0; else wrc=1; fi
elapsed=$(( $(date +%s) - start ))
kill "$h1" 2>/dev/null || true; wait "$h1" 2>/dev/null || true
[ "$wrc" -ne 0 ] && ok "waiter gave up (rc=$wrc) — a busy live holder is never stolen from" \
                 || bad "waiter ACQUIRED a fresh live holder's lock (exclusion broken)"
[ "$elapsed" -lt 15 ] && ok "waiter returned in ${elapsed}s (bounded, not blocked)" \
                      || bad "waiter took ${elapsed}s — it blocked"

# ============================================================================
hr; echo "SUBTEST 2 — a DEAD-PID holder is reclaimed (orphaned-child-of-killed-run)"; hr
# Reap a short-lived process so its PID is gone, then stamp the lock with it: the
# orphan still holds flock, but the recorded acquirer is dead → reclaimable.
sh -c 'exit 0' & deadpid=$!; wait "$deadpid" 2>/dev/null || true
D2="$TR/d2"; mkdir -p "$D2"; LF2="$D2.lock"
h2="$(hold_lock "$LF2" "$deadpid $(date +%s)")"   # dead pid + fresh time
sleep 1
start="$(date +%s)"
if race_waiter "$D2"; then wrc=0; else wrc=1; fi
elapsed=$(( $(date +%s) - start ))
kill "$h2" 2>/dev/null || true; wait "$h2" 2>/dev/null || true
[ "$wrc" -eq 0 ] && ok "waiter reclaimed + acquired the lock of a dead holder" \
                 || bad "waiter did NOT recover from a dead-holder stamp (rc=$wrc)"
[ "$elapsed" -lt 15 ] && ok "recovery was bounded (${elapsed}s)" \
                      || bad "recovery took ${elapsed}s"

# ============================================================================
hr; echo "SUBTEST 3 — a live-but-ANCIENT holder is reclaimed via the TTL"; hr
D3="$TR/d3"; mkdir -p "$D3"; LF3="$D3.lock"
h3="$(hold_lock "$LF3" "$$ 100")"   # live pid, epoch 100 (1970) → far older than TTL
sleep 1
start="$(date +%s)"
if race_waiter "$D3"; then wrc=0; else wrc=1; fi
elapsed=$(( $(date +%s) - start ))
kill "$h3" 2>/dev/null || true; wait "$h3" 2>/dev/null || true
[ "$wrc" -eq 0 ] && ok "waiter reclaimed + acquired the lock of a hung (>TTL) holder" \
                 || bad "waiter did NOT recover from an ancient stamp (rc=$wrc)"
[ "$elapsed" -lt 15 ] && ok "recovery was bounded (${elapsed}s)" \
                      || bad "recovery took ${elapsed}s"

# ============================================================================
hr; echo "SUBTEST 4 — a stale tombstone on a real producer clone does not wedge a post"; hr
# Seed a throwaway journal origin so post-job runs end to end.
BARE="$TR/journal.git"; git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"; git -C "$SEED" checkout -q -b journal2
git -C "$SEED" -c user.name=t -c user.email=t@l commit -q --allow-empty -m init >/dev/null
( cd "$SEED"; mkdir -p jobs/todo jobs/doin jobs/tada; for d in jobs/todo jobs/doin jobs/tada; do touch "$d/.gitkeep"; done )
git -C "$SEED" add -A; git -C "$SEED" -c user.name=t -c user.email=t@l commit -q -m seed >/dev/null
git -C "$SEED" remote add origin "$BARE"; git -C "$SEED" push -q -u origin journal2
export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 GARDEN_STATE="$TR/state"
# First post creates the producer clone.
echo "# a" | "$JOBS/post-job.sh" stale-pre >/dev/null 2>&1 || true
CLONE="$TR/state/producer/journal"; TOMB="$CLONE.lock"
# Simulate a crashed run: leave a stale tombstone (dead pid + ancient time), no holder.
printf '%s %s\n' "$deadpid" 100 > "$TOMB"
start="$(date +%s)"
if echo "# b" | timeout 60 "$JOBS/post-job.sh" stale-post >/dev/null 2>&1; then prc=0; else prc=1; fi
elapsed=$(( $(date +%s) - start ))
V="$TR/verify"; git clone -q --single-branch --branch journal2 "$BARE" "$V" 2>/dev/null
landed=0; [ -f "$V/jobs/todo/stale-post.md" ] && landed=1
{ [ "$prc" -eq 0 ] && [ "$landed" -eq 1 ]; } \
  && ok "fresh post recovered past a stale tombstone and landed (${elapsed}s)" \
  || bad "post wedged on a stale tombstone (rc=$prc landed=$landed elapsed=${elapsed}s)"

# ============================================================================
hr
rm -rf "$TR"
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
