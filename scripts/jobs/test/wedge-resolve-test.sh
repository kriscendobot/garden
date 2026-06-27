#!/bin/bash
# wedge-resolve-test.sh — coverage for autonomous dirty-tree-wedge resolution.
#
# Maintainer directive 2026-06-27: a dirty-tree wedge on the shared main2 checkout
# must be resolved AUTONOMOUSLY — the watchman/deploy-sync post a resolve-wedge job
# instead of paging the maintainer, and the deterministic resolver (resolve-wedge.sh)
# cleans the tree LOSSLESSLY (drop a redundant copy of landed work; PRESERVE genuine
# WIP via a stash / off-tree move — never discard it).
#
# Two halves:
#   A. resolve-wedge.sh — the deterministic finisher dance on real git fixtures:
#      lossless drop of a tracked edit identical to origin; lossless rm of an
#      untracked file identical to its incoming version; genuine tracked WIP is
#      stashed (preserved); a non-colliding untracked file is left untouched; a
#      divergent untracked collision is moved aside (preserved), never deleted.
#   B. trigger_wedge_resolution (via watchman.sh end-to-end) — a tracked wedge and
#      an untracked collision each POST a resolve-wedge job and DO NOT page the
#      maintainer; the post is throttled per wedge signature.
#
# Hermetic: throwaway git origins/checkouts; a mock GARDEN_POST_JOB records posts.
# No real systemd, no real journal, no maintainer message ever leaves the box.
#
# Usage: wedge-resolve-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
RESOLVE="$JOBS/resolve-wedge.sh"
WATCHMAN="$JOBS/watchman.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener invoking this test cannot splice its
# own GARDEN_*/JOURNAL_* state underneath the fixture (mirrors deploy-sync-test).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR=/home/kris/.garden-wedge-test
rm -rf "$TR"; mkdir -p "$TR"
BARE="$TR/origin.git"
git_id=(-c user.name=test -c user.email=test@localhost)

# Build a fresh origin (main2) + checkout ROOT (a stand-in shared garden tree),
# seeded with foo.txt and bar.txt = "base".
setup_fixture() {
  rm -rf "$BARE" "$TR/root" "$TR/seed" "$TR/scratch"
  git init -q --bare "$BARE"
  local SEED="$TR/seed"; git init -q "$SEED"
  git -C "$SEED" checkout -q -b main2
  printf 'base\n' > "$SEED/foo.txt"
  printf 'base\n' > "$SEED/bar.txt"
  git -C "$SEED" add -A; git -C "$SEED" "${git_id[@]}" commit -q -m seed
  git -C "$SEED" remote add origin "$BARE"; git -C "$SEED" push -q -u origin main2
  git clone -q --branch main2 "$BARE" "$TR/root"
  git -C "$TR/root" config user.name test; git -C "$TR/root" config user.email test@localhost
  mkdir -p "$TR/scratch"
}

# Push a commit to origin/main2 (advancing it ahead of ROOT).
origin_commit() {  # origin_commit <relpath> <content> <msg>
  local wt; wt="$(mktemp -d "$TR/push.XXXXXX")"
  git clone -q --branch main2 "$BARE" "$wt"
  mkdir -p "$(dirname "$wt/$1")"; printf '%s\n' "$2" > "$wt/$1"
  git -C "$wt" add -A; git -C "$wt" "${git_id[@]}" commit -q -m "$3"
  git -C "$wt" push -q origin main2
  rm -rf "$wt"
}

run_resolve() {  # run_resolve ; fills $OUT/$RC, resolving the ROOT fixture
  set +e
  OUT="$(env GARDEN_ROOT="$TR/root" GARDEN_STATE="$TR/state" GARDEN_SCRATCH="$TR/scratch" \
             GARDEN_MAIN_BRANCH=main2 bash "$RESOLVE" main2 2>&1)"
  RC=$?
  set -e
}
clean_tree() { [ -z "$(git -C "$TR/root" status --porcelain --untracked-files=no 2>/dev/null)" ]; }
content()    { cat "$TR/root/$1" 2>/dev/null; }

# ============================================================================
hr; echo "STATIC — the scripts parse (bash -n)"; hr
bash -n "$RESOLVE"  && ok "resolve-wedge.sh parses"   || bad "resolve-wedge.sh syntax error"
bash -n "$WATCHMAN" && ok "watchman.sh parses"        || bad "watchman.sh syntax error"
bash -n "$JOBS/deploy-sync.sh" && ok "deploy-sync.sh parses" || bad "deploy-sync.sh syntax error"
bash -n "$JOBS/wedge-resolve.sh" && ok "wedge-resolve.sh parses" || bad "wedge-resolve.sh syntax error"

# ============================================================================
hr; echo "RESOLVE/LOSSLESS — a tracked edit identical to origin is dropped"; hr
setup_fixture
origin_commit foo.txt landed "fix: foo"
printf 'landed\n' > "$TR/root/foo.txt"     # local edit == incoming origin (redundant)
run_resolve
[ "$RC" -eq 0 ] && ok "resolver exit 0" || bad "resolver exit $RC"
clean_tree && ok "tree is clean (no tracked dirt) after the drop" || bad "tree still dirty"
[ "$(content foo.txt)" = base ] && ok "foo.txt dropped to HEAD (ff will re-land origin's identical copy)" || bad "foo.txt not dropped"
grep -q "dropped redundant tracked edit" <<<"$OUT" && ok "lossless drop logged" || bad "drop not logged"
[ -z "$(git -C "$TR/root" stash list)" ] && ok "nothing stashed (was redundant, not WIP)" || bad "spurious stash"

# ============================================================================
hr; echo "RESOLVE/LOSSLESS — an untracked file identical to its incoming copy is removed"; hr
setup_fixture
origin_commit baz.txt landedbaz "feat: baz"     # baz is an INCOMING tracked path
printf 'landedbaz\n' > "$TR/root/baz.txt"        # untracked, collides, identical
run_resolve
[ "$RC" -eq 0 ] && ok "resolver exit 0" || bad "resolver exit $RC"
[ ! -e "$TR/root/baz.txt" ] && ok "redundant untracked baz.txt removed" || bad "baz.txt not removed"
grep -q "removed redundant untracked copy" <<<"$OUT" && ok "lossless rm logged" || bad "rm not logged"

# ============================================================================
hr; echo "RESOLVE/PRESERVE — genuine tracked WIP is stashed, never discarded"; hr
setup_fixture
origin_commit foo.txt origin-foo "fix: foo upstream"
printf 'MY UNCOMMITTED WORK\n' > "$TR/root/foo.txt"   # differs from BOTH HEAD and origin
run_resolve
[ "$RC" -eq 0 ] && ok "resolver exit 0" || bad "resolver exit $RC"
clean_tree && ok "tree is clean after parking the WIP" || bad "tree still dirty"
[ -n "$(git -C "$TR/root" stash list)" ] && ok "genuine WIP was stashed (preserved)" || bad "WIP NOT stashed (data loss!)"
git -C "$TR/root" stash show -p "stash@{0}" 2>/dev/null | grep -q "MY UNCOMMITTED WORK" \
  && ok "the stashed content is recoverable verbatim" || bad "stashed content not recoverable"
grep -q "stashed genuine WIP" <<<"$OUT" && ok "stash logged" || bad "stash not logged"

# ============================================================================
hr; echo "RESOLVE/SAFE — a non-colliding untracked file is left untouched"; hr
setup_fixture
origin_commit foo.txt landed2 "fix: foo 2"
printf 'scratch\n' > "$TR/root/keepme.txt"       # untracked, NOT an incoming path
run_resolve
[ "$RC" -eq 0 ] && ok "resolver exit 0" || bad "resolver exit $RC"
[ -e "$TR/root/keepme.txt" ] && ok "non-colliding untracked file preserved (not clobbered)" || bad "clobbered an unrelated untracked file"

# ============================================================================
hr; echo "RESOLVE/PRESERVE — a DIVERGENT untracked collision is moved aside, not deleted"; hr
setup_fixture
origin_commit qux.txt incoming-qux "feat: qux"
printf 'MY DIVERGENT UNTRACKED WORK\n' > "$TR/root/qux.txt"   # collides, differs
run_resolve
[ "$RC" -eq 0 ] && ok "resolver exit 0" || bad "resolver exit $RC"
[ ! -e "$TR/root/qux.txt" ] && ok "divergent collision cleared from the live tree" || bad "still blocking the tree"
found="$(grep -rl "MY DIVERGENT UNTRACKED WORK" "$TR/scratch" 2>/dev/null | head -1)"
[ -n "$found" ] && ok "divergent untracked WIP preserved off-tree under scratch" || bad "divergent untracked WIP LOST (not preserved!)"
grep -q "preserved divergent untracked" <<<"$OUT" && ok "off-tree preservation logged" || bad "preservation not logged"

# ============================================================================
# B. trigger_wedge_resolution via watchman.sh — POST a job, NEVER page the maintainer
# ============================================================================
POSTLOG="$TR/postlog"
mkpostmock() {  # a GARDEN_POST_JOB mock: record the basename, swallow the body
  cat > "$TR/post-mock.sh" <<EOF
#!/bin/bash
echo "POST \$1" >> "$POSTLOG"
exit 0
EOF
  chmod +x "$TR/post-mock.sh"
}
mkpostmock

# Build a wedged ROOT (origin advanced; ROOT carries the named blocker) and preseed
# the watchman seen-marker to ROOT's HEAD so the run exits at "no change" right
# after the wedge is handled (no broadcast / handler path to mock).
run_watchman() {  # fills $OUT/$RC
  local seen="$TR/state/watchman/seen-main2"
  mkdir -p "$(dirname "$seen")"; git -C "$TR/root" rev-parse HEAD > "$seen"
  set +e
  OUT="$(env GARDEN_ROOT="$TR/root" GARDEN_STATE="$TR/state" GARDEN_SCRATCH="$TR/scratch" \
             GARDEN_MAIN_BRANCH=main2 GARDEN_AGGRESSIVE_CHECKOUT=1 \
             GARDEN_POST_JOB="$TR/post-mock.sh" bash "$WATCHMAN" 2>&1)"
  RC=$?
  set -e
}

hr; echo "WATCHMAN/TRACKED-WEDGE — posts a resolve-wedge job, no maintainer message"; hr
setup_fixture; : > "$POSTLOG"; rm -rf "$TR/state"
origin_commit foo.txt landed "fix: foo"
printf 'local divergence\n' > "$TR/root/foo.txt"   # tracked wedge blocks the ff
run_watchman
[ "$RC" -eq 0 ] && ok "watchman exit 0" || bad "watchman exit $RC"
grep -q '^POST resolve-wedge-' "$POSTLOG" && ok "a resolve-wedge job was posted" || bad "no resolve-wedge job posted"
grep -Eq 'reported dirty-wedge|message-user|deploy is frozen' <<<"$OUT" && bad "watchman paged the maintainer on a wedge" || ok "maintainer NOT paged on a wedge"
grep -q 'posting resolve-wedge job' <<<"$OUT" && ok "autonomous-resolution path logged" || bad "resolution path not logged"

hr; echo "WATCHMAN/UNTRACKED-COLLISION — posts a job, no maintainer message"; hr
setup_fixture; : > "$POSTLOG"; rm -rf "$TR/state"
origin_commit newpath.txt incoming "feat: newpath"
printf 'colliding untracked\n' > "$TR/root/newpath.txt"   # untracked collision blocks ff
run_watchman
[ "$RC" -eq 0 ] && ok "watchman exit 0" || bad "watchman exit $RC"
grep -q '^POST resolve-wedge-' "$POSTLOG" && ok "a resolve-wedge job was posted for the collision" || bad "no job posted for the collision"
grep -Eq 'reported dirty-wedge|message-user|deploy is frozen' <<<"$OUT" && bad "watchman paged the maintainer on a collision" || ok "maintainer NOT paged on a collision"

hr; echo "WATCHMAN/THROTTLE — the same wedge signature posts only once"; hr
setup_fixture; : > "$POSTLOG"; rm -rf "$TR/state"
origin_commit foo.txt landed "fix: foo"
printf 'local divergence\n' > "$TR/root/foo.txt"
run_watchman          # first tick: posts
run_watchman          # second tick: same signature, must NOT re-post
n="$(grep -c '^POST resolve-wedge-' "$POSTLOG" 2>/dev/null || echo 0)"
[ "$n" -eq 1 ] && ok "exactly one post across two ticks (throttled)" || bad "posted $n times (throttle leaked)"
grep -q 'already posted for this state' <<<"$OUT" && ok "throttle hit logged on the second tick" || bad "throttle not logged"

hr; echo "RESULT: $PASS passed, $FAIL failed"; hr
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
