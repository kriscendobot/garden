#!/bin/bash
# project-worktree-isolation-test.sh — prove ensure-project-worktree.sh gives
# every gardener job an ISOLATED project checkout keyed by its unique job base,
# so two concurrent jobs on the same repo/branch can NEVER share a working tree.
#
# This is the regression for the endo-but-for-bots #58 corruption: two gardeners
# implementing the same fix each improvised the SAME repo+PR-keyed project path
# (`…/ebfb-pr58-project`), shared one working tree, and their concurrent edits to
# error-trace.js + chat-bar-component.js bled across. The helper keys the
# worktree by the gardener's unique job base instead, so this cannot recur.
#
# Assertions:
#   1. Two DIFFERENT bases, SAME repo+branch → DISTINCT worktree paths.
#   2. Both are real, detached checkouts of the requested branch.
#   3. Edits in one do NOT appear in the other (the actual corruption regression).
#   4. Same base, same repo+branch (a reaper requeue) → the SAME path, and
#      in-flight uncommitted work is PRESERVED (resume stability).
#   5. Same base, DIFFERENT repo/branch → DISTINCT paths (no self-collision).
#   6. Every path lives under $GARDEN_SCRATCH (never the deployed root tree).
#
# Hermetic: throwaway bare "fork" clones + a throwaway garden root, no network.

# shellcheck disable=SC2015
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS_SRC="$(cd "$HERE/.." && pwd)"

# Like gardener-worktree-test.sh: the temp tree must live where we can create git
# worktrees; $GARDEN_SCRATCH is exec-allowed and gitignored. Standard temp first.
pick_base() {
  local c
  for c in "${TMPDIR:-}" /tmp "${GARDEN_SCRATCH:-}" "${GARDEN_ROOT:+$GARDEN_ROOT/scratch}"; do
    [ -n "$c" ] && [ -d "$c" ] && [ -w "$c" ] && { printf '%s\n' "$c"; return 0; }
  done
  return 1
}
BASE_DIR="$(pick_base)" || { echo "  SKIP: no writable temp base"; exit 0; }
TR="$(mktemp -d "$BASE_DIR/proj-wt-iso-test.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
trap 'rm -rf "$TR"' EXIT

git_id=(-c user.name=test -c user.email=test@localhost)

# --- build a throwaway "fork" and its standing bare clone --------------------
# make_fork <owner> <name> <branch> — seed an upstream repo with one file on
# <branch>, then produce the bare clone the helper reads (worktrees/<o>-<n>.git),
# wired with the fork fetch refspec exactly like a real garden fork clone.
GROOT="$TR/garden"
mkdir -p "$GROOT/scripts/jobs" "$GROOT/worktrees"
cp "$JOBS_SRC/common.sh" "$JOBS_SRC/usage-meter.sh" \
   "$JOBS_SRC/ensure-project-worktree.sh" "$GROOT/scripts/jobs/"
chmod +x "$GROOT/scripts/jobs/ensure-project-worktree.sh"
# The garden root is a git repo so bot_name/bot_email resolve to a pinned identity.
git -C "$GROOT" init -q
git -C "$GROOT" config user.name  garden-bot
git -C "$GROOT" config user.email garden-bot@localhost

make_fork() {  # make_fork <owner> <name> <branch>
  local owner="$1" name="$2" branch="$3"
  local up="$TR/upstream-$owner-$name.git" seed="$TR/seed-$owner-$name"
  git init -q --bare "$up"
  git init -q "$seed"
  ( cd "$seed"
    printf 'upstream original\n' > error-trace.js
    git "${git_id[@]}" add error-trace.js
    git "${git_id[@]}" commit -qm seed
    git branch -M "$branch"
    git remote add origin "$up"
    git push -q -u origin "$branch" ) >/dev/null 2>&1
  local bare="$GROOT/worktrees/${owner}-${name}.git"
  git clone -q --bare "$up" "$bare"
  git -C "$bare" config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
  git -C "$bare" remote set-url origin "$up"
}

HELPER="$GROOT/scripts/jobs/ensure-project-worktree.sh"
SCRATCH="$GROOT/scratch"
run_helper() {  # run_helper <base> <owner/repo> <branch>  → echoes the path
  GARDEN_ROOT="$GROOT" GARDEN_SCRATCH="$SCRATCH" \
    bash "$HELPER" "$1" "$2" "$3"
}

make_fork endojs endo-but-for-bots pr-58

# === 1+2+3: two different bases, same repo+branch — isolation =================
P1="$(run_helper garden-fix-error-trace  endojs/endo-but-for-bots pr-58)"
P2="$(run_helper garden-fix-chat-bar     endojs/endo-but-for-bots pr-58)"

[ -n "$P1" ] && [ -n "$P2" ] && ok "helper emits a path for each job" \
  || bad "helper did not emit a path (P1='$P1' P2='$P2')"
[ "$P1" != "$P2" ] && ok "two different bases → DISTINCT worktree paths" \
  || bad "COLLISION: both jobs resolved to the same path '$P1' (the #58 bug)"
[ -d "$P1" ] && [ -d "$P2" ] && ok "both worktrees exist on disk" \
  || bad "a worktree dir is missing (P1 dir=$([ -d "$P1" ] && echo y||echo n), P2 dir=$([ -d "$P2" ] && echo y||echo n))"
# both under scratch, never the deployed root tree
case "$P1/" in "$SCRATCH"/*) ok "job 1 worktree is under \$GARDEN_SCRATCH" ;; *) bad "job 1 worktree escaped scratch: $P1" ;; esac
case "$P2/" in "$SCRATCH"/*) ok "job 2 worktree is under \$GARDEN_SCRATCH" ;; *) bad "job 2 worktree escaped scratch: $P2" ;; esac
# both are detached checkouts of the branch content
[ -f "$P1/error-trace.js" ] && [ -f "$P2/error-trace.js" ] && ok "both checked out the branch tip" \
  || bad "branch content missing in a worktree"
[ "$(git -C "$P1" symbolic-ref -q HEAD || echo detached)" = detached ] && ok "worktree HEAD is detached" \
  || bad "worktree HEAD is not detached (should be, for HEAD:<branch> pushes)"

# The actual corruption regression: edit each independently, prove no bleed-through.
printf 'JOB1 edits error-trace.js\n' > "$P1/error-trace.js"
printf 'JOB2 edits chat-bar-component.js\n' > "$P2/chat-bar-component.js"
grep -q JOB1 "$P1/error-trace.js" && ! grep -q JOB2 "$P1/error-trace.js" 2>/dev/null \
  && [ ! -e "$P1/chat-bar-component.js" ] \
  && ok "job 1's tree shows ONLY job 1's edits (no bleed-through)" \
  || bad "job 2's work leaked into job 1's tree"
grep -q JOB2 "$P2/chat-bar-component.js" && ! grep -q JOB1 "$P2/error-trace.js" 2>/dev/null \
  && ok "job 2's tree shows ONLY job 2's edits (no bleed-through)" \
  || bad "job 1's work leaked into job 2's tree"

# === 4: same base, same repo+branch (a requeue) → SAME path, work preserved ===
echo "in-flight-sentinel-$$" > "$P1/.in-flight"
P1b="$(run_helper garden-fix-error-trace endojs/endo-but-for-bots pr-58)"
[ "$P1b" = "$P1" ] && ok "requeue re-derives the SAME per-base path (resume stable)" \
  || bad "requeue resolved to a different path ('$P1b' != '$P1')"
[ -f "$P1/.in-flight" ] && ok "requeue REUSES the tree; in-flight work preserved" \
  || bad "requeue clobbered the in-flight worktree (lost uncommitted work)"

# === 5: same base, different repo/branch → distinct (no self-collision) =======
make_fork endojs endo main
P3="$(run_helper garden-fix-error-trace endojs/endo main)"
[ "$P3" != "$P1" ] && ok "same base, different repo → DISTINCT path (no self-collision)" \
  || bad "same base collided across repos ('$P3' == '$P1')"

# === 6: silent stale-fetch guard — remote advances but the fetch can't deliver =
# Regression for the 2026-07-06 stale-tree delivery: when origin advertises a NEW
# tip (ls-remote succeeds) but the fetch of it fails (a transient blip), the
# helper must REFUSE rather than silently hand back the stale local ref.
make_fork endojs stale-guard main
UP="$TR/upstream-endojs-stale-guard.git"
SEED="$TR/seed-endojs-stale-guard"
SG_BARE="$GROOT/worktrees/endojs-stale-guard.git"
git -C "$UP" config gc.auto 0 >/dev/null 2>&1; git -C "$UP" config receive.autogc false >/dev/null 2>&1
# establish a fresh baseline (bare refs/heads/main = T1) via one good run
run_helper garden-stale-baseline endojs/stale-guard main >/dev/null
# advance upstream to T2, then delete T2's objects so ls-remote still advertises
# the new tip but a fetch of it fails — the exact transient shape we must catch.
find "$UP/objects" -type f | sort > "$TR/obj-before"
( cd "$SEED"
  printf 'upstream T2 — must-not-be-skipped\n' > error-trace.js
  git "${git_id[@]}" commit -qam T2
  git push -q origin main ) >/dev/null 2>&1
find "$UP/objects" -type f | sort > "$TR/obj-after"
comm -13 "$TR/obj-before" "$TR/obj-after" | while read -r f; do rm -f "$f"; done
# sanity: ls-remote still advertises the (now unfetchable) T2 tip
adv="$(git --git-dir="$SG_BARE" ls-remote origin refs/heads/main 2>/dev/null | cut -f1)"
seed_t2="$(git -C "$SEED" rev-parse HEAD)"
[ -n "$adv" ] && [ "$adv" = "$seed_t2" ] && ok "ls-remote advertises the advanced (unfetchable) tip" \
  || bad "test setup: ls-remote did not advertise T2 (adv='$adv' t2='$seed_t2')"
# the guard must make the helper DIE, not emit a stale-tree path
if out="$(run_helper garden-stale-victim endojs/stale-guard main 2>/dev/null)"; then
  bad "helper handed back a tree despite an undeliverable remote tip (stale!): '$out'"
else
  ok "helper REFUSES (dies) rather than delivering a stale tree"
fi

# --- summary -----------------------------------------------------------------
echo "----------------------------------------------------------------"
echo "project-worktree-isolation: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
