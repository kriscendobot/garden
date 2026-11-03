#!/bin/bash
# worktree-sweeper-dep-cache-test.sh — pin the sweeper's eviction of idle dependency
# cache entries, its shorter TTL under disk pressure, and what it must leave alone.
#
# Usage: worktree-sweeper-dep-cache-test.sh
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
# shellcheck source=test-tmpdir.sh
source "$HERE/test-tmpdir.sh"
TR="$(mktemp -d "$(garden_test_exec_tmpdir)/worktree-sweeper-dep-cache.XXXXXXXX")"
trap 'rm -rf "$TR"' EXIT
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

CACHE="$STATE/dep-cache"
# make_entry <slug> <name> <days-idle>
make_entry() {
  local dir="$CACHE/$1/$2"
  mkdir -p "$dir/trees/node_modules/pkg"
  printf '{}\n' > "$dir/trees/node_modules/pkg/package.json"
  : > "$dir/.complete"
  find "$dir" -exec touch -d "$3 days ago" {} +
}

sweep() { # sweep [VAR=value...]
  env "$@" GARDEN=hostb-garden-bbbb2222 GARDEN_LEADER=hosta-garden-aaaa1111 GARDEN_ROOT="$GROOT" \
    GARDEN_SCRATCH="$SCRATCH" GARDEN_STATE="$STATE" JOURNAL_REMOTE="$JBARE" JOURNAL_BRANCH=journal2 \
    GARDEN_WORKTREE_SWEEP_MAX=100 \
    GARDEN_GH="$HERE/worktree-sweeper-gh-stub.sh" WORKTREE_SWEEPER_GH_CALLS="$TR/gh-calls" \
    bash "$JOBS/worktree-sweeper.sh" >"$TR/sweep.log" 2>&1
}
has() { [ -d "$CACHE/$1" ]; }

make_entry busy/ newest 0
make_entry busy/ fresh 1
make_entry busy/ week-old 7
make_entry busy/ month-old 30
make_entry dormant/ only-entry 40
make_entry dormant2/ newer 20
make_entry dormant2/ older 30

sweep GARDEN_DEP_CACHE_TTL_DAYS=0 GARDEN_DEP_CACHE_PRESSURE_FREE_MIB=0
has busy/month-old && ok "TTL 0 disables the pass" || bad "TTL 0 evicted an entry"

# A held provisioner lock defers eviction.
mkdir -p "$CACHE/busy"
exec 8>>"$CACHE/busy/.lock"
flock 8
sweep GARDEN_DEP_CACHE_PRESSURE_FREE_MIB=0
has busy/month-old && ok "kept an entry while the slug's lock is held" || bad "evicted under a held lock"
has dormant2/older && bad "a held lock on one slug should not stop another" \
  || ok "other slugs proceed past a held lock"
flock -u 8; exec 8>&-

# With room to spare, the ordinary TTL applies.
sweep GARDEN_DEP_CACHE_PRESSURE_FREE_MIB=0
has busy/month-old && bad "idle entry survived past the TTL" || ok "evicted an entry past the TTL"
grep -q 'idle dependency cache entries' "$TR/sweep.log" && ok "logged the eviction" || bad "eviction not logged"
has busy/week-old && ok "kept an entry inside the TTL" || bad "evicted inside the TTL"
has busy/fresh && ok "kept a fresh entry" || bad "evicted a fresh entry"
has dormant/only-entry && ok "kept a slug's only entry, however old" || bad "evicted a slug's only entry"
has dormant2/newer && ok "kept a slug's newest entry" || bad "evicted a slug's newest entry"
[ -f "$CACHE/busy/.lock" ] && ok "left the lock file" || bad "removed the lock file"

# Under disk pressure, the shorter TTL applies.
make_entry busy/ week-old 7
sweep GARDEN_DEP_CACHE_PRESSURE_FREE_MIB=999999999
has busy/week-old && bad "pressure did not shorten the TTL" || ok "pressure evicted a week-old entry"
has busy/fresh && ok "pressure kept a fresh entry" || bad "pressure evicted a fresh entry"
has busy/newest && ok "pressure kept the newest entry" || bad "pressure evicted the newest entry"
has dormant/only-entry && ok "pressure kept a slug's only entry" || bad "pressure evicted a slug's only entry"

# A pressure TTL longer than the ordinary one must not extend retention.
make_entry busy/ week-old 7
sweep GARDEN_DEP_CACHE_TTL_DAYS=3 GARDEN_DEP_CACHE_PRESSURE_TTL_DAYS=30 GARDEN_DEP_CACHE_PRESSURE_FREE_MIB=999999999
has busy/week-old && bad "a longer pressure TTL extended retention" || ok "the shorter of the two TTLs wins"

# An exhausted delete budget leaves the rename behind, and a later tick finishes it.
make_entry busy/ week-old 7
sweep GARDEN_DEP_CACHE_TTL_DAYS=3 GARDEN_DEP_CACHE_SWEEP_SECS=0
has busy/.evicting-week-old && ok "no delete budget leaves the renamed entry" || bad "renamed entry not left behind"
has busy/week-old && bad "entry was not renamed" || ok "renamed the entry out of the selectable set"
sweep
has busy/.evicting-week-old && bad "later tick did not finish the delete" || ok "a later tick finished the delete"

echo
echo "worktree sweeper (dependency cache): $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
