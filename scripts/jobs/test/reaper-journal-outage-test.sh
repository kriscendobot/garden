#!/bin/bash
# reaper-journal-outage-test.sh — a transient journal fetch outage is a
# rate-limited, fail-open reaper tick: rc=0, claims unchanged, locks released.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
# shellcheck source=test-tmpdir.sh
source "$HERE/test-tmpdir.sh"

# shellcheck disable=SC2046 # intentional variable-name expansion, matching the fleet harness
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true
export GARDEN_TEST=1
TR="$(mktemp -d "$(garden_test_exec_tmpdir)/.garden-reaper-outage-test.XXXXXXXX")"
trap 'rm -rf "$TR"' EXIT
BRANCH=journal2
BARE="$TR/journal.git"
SEED="$TR/seed"
CLONE="$TR/state/reaper/journal"
git_id=(-c user.name=test -c user.email=test@localhost)

git init -q --bare "$BARE"
git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"
mkdir -p "$SEED/jobs/doin" "$SEED/jobs/todo" "$SEED/jobs/plan" "$SEED/jobs/tada" "$SEED/work"
for dir in jobs/doin jobs/todo jobs/plan jobs/tada work; do touch "$SEED/$dir/.gitkeep"; done
cat > "$SEED/jobs/doin/outage-victim.md" <<'EOF'
# outage victim

This claim must stay exactly where it is while the journal is unavailable.

---
claim:
  host: testhost
  gardener: 1
  claimed_at: 2099-01-01T00:00:00Z
EOF
printf 'worktree_dir: %s\n' "$TR/nonexistent-worktree" > "$SEED/work/outage-victim"
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m seed
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH"
export GARDEN=testhost GARDEN_STATE="$TR/state" GARDEN_ROOT="$TR/root"
export GARDEN_REAPER_CLONE="$CLONE" GARDEN_FETCH_RETRIES=1
export GARDEN_JOURNAL_OUTAGE_COOLDOWN_SECS=120
mkdir -p "$GARDEN_ROOT"

# Prime the private clone, then inject the same DNS diagnostic git emits during a
# transient resolver outage. GARDEN_FETCH_CMD is the common.sh test seam.
"$JOBS/reaper.sh" >"$TR/prime.log" 2>&1
cat > "$TR/offline-fetch" <<'EOF'
#!/bin/sh
echo 'fatal: unable to access journal: Could not resolve host: github.com' >&2
exit 128
EOF
chmod +x "$TR/offline-fetch"
export GARDEN_FETCH_CMD="$TR/offline-fetch"

before="$(git -C "$CLONE" status --porcelain=v1 && git -C "$CLONE" rev-parse HEAD)"
"$JOBS/reaper.sh" >"$TR/first.log" 2>&1
after="$(git -C "$CLONE" status --porcelain=v1 && git -C "$CLONE" rev-parse HEAD)"
[ "$before" = "$after" ]
[ -f "$CLONE/jobs/doin/outage-victim.md" ]
[ ! -e "$CLONE/jobs/todo/outage-victim.md" ]
grep -q 'claims left untouched' "$TR/first.log"
[ -s "$GARDEN_ROOT/.garden-state/journal-outage-cooldown/marker" ]

# A leaked clone lock would make this bounded probe fail.  Acquiring it proves
# the failed tick released both clone and repository state.
(
  # shellcheck source=../common.sh
  source "$JOBS/common.sh"
  GARDEN_LOCK_RETRIES=0 GARDEN_LOCK_WAIT=1 clone_lock "$CLONE"
  garden_repo_lock "$CLONE" exclusive
  garden_repo_unlock "$CLONE"
  clone_unlock "$CLONE"
)

# The live cooldown suppresses both a second fetch and duplicate warning.
: > "$TR/fetch-called"
cat > "$TR/should-not-fetch" <<EOF
#!/bin/sh
touch "$TR/fetch-called"
exit 99
EOF
chmod +x "$TR/should-not-fetch"
export GARDEN_FETCH_CMD="$TR/should-not-fetch"
"$JOBS/reaper.sh" >"$TR/second.log" 2>&1
[ ! -s "$TR/fetch-called" ]
[ ! -s "$TR/second.log" ]
[ -f "$CLONE/jobs/doin/outage-victim.md" ]

echo "PASS: transient journal outage exits cleanly, preserves claims, releases clone state, and rate-limits retries"
