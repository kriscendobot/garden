#!/bin/bash
# Regression: a process can enter a terminal checkout while the sweeper waits
# for its repository lock.  The destructive path must sample liveness after
# that wait, not before it.

set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
# shellcheck source=test-tmpdir.sh
source "$HERE/test-tmpdir.sh"
TR="$(mktemp -d "$(garden_test_exec_tmpdir)/worktree-sweeper-lock-liveness.XXXXXXXX")"
trap 'rm -rf "$TR"' EXIT
git_id=(-c user.name=test -c user.email=test@localhost)

GROOT="$TR/garden"; SCRATCH="$GROOT/scratch"; STATE="$TR/state"
mkdir -p "$GROOT/worktrees" "$SCRATCH" "$STATE"
git init -q "$GROOT"
printf 'root\n' > "$GROOT/root.txt"
git -C "$GROOT" "${git_id[@]}" add root.txt
git -C "$GROOT" "${git_id[@]}" commit -qm root
git -C "$GROOT" branch -M main2

PBARE="$GROOT/worktrees/acme-late.git"; PSEED="$TR/project-seed"
git init -q --bare "$PBARE"
git init -q "$PSEED"
printf 'project\n' > "$PSEED/file"
git -C "$PSEED" "${git_id[@]}" add file
git -C "$PSEED" "${git_id[@]}" commit -qm seed
git -C "$PSEED" branch -M main
git -C "$PSEED" remote add origin "$PBARE"
git -C "$PSEED" push -q origin main

JBARE="$TR/journal.git"; JSEED="$TR/journal-seed"
git init -q --bare "$JBARE"
git init -q "$JSEED"; git -C "$JSEED" checkout -qb journal2
mkdir -p "$JSEED/jobs/tada/2026/01/01" "$JSEED/jobs/doin" "$JSEED/jobs/todo" "$JSEED/jobs/plan"
printf 'terminal attempt\n' > "$JSEED/jobs/tada/2026/01/01/late-live.md"
git -C "$JSEED" "${git_id[@]}" add jobs
git -C "$JSEED" "${git_id[@]}" commit -qm journal
git -C "$JSEED" remote add origin "$JBARE"
git -C "$JSEED" push -q origin journal2

key="$({ GARDEN_ROOT="$GROOT" GARDEN_STATE="$STATE"; export GARDEN_ROOT GARDEN_STATE; source "$JOBS/common.sh"; project_worktree_base_key late-live; })"
late_wt="$SCRATCH/project-wt-${key}-00000001"
git --git-dir="$PBARE" worktree add -q --detach "$late_wt" main

lock_ready="$TR/lock-ready"; lock_release="$TR/lock-release"
GARDEN_ROOT="$GROOT" GARDEN_STATE="$STATE" bash -c '
  source "$1"
  garden_repo_lock "$2" exclusive || exit
  : > "$3"
  while [ ! -e "$4" ]; do sleep 0.05; done
  garden_repo_unlock "$2"
' _ "$JOBS/common.sh" "$PBARE" "$lock_ready" "$lock_release" &
lock_pid=$!
for _ in $(seq 1 200); do [ -e "$lock_ready" ] && break; sleep 0.05; done
[ -e "$lock_ready" ] || { echo "FAIL: fixture repository lock was not acquired"; exit 1; }
if GARDEN_ROOT="$GROOT" GARDEN_STATE="$STATE" GARDEN_REPO_LOCK_WAIT=1 bash -c '
  source "$1"
  garden_repo_lock "$2" exclusive
' _ "$JOBS/common.sh" "$PBARE" >/dev/null 2>&1; then
  echo "FAIL: fixture repository lock did not exclude a second owner"
  exit 1
fi

GARDEN=testhost GARDEN_ROOT="$GROOT" GARDEN_SCRATCH="$SCRATCH" GARDEN_STATE="$STATE" \
  JOURNAL_REMOTE="$JBARE" JOURNAL_BRANCH=journal2 GARDEN_WORKTREE_SWEEP_MAX=100 \
  GARDEN_REPO_LOCK_WAIT=60 \
  GARDEN_GH="$HERE/worktree-sweeper-gh-stub.sh" WORKTREE_SWEEPER_GH_CALLS="$TR/gh-calls" \
  bash "$JOBS/worktree-sweeper.sh" >"$TR/sweep.log" 2>&1 &
sweep_pid=$!

# The hermetic sweep has one local candidate and no remote PR checks.  It
# finishes in well under two seconds without contention; still running after
# this bound, combined with the exclusion probe above, means it is at the held
# project-repository lock.
sleep 2
kill -0 "$sweep_pid" 2>/dev/null || {
  : > "$lock_release"; wait "$lock_pid" || true; wait "$sweep_pid" || true
  echo "FAIL: sweeper did not block behind the project repository lock"
  sed -n '1,160p' "$TR/sweep.log"
  exit 1
}

(cd "$late_wt" && exec sleep 60) &
cwd_pid=$!
for _ in $(seq 1 200); do
  [ "$(readlink "/proc/$cwd_pid/cwd" 2>/dev/null || true)" = "$late_wt" ] && break
  sleep 0.05
done
[ "$(readlink "/proc/$cwd_pid/cwd" 2>/dev/null || true)" = "$late_wt" ] \
  || { echo "FAIL: live cwd fixture did not start"; exit 1; }

: > "$lock_release"
wait "$lock_pid"
wait "$sweep_pid"
kill "$cwd_pid" 2>/dev/null || true
wait "$cwd_pid" 2>/dev/null || true

if [ -d "$late_wt" ]; then
  echo "PASS: sweeper re-checks process liveness after the repository-lock wait"
else
  echo "FAIL: sweeper removed a checkout entered by a live process during its lock wait"
  sed -n '1,160p' "$TR/sweep.log"
  exit 1
fi
