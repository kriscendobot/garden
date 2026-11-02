#!/bin/bash
# worktree-sweeper-build-cache-test.sh — pin the sweeper's reclaim of idle build
# caches parked directly under scratch, and everything it must leave alone.
#
# Usage: worktree-sweeper-build-cache-test.sh
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
# shellcheck source=test-tmpdir.sh
source "$HERE/test-tmpdir.sh"
TR="$(mktemp -d "$(garden_test_exec_tmpdir)/worktree-sweeper-build-cache.XXXXXXXX")"
LIVE_PID=""
trap '[ -z "$LIVE_PID" ] || kill "$LIVE_PID" 2>/dev/null; rm -rf "$TR"' EXIT
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

SIGNATURE='Signature: 8a477f597d28d172789f06886806bc55'
# make_cache <name> <tag-line|-> : a tree whose every entry is ten days old.
make_cache() {
  local dir="$SCRATCH/$1"
  mkdir -p "$dir/debug/deps"
  printf 'object\n' > "$dir/debug/deps/lib.rlib"
  [ "$2" = - ] || printf '%s\n# created by cargo\n' "$2" > "$dir/CACHEDIR.TAG"
  find "$dir" -exec touch -d '10 days ago' {} +
}

make_cache idle-target "$SIGNATURE"
make_cache recent-target "$SIGNATURE"
touch "$SCRATCH/recent-target/debug/deps/lib.rlib"   # top dir stays old, as in a build
make_cache untagged-dir -
make_cache wrong-signature 'Signature: not-the-standard-value'
make_cache live-target "$SIGNATURE"
make_cache project-wt-owned-12345678 "$SIGNATURE"
make_cache gardener-wt-owned "$SIGNATURE"
mkdir -p "$TR/outside"
make_cache elsewhere "$SIGNATURE"
mv "$SCRATCH/elsewhere" "$TR/outside/elsewhere"
ln -s "$TR/outside/elsewhere" "$SCRATCH/symlinked-target"

(cd "$SCRATCH/live-target/debug" && exec sleep 300) &
LIVE_PID=$!
sleep 0.2

sweep() { # sweep [idle-days]; without one, the script's default applies
  env ${1:+GARDEN_SCRATCH_CACHE_IDLE_DAYS="$1"} GARDEN=hostb-garden-bbbb2222 GARDEN_LEADER=hosta-garden-aaaa1111 GARDEN_ROOT="$GROOT" \
    GARDEN_SCRATCH="$SCRATCH" GARDEN_STATE="$STATE" JOURNAL_REMOTE="$JBARE" JOURNAL_BRANCH=journal2 \
    GARDEN_WORKTREE_SWEEP_MAX=100 \
    GARDEN_GH="$HERE/worktree-sweeper-gh-stub.sh" WORKTREE_SWEEPER_GH_CALLS="$TR/gh-calls" \
    bash "$JOBS/worktree-sweeper.sh" >"$TR/sweep.log" 2>&1
}

sweep 0
[ -d "$SCRATCH/idle-target" ] && ok "idle-days 0 disables the pass" || bad "idle-days 0 removed a cache"

sweep
[ ! -e "$SCRATCH/idle-target" ] && ok "removed an idle tagged cache" || bad "idle tagged cache survived"
grep -q 'removed idle build cache' "$TR/sweep.log" && ok "logged the removal" || bad "removal not logged"
for name in recent-target untagged-dir wrong-signature live-target \
            project-wt-owned-12345678 gardener-wt-owned; do
  [ -d "$SCRATCH/$name" ] && ok "kept $name" || bad "removed $name"
done
[ -d "$TR/outside/elsewhere/debug" ] && [ -L "$SCRATCH/symlinked-target" ] \
  && ok "did not follow a symlinked cache" || bad "followed a symlinked cache"

kill "$LIVE_PID" 2>/dev/null; wait "$LIVE_PID" 2>/dev/null; LIVE_PID=""
sweep
[ ! -e "$SCRATCH/live-target" ] && ok "removed the cache once its process exited" \
  || bad "cache survived after its process exited"

echo
echo "worktree sweeper (build cache): $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
