#!/bin/bash
# safe-push-pr-head-test.sh: the gauntlet's PR-head push must never rewind a
# peer's newer commits. Reproduces the endojs/endo-but-for-bots #792 branch-rewind
# hazard hermetically on throwaway git fixtures — a peer advances the head, then a
# stale worktree tries to push an ANCESTOR — and asserts the safe push REFUSES it
# and leaves the live head untouched, while genuine advances/creates/no-ops still
# push.

set -euo pipefail
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
SP="$JOBS/gardening/safe-push-pr-head.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-safe-push-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

BR=feature-head
G=(-c user.name=test -c user.email=test@example.invalid -c commit.gpgsign=false)

# A bare "fork" remote plus a seed clone that opens the PR head branch.
git init -q --bare "$TR/remote.git"
git init -q "$TR/seed"
( cd "$TR/seed"
  git "${G[@]}" checkout -q -b "$BR"
  echo base > f.txt; git add f.txt; git "${G[@]}" commit -q -m base
  git remote add origin "$TR/remote.git"
  git push -q origin "HEAD:$BR" )
BASE_SHA="$(git -C "$TR/seed" rev-parse HEAD)"

remote_head() { git -C "$TR/remote.git" rev-parse "refs/heads/$BR"; }

# Fresh checkout of the current remote head into <dir>.
clone_at() { git clone -q --branch "$BR" "$TR/remote.git" "$1" >/dev/null 2>&1; }
# Add a commit on top of a checkout.
commit_on() { ( cd "$1"; echo "$3" >> "${2:-f.txt}"; git add -A; git "${G[@]}" commit -q -m "$3" ); }

pass=0
ok()  { echo "  PASS: $*"; pass=$((pass+1)); }
die() { echo "  FAIL: $*" >&2; exit 1; }

# ── 1. The #792 reproduction: a stale worktree must NOT rewind a peer ─────────
# A "shepherd" peer advances the live head by two commits...
clone_at "$TR/shepherd"
commit_on "$TR/shepherd" f.txt fix1
commit_on "$TR/shepherd" f.txt fix2
git -C "$TR/shepherd" push -q origin "HEAD:$BR"
SHEP_SHA="$(remote_head)"
[ "$SHEP_SHA" != "$BASE_SHA" ] || die "setup: shepherd push did not advance the head"

# ...then a "gauntlet" working from a worktree that predates those commits (still
# at BASE_SHA) tries to push its ancestor head. This is exactly what rewound #792.
clone_at "$TR/gauntlet"
git -C "$TR/gauntlet" "${G[@]}" reset -q --hard "$BASE_SHA"
rc=0; out="$("$SP" --mode advance "$TR/gauntlet" origin "$BR" 2>&1)" || rc=$?
[ "$rc" -eq 3 ] || die "advance push of an ancestor should refuse (rc 3), got rc=$rc: $out"
printf '%s\n' "$out" | grep -qi 'ancestor' || die "refusal should name the ancestor/rewind hazard: $out"
[ "$(remote_head)" = "$SHEP_SHA" ] || die "live head was rewound despite the guard!"
ok "advance mode REFUSES an ancestor (behind) head and leaves the live head intact (#792)"

# rewrite mode must ALSO refuse a strictly-behind head — an ancestor can only rewind.
rc=0; out="$("$SP" --mode rewrite "$TR/gauntlet" origin "$BR" 2>&1)" || rc=$?
[ "$rc" -eq 3 ] || die "rewrite push of an ancestor should still refuse (rc 3), got rc=$rc: $out"
[ "$(remote_head)" = "$SHEP_SHA" ] || die "rewrite mode rewound the live head!"
ok "rewrite mode also REFUSES a strictly-behind (ancestor) head"

# ── 2. A genuine fast-forward advance is allowed ─────────────────────────────
# The gauntlet rebases onto the live head, adds a fix commit, and pushes.
git -C "$TR/gauntlet" "${G[@]}" reset -q --hard "$SHEP_SHA"
commit_on "$TR/gauntlet" f.txt gauntlet-fix
GA_SHA="$(git -C "$TR/gauntlet" rev-parse HEAD)"
rc=0; out="$("$SP" --mode advance "$TR/gauntlet" origin "$BR" 2>&1)" || rc=$?
[ "$rc" -eq 0 ] || die "fast-forward advance should push (rc 0), got rc=$rc: $out"
[ "$(remote_head)" = "$GA_SHA" ] || die "advance did not land the new head"
ok "advance mode pushes a genuine fast-forward (contains the live head)"

# ── 3. Up to date is a quiet no-op ───────────────────────────────────────────
rc=0; out="$("$SP" --mode advance "$TR/gauntlet" origin "$BR" 2>&1)" || rc=$?
[ "$rc" -eq 0 ] || die "no-op push should succeed (rc 0), got rc=$rc: $out"
printf '%s\n' "$out" | grep -qi 'nothing to push' || die "expected a nothing-to-push message: $out"
[ "$(remote_head)" = "$GA_SHA" ] || die "no-op push changed the head"
ok "an already-up-to-date head is a quiet no-op"

# ── 4. A diverged head: advance refuses, rewrite rewrites ────────────────────
# Peer advances the live head; the gauntlet builds a DIVERGENT commit off GA_SHA.
clone_at "$TR/peer2"; commit_on "$TR/peer2" f.txt peer2; git -C "$TR/peer2" push -q origin "HEAD:$BR"
PEER2_SHA="$(remote_head)"
git -C "$TR/gauntlet" "${G[@]}" reset -q --hard "$GA_SHA"
commit_on "$TR/gauntlet" other.txt divergent
DIV_SHA="$(git -C "$TR/gauntlet" rev-parse HEAD)"
rc=0; out="$("$SP" --mode advance "$TR/gauntlet" origin "$BR" 2>&1)" || rc=$?
[ "$rc" -eq 3 ] || die "advance push of a diverged head should refuse (rc 3), got rc=$rc: $out"
printf '%s\n' "$out" | grep -qi 'diverged' || die "refusal should name the divergence: $out"
[ "$(remote_head)" = "$PEER2_SHA" ] || die "advance clobbered a diverged head"
ok "advance mode REFUSES a diverged head"

rc=0; out="$("$SP" --mode rewrite "$TR/gauntlet" origin "$BR" 2>&1)" || rc=$?
[ "$rc" -eq 0 ] || die "rewrite push of a diverged head should succeed (rc 0), got rc=$rc: $out"
[ "$(remote_head)" = "$DIV_SHA" ] || die "rewrite did not land the divergent head"
ok "rewrite mode force-pushes a diverged head (rebase/retcon path)"

# ── 5. Creating a brand-new head ─────────────────────────────────────────────
git -C "$TR/gauntlet" "${G[@]}" checkout -q -b brand-new
commit_on "$TR/gauntlet" new.txt new-branch
NEW_SHA="$(git -C "$TR/gauntlet" rev-parse HEAD)"
rc=0; out="$("$SP" --mode advance "$TR/gauntlet" origin brand-new 2>&1)" || rc=$?
[ "$rc" -eq 0 ] || die "creating a new head should succeed (rc 0), got rc=$rc: $out"
[ "$(git -C "$TR/remote.git" rev-parse refs/heads/brand-new)" = "$NEW_SHA" ] || die "new head not created"
ok "a brand-new head is created (nothing to rewind)"

echo "PASS: safe-push-pr-head refuses behind/diverged rewinds and pushes genuine advances/creates ($pass checks)"
