#!/bin/bash
# cursor-set-concurrency-test.sh — regression guard for the shared cursor-clone race.
#
# THE BUG (observed live on endolin-garden-ece02cb4, 2026-09-20/21): the
# endojs-endo-but-for-bots comment-watcher's cursor made ZERO committed progress for
# ~24h while `git fatal: unable to write new index file` recurred and TWO concurrent
# cursor-set.sh ran against the SAME shared local clone. cursor-set (and cursor-get)
# operate on ONE per-host clone ($GARDEN_CURSOR_CLONE) reused by every watcher, but
# their index-touching git steps ran with NO lock held in the parent shell:
# `( sync_clone "$DIR" )` in a subshell takes clone_lock and drops it the instant the
# subshell exits, BEFORE the parent-shell `git add`/commit/push (cursor-set) or read
# (cursor-get) — so two overlapping invocations raced the same index. The fix is a
# host-local cursor-IO flock held in the PARENT shell across the whole critical
# section, taken by BOTH scripts (common.sh cursor_io_lock).
#
# This is a REAL concurrency test: it launches many cursor-set writers on distinct
# keys AND cursor-get readers (whose `reset --hard` mutates the same index) all at
# once against one shared clone, then asserts every writer landed its value with no
# "unable to write new index file" and no nonzero exit. It does NOT merely assert the
# lock is acquired in isolation.
#
# Usage: cursor-set-concurrency-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

TR=/home/kris/.garden-cursor-concurrency-test
rm -rf "$TR"; mkdir -p "$TR"

# --- throwaway journal origin so cursor-set/cursor-get run end to end -----------
BARE="$TR/journal.git"; git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"; git -C "$SEED" checkout -q -b journal2
git -C "$SEED" -c user.name=t -c user.email=t@l commit -q --allow-empty -m init >/dev/null
( cd "$SEED"; mkdir -p cursors; touch cursors/.gitkeep )
git -C "$SEED" add -A; git -C "$SEED" -c user.name=t -c user.email=t@l commit -q -m seed >/dev/null
git -C "$SEED" remote add origin "$BARE"; git -C "$SEED" push -q -u origin journal2

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 GARDEN_STATE="$TR/state"
CLONE="$TR/state/cursors/journal"
export GARDEN_CURSOR_CLONE="$CLONE"

# Prime the shared clone once (serially) so the concurrent round races the WRITE
# path, not the cold-clone creation.
printf 'last_polled_at: prime\n' | "$JOBS/cursor-set.sh" prime >/dev/null 2>&1 || true

# ============================================================================
hr; echo "SUBTEST 1 — N concurrent cursor-set writers + cursor-get readers, one clone"; hr
N=8
LOGDIR="$TR/logs"; mkdir -p "$LOGDIR"
pids=()
# Fire all writers and readers as close to simultaneously as the shell can manage.
for i in $(seq 1 "$N"); do
  ( printf 'last_polled_at: race-%s\n' "$i" \
      | "$JOBS/cursor-set.sh" "race-key-$i" >"$LOGDIR/set-$i.out" 2>"$LOGDIR/set-$i.err"
    echo "$?" > "$LOGDIR/set-$i.rc" ) &
  pids+=($!)
  ( "$JOBS/cursor-get.sh" prime >"$LOGDIR/get-$i.out" 2>"$LOGDIR/get-$i.err"
    echo "$?" > "$LOGDIR/get-$i.rc" ) &
  pids+=($!)
done
for p in "${pids[@]}"; do wait "$p" 2>/dev/null || true; done

# (a) No git index-corruption anywhere in the captured stderr.
if grep -rilq "unable to write new index file" "$LOGDIR"; then
  bad "saw 'unable to write new index file' — the shared-clone index race is live"
  grep -ril "unable to write new index file" "$LOGDIR" | sed 's/^/    /'
else
  ok "no 'unable to write new index file' across $N concurrent set + $N get runs"
fi

# (b) Every writer exited 0.
set_fail=0
for i in $(seq 1 "$N"); do
  rc="$(cat "$LOGDIR/set-$i.rc" 2>/dev/null || echo missing)"
  if [ "$rc" != 0 ]; then set_fail=$((set_fail+1)); echo "    writer race-key-$i exited rc=$rc"; sed 's/^/      /' "$LOGDIR/set-$i.err" 2>/dev/null | tail -5; fi
done
[ "$set_fail" -eq 0 ] && ok "all $N concurrent cursor-set writers exited 0" \
                      || bad "$set_fail/$N concurrent cursor-set writers failed"

# (c) Readers never hard-failed (rc 0 = read ok, or the temporary-unavailable skip).
get_fail=0
for i in $(seq 1 "$N"); do
  rc="$(cat "$LOGDIR/get-$i.rc" 2>/dev/null || echo missing)"
  case "$rc" in 0|"${GARDEN_OFFLINE_RC:-75}") : ;; *) get_fail=$((get_fail+1)); echo "    reader $i exited rc=$rc"; sed 's/^/      /' "$LOGDIR/get-$i.err" 2>/dev/null | tail -5 ;; esac
done
[ "$get_fail" -eq 0 ] && ok "all $N concurrent cursor-get readers were clean (read or temp-skip)" \
                      || bad "$get_fail/$N concurrent cursor-get readers hard-failed"

# (d) Every writer's value actually LANDED on the remote (no silently-lost commits).
V="$TR/verify"; rm -rf "$V"
git clone -q --single-branch --branch journal2 "$BARE" "$V" 2>/dev/null
landed=0
for i in $(seq 1 "$N"); do
  if [ -f "$V/cursors/race-key-$i" ] && grep -q "race-$i" "$V/cursors/race-key-$i"; then
    landed=$((landed+1))
  else
    echo "    cursors/race-key-$i missing or wrong on the remote"
  fi
done
[ "$landed" -eq "$N" ] && ok "all $N cursor values are durably committed on origin/journal2" \
                       || bad "only $landed/$N cursor values landed (some writes were lost)"

# ============================================================================
hr; echo "SUBTEST 2 — distinct clones serialize INDEPENDENTLY (no false cross-clone block)"; hr
# The lock is keyed per-clone ($DIR.cursor-io.lock), so two cursor-set runs on
# DIFFERENT clones must not block each other. Hold clone A's lock, then confirm a
# write to clone B still completes promptly.
CLONE_A="$TR/state/cursors/journal"           # already primed above
CLONE_B="$TR/state-b/cursors/journal"
lf_a="${CLONE_A%/}.cursor-io.lock"
mkdir -p "$(dirname "$lf_a")"
( exec {h}<>"$lf_a"; flock "$h"; sleep 20 ) >/dev/null 2>&1 &   # hold clone A's cursor-IO lock
holder=$!
sleep 1
start="$(date +%s)"
if printf 'last_polled_at: clone-b\n' \
    | GARDEN_CURSOR_CLONE="$CLONE_B" timeout 30 "$JOBS/cursor-set.sh" b-key >/dev/null 2>&1; then brc=0; else brc=$?; fi
elapsed=$(( $(date +%s) - start ))
kill "$holder" 2>/dev/null || true; wait "$holder" 2>/dev/null || true
{ [ "$brc" -eq 0 ] && [ "$elapsed" -lt 20 ]; } \
  && ok "a write to clone B completed in ${elapsed}s while clone A's lock was held (no false block)" \
  || bad "clone B was blocked by clone A's lock (rc=$brc elapsed=${elapsed}s) — the lock is not per-clone"

# ============================================================================
hr; echo "SUBTEST 3 — a WEDGED holder is TEMPORARY-unavailable (bounded, quiet skip, holder named)"; hr
# Hold clone A's cursor-IO lock and confirm a competing cursor-set returns the
# temporary-unavailable verdict (GARDEN_OFFLINE_RC) within a short bounded wait — NOT
# a fatal die, and NOT an infinite hang — logging a safe holder diagnostic with NO
# `rm -f` advice. This is the improve-cursor-io-lock-recovery contract: a 5-minute lock
# wedge must not hard-fail cursor advancement across watchers.
( exec {h}<>"$lf_a"; flock "$h"; sleep 20 ) >/dev/null 2>&1 &
holder=$!
sleep 1
start="$(date +%s)"
if printf 'last_polled_at: wedged\n' \
    | GARDEN_CURSOR_LOCK_WAIT=3 timeout 30 "$JOBS/cursor-set.sh" wedged-key >"$LOGDIR/wedged.out" 2>"$LOGDIR/wedged.err"; then wrc=0; else wrc=$?; fi
elapsed=$(( $(date +%s) - start ))
kill "$holder" 2>/dev/null || true; wait "$holder" 2>/dev/null || true
{ [ "$wrc" -eq "${GARDEN_OFFLINE_RC:-75}" ] && [ "$elapsed" -lt 15 ] \
    && grep -qi "cursor-IO lock for .* busy" "$LOGDIR/wedged.err"; } \
  && ok "cursor-set skipped temporary-unavailable (rc=$wrc) in ${elapsed}s on a wedged holder (not a die, not a hang)" \
  || bad "cursor-set did not return temporary-unavailable+bounded on a wedged holder (rc=$wrc elapsed=${elapsed}s)"
# The diagnostic must NEVER advise deleting the lock file (rm on an flock'd file does
# not free the flock and can hand two writers the shared index at once).
if grep -qi "rm -f" "$LOGDIR/wedged.err"; then
  bad "wedged-holder diagnostic still advises 'rm -f' the lock file (unsafe recovery advice)"
else
  ok "wedged-holder diagnostic carries NO 'rm -f' lock-deletion advice"
fi
# The diagnostic must NAME the holder (a live pid), so a real wedge is actionable.
if grep -qiE "held by live pid [0-9]+|last holder pid [0-9]+|holder unknown|no holder stamp" "$LOGDIR/wedged.err"; then
  ok "wedged-holder diagnostic names the lock holder (safe recovery diagnostic present)"
else
  bad "wedged-holder diagnostic did not describe the lock holder"
fi

# ============================================================================
hr
rm -rf "$TR"
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
