#!/bin/bash
# worktree-sweeper-tmpexec-test.sh — pin the sweeper's reclaim of idle entries in
# $GARDEN_SCRATCH/tmpexec, and everything it must leave alone.
#
# Usage: worktree-sweeper-tmpexec-test.sh
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
# shellcheck source=test-tmpdir.sh
source "$HERE/test-tmpdir.sh"
TR="$(mktemp -d "$(garden_test_exec_tmpdir)/worktree-sweeper-tmpexec.XXXXXXXX")"
LIVE_PID=""; FD_PID=""
trap 'kill $LIVE_PID $FD_PID 2>/dev/null; rm -rf "$TR"' EXIT
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS + 1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL + 1)); }
git_id=(-c user.name=test -c user.email=test@localhost)

GROOT="$TR/garden"; SCRATCH="$GROOT/scratch"; STATE="$TR/state"
mkdir -p "$GROOT/worktrees" "$SCRATCH" "$STATE"
git init -q "$GROOT"
git -C "$GROOT" "${git_id[@]}" commit -q --allow-empty -m root
git -C "$GROOT" branch -M main2

JBARE="$TR/journal.git"; JSEED="$TR/journal-seed"
git init -q --bare "$JBARE"
git init -q "$JSEED"; git -C "$JSEED" checkout -qb journal2
mkdir -p "$JSEED/jobs/tada" "$JSEED/jobs/doin" "$JSEED/jobs/plan"
touch "$JSEED/jobs/doin/.keep"
git -C "$JSEED" "${git_id[@]}" add jobs
git -C "$JSEED" "${git_id[@]}" commit -qm journal
git -C "$JSEED" remote add origin "$JBARE"
git -C "$JSEED" push -q origin journal2

TE="$SCRATCH/tmpexec"
mkdir -p "$TE"
# make_entry <name> : a directory whose every entry is ten days old.
make_entry() {
  mkdir -p "$TE/$1/sub"
  printf 'x\n' > "$TE/$1/sub/file"
  find "$TE/$1" -exec touch -d '10 days ago' {} +
}
make_entry idle-dir
make_entry .idle-hidden-dir
printf 'x\n' > "$TE/idle-file"; touch -d '10 days ago' "$TE/idle-file"
make_entry deep-recent; touch "$TE/deep-recent/sub/file"
make_entry claude-501
make_entry cwd-held
make_entry fd-held
mkdir -p "$TR/outside"; printf 'x\n' > "$TR/outside/keep"
ln -s "$TR/outside" "$TE/old-link"; touch -h -d '10 days ago' "$TE/old-link"
mkdir "$TE/recent-dir"
outside_scratch="$SCRATCH/not-tmpexec"; mkdir -p "$outside_scratch"; touch -d '10 days ago' "$outside_scratch"

(cd "$TE/cwd-held/sub" && exec sleep 300) &
LIVE_PID=$!
sleep 300 <"$TE/fd-held/sub/file" &
FD_PID=$!
sleep 0.2
# Holding them open must not have refreshed the mtimes under test.
find "$TE/cwd-held" "$TE/fd-held" -exec touch -d '10 days ago' {} +

sweep() { # sweep [idle-days]; without one, the script's default applies
  env ${1:+GARDEN_TMPEXEC_IDLE_DAYS="$1"} GARDEN=hostb-garden-bbbb2222 GARDEN_LEADER=hosta-garden-aaaa1111 GARDEN_ROOT="$GROOT" \
    GARDEN_SCRATCH="$SCRATCH" GARDEN_STATE="$STATE" JOURNAL_REMOTE="$JBARE" JOURNAL_BRANCH=journal2 \
    GARDEN_WORKTREE_SWEEP_MAX=100 ${SWEEP_SECS:+GARDEN_TMPEXEC_SWEEP_SECS="$SWEEP_SECS"} \
    GARDEN_GH="$HERE/worktree-sweeper-gh-stub.sh" WORKTREE_SWEEPER_GH_CALLS="$TR/gh-calls" \
    bash "$JOBS/worktree-sweeper.sh" >"$TR/sweep.log" 2>&1
}

sweep 0
[ -d "$TE/idle-dir" ] && ok "idle-days 0 disables the pass" || bad "idle-days 0 removed an entry"

SWEEP_SECS=0 sweep
[ -d "$TE/idle-dir" ] && ok "an exhausted time budget removes nothing" || bad "removed past its time budget"

sweep; rc=$?
[ "$rc" -eq 0 ] && ok "sweep exited 0" || { bad "sweep exited $rc"; cat "$TR/sweep.log"; }
for name in idle-dir .idle-hidden-dir idle-file old-link; do
  [ ! -e "$TE/$name" ] && [ ! -L "$TE/$name" ] && ok "removed $name" || bad "$name survived"
done
grep -q 'removed 4 idle tmpexec entries' "$TR/sweep.log" && ok "logged one summary" || bad "summary not logged"
[ -f "$TR/outside/keep" ] && ok "did not follow a symlink" || bad "followed a symlink"
for name in deep-recent claude-501 cwd-held fd-held recent-dir; do
  [ -e "$TE/$name" ] && ok "kept $name" || bad "removed $name"
done
[ -d "$outside_scratch" ] && ok "left the rest of scratch alone" || bad "removed outside tmpexec"

kill "$LIVE_PID" "$FD_PID" 2>/dev/null; wait "$LIVE_PID" "$FD_PID" 2>/dev/null; LIVE_PID=""; FD_PID=""
sweep
[ ! -e "$TE/cwd-held" ] && [ ! -e "$TE/fd-held" ] && ok "removed held entries once their processes exited" \
  || bad "held entries survived after their processes exited"

echo
echo "worktree sweeper (tmpexec): $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
