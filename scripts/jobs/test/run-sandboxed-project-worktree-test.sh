#!/bin/bash
# shellcheck disable=SC2016
# run-sandboxed-project-worktree-test.sh — project bare clones and the project
# checkout parent are writable in the sandbox without widening the garden root.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RS="$HERE/../../secrets/run-sandboxed.sh"
PASS=0; FAIL=0
ok()  { PASS=$((PASS+1)); echo "  ok: $1"; }
bad() { FAIL=$((FAIL+1)); echo "  FAIL: $1"; }

if ! command -v bwrap >/dev/null 2>&1 || ! bwrap --ro-bind / / true 2>/dev/null; then
  echo "  SKIP: bwrap unusable here"; exit 0
fi

BASE="$(mktemp -d "${GARDEN_TEST_BASE:-$HOME}/.sbx-project-worktree-test.XXXXXX")"
trap 'rm -rf "$BASE"' EXIT
ROOT="$BASE/root"; STATE="$BASE/state"
mkdir -p "$ROOT/worktrees/example.git/worktrees" "$ROOT/scratch" \
  "$ROOT/scratch/gardener-wt-own" "$ROOT/scratch/gardener-wt-peer" "$ROOT/gardener-wt" "$ROOT/readonly" "$ROOT/secrets" "$STATE/repo-locks/project"
export GARDEN_ROOT="$ROOT" GARDEN_SCRATCH="$ROOT/scratch" GARDEN_STATE="$STATE"
export GARDEN_SECRETS_DIR="$ROOT/secrets" TMPDIR="$BASE/tmp"
mkdir -p "$TMPDIR"

out="$("$RS" --worktree "$ROOT/gardener-wt" -- bash -c '
  : >"$GARDEN_ROOT/worktrees/example.git/FETCH_HEAD" || exit 41
  mkdir "$GARDEN_ROOT/worktrees/example.git/worktrees/project" || exit 42
  mkdir "$GARDEN_SCRATCH/project-wt-job-00000001" || exit 43
  if touch "$GARDEN_ROOT/readonly/nope" 2>/dev/null; then exit 44; fi
  touch "$GARDEN_SECRETS_DIR/leak" || exit 45
  echo ran
' 2>&1)"; rc=$?
if [ "$rc" -eq 0 ] && [ "$out" = ran ] \
   && [ -f "$ROOT/worktrees/example.git/FETCH_HEAD" ] \
   && [ -d "$ROOT/scratch/project-wt-job-00000001" ]; then
  ok "bare clone and project-worktree parent are writable; garden root stays read-only"
else
  bad "project checkout bind check failed rc=$rc out='$out'"
fi

# Production launchers source common.sh, whose GARDEN_SCRATCH default is NOT
# exported; the sandbox must derive $GARDEN_ROOT/scratch itself and pin it.
out="$(env -u GARDEN_SCRATCH "$RS" --worktree "$ROOT/gardener-wt" -- bash -c '
  [ "${GARDEN_SCRATCH:-}" = "$GARDEN_ROOT/scratch" ] || exit 51
  mkdir "$GARDEN_SCRATCH/project-wt-job-00000002" || exit 52
  echo ran
' 2>&1)"; rc=$?
if [ "$rc" -eq 0 ] && [ "$out" = ran ] && [ -d "$ROOT/scratch/project-wt-job-00000002" ]; then
  ok "unexported GARDEN_SCRATCH still yields a writable, pinned scratch parent"
else
  bad "unexported GARDEN_SCRATCH case failed rc=$rc out='$out'"
fi

# Writable scratch must not let a job write a peer job's garden worktree.
out="$("$RS" --worktree "$ROOT/scratch/gardener-wt-own" -- bash -c '
  touch "$GARDEN_SCRATCH/gardener-wt-own/f" || exit 71
  if touch "$GARDEN_SCRATCH/gardener-wt-peer/f" 2>/dev/null; then exit 72; fi
  echo ran
' 2>&1)"; rc=$?
if [ "$rc" -eq 0 ] && [ "$out" = ran ]; then
  ok "own garden worktree writable; peer garden worktree stays read-only"
else
  bad "peer worktree isolation failed rc=$rc out='$out'"
fi

# The dependency cache is host-shared (like repo-locks), not per-job.
out="$("$RS" --worktree "$ROOT/gardener-wt" -- bash -c '
  [ "${GARDEN_DEP_CACHE_ROOT:-}" = "'"$STATE"'/dep-cache" ] || exit 61
  [ "$GARDEN_STATE" != "'"$STATE"'" ] || exit 62
  mkdir -p "$GARDEN_DEP_CACHE_ROOT/slug" || exit 63
  echo ran
' 2>&1)"; rc=$?
if [ "$rc" -eq 0 ] && [ "$out" = ran ] && [ -d "$STATE/dep-cache/slug" ]; then
  ok "dep-cache stays the shared, writable host cache under a per-job GARDEN_STATE"
else
  bad "dep-cache link-back failed rc=$rc out='$out'"
fi

# The sandbox substitutes a per-job GARDEN_STATE, but repo-locks is deliberately
# linked back to the host directory.  Holding the host lock must therefore block
# an independent sandboxed job from acquiring what it sees as the same lock.
exec 9>"$STATE/repo-locks/project/repo.lock"
flock -n 9 || { bad "could not take host project-repo lock"; exit 1; }
if "$RS" --worktree "$ROOT/gardener-wt" -- \
    flock -n "$STATE/repo-locks/project/repo.lock" -c true 2>/dev/null; then
  bad "sandboxed project job bypassed the host repo lock"
else
  ok "project-repo lock still serializes through shared host repo-locks"
fi
flock -u 9

if [ ! -e "$ROOT/secrets/leak" ]; then
  ok "secret directory remains tmpfs-hidden"
else
  bad "sandbox write escaped the hidden secret directory"
fi

echo "run-sandboxed-project-worktree: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
