#!/bin/bash
# deploy-tree-swap-test.sh — coverage for the ATOMIC tree advance
# (deploy-tree-swap.sh :: atomic_advance_tree).
#
# The deliberate deploy advances the deployed checkout's working tree with
# atomic_advance_tree instead of an in-place `git merge --ff-only`, so a unit that
# execs a script mid-swap never sees a half-written or absent file (the recurring
# rc=127 storm). This test proves:
#   1. CORRECTNESS  — after the advance the tree matches up_sha exactly (adds,
#      modifies, deletes, mode flips, symlinks), HEAD/index are at up_sha, the tree
#      is clean, and no .deploy-swap temp files linger.
#   2. ATOMICITY    — a concurrent hammer that exec's a swapped script thousands of
#      times WHILE the advance runs never observes rc=127 or a partial read: every
#      observation is the whole old script or the whole new script.
#   3. SAFE ABORT   — an unreadable incoming blob aborts (rc 1) before any live path
#      is touched (the tree is left exactly as it was) and stages no temp litter.
#
# Hermetic: throwaway git repos under a scratch dir; no systemd, no journal.
# Usage: deploy-tree-swap-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# atomic_advance_tree needs only `log`; stub it, then source the unit under test.
log() { echo "[tree-swap] $*" >&2; }
# shellcheck source=../deploy-tree-swap.sh
source "$JOBS/deploy-tree-swap.sh"

TR=/home/kris/.garden-deploy-tree-swap-test
rm -rf "$TR"; mkdir -p "$TR"
git_id=(-c user.name=test -c user.email=test@localhost)

# Build a repo with an OLD commit and an UP commit that adds/modifies/deletes/
# mode-flips/symlinks files. Echoes "<old> <up>" and leaves the checkout at OLD.
build_repo() {  # build_repo <dir>
  local d="$1"
  rm -rf "$d"; git init -q "$d"; git -C "$d" checkout -q -b main2
  mkdir -p "$d/scripts/jobs"
  printf '#!/bin/bash\necho OLD-A\n'      > "$d/scripts/jobs/a.sh"; chmod 644 "$d/scripts/jobs/a.sh"
  printf '#!/bin/bash\necho OLD-GONE\n'   > "$d/scripts/jobs/gone.sh"
  printf 'plain old\n'                    > "$d/README.md"
  git -C "$d" add -A; git -C "$d" "${git_id[@]}" commit -q -m old
  local old; old="$(git -C "$d" rev-parse HEAD)"
  # up: modify+chmod a.sh, delete gone.sh, add nested new.sh, add a symlink, edit README
  printf '#!/bin/bash\necho NEW-A\n'      > "$d/scripts/jobs/a.sh"; chmod 755 "$d/scripts/jobs/a.sh"
  git -C "$d" rm -q "$d/scripts/jobs/gone.sh" >/dev/null 2>&1 || git -C "$d" rm -q scripts/jobs/gone.sh
  mkdir -p "$d/scripts/jobs/sub"
  printf '#!/bin/bash\necho NEW-NESTED\n' > "$d/scripts/jobs/sub/new.sh"; chmod 755 "$d/scripts/jobs/sub/new.sh"
  ln -s a.sh "$d/scripts/jobs/link-to-a"
  printf 'plain new\n'                    > "$d/README.md"
  git -C "$d" add -A; git -C "$d" "${git_id[@]}" commit -q -m up
  local up; up="$(git -C "$d" rev-parse HEAD)"
  git -C "$d" checkout -q "$old" -- .    # restore working tree to OLD content
  git -C "$d" reset --mixed -q "$old"    # HEAD+index back to OLD; tree == OLD
  printf '%s %s\n' "$old" "$up"
}

# ============================================================================
hr; echo "STATIC — deploy-tree-swap.sh parses"; hr
bash -n "$JOBS/deploy-tree-swap.sh" && ok "deploy-tree-swap.sh parses" || bad "syntax error"

# ============================================================================
hr; echo "CORRECTNESS — the advance reproduces up_sha exactly and leaves no litter"; hr
D="$TR/correct"
read -r OLD UP < <(build_repo "$D")
atomic_advance_tree "$D" "$OLD" "$UP"; rc=$?
[ "$rc" -eq 0 ] && ok "atomic_advance_tree returned 0" || bad "returned $rc"
[ "$(git -C "$D" rev-parse HEAD)" = "$UP" ] && ok "HEAD advanced to up_sha" || bad "HEAD not at up_sha"
[ -z "$(git -C "$D" status --porcelain)" ] && ok "working tree clean after advance (index+tree == up_sha)" || bad "tree dirty: $(git -C "$D" status --porcelain)"
grep -q 'NEW-A' "$D/scripts/jobs/a.sh" && ok "modified file has new content" || bad "a.sh not updated"
[ -x "$D/scripts/jobs/a.sh" ] && ok "mode flip applied (a.sh now executable)" || bad "a.sh mode not flipped"
[ ! -e "$D/scripts/jobs/gone.sh" ] && ok "deleted file removed" || bad "gone.sh still present"
[ -x "$D/scripts/jobs/sub/new.sh" ] && grep -q NEW-NESTED "$D/scripts/jobs/sub/new.sh" && ok "added nested file placed (new dir created)" || bad "sub/new.sh missing"
[ -L "$D/scripts/jobs/link-to-a" ] && [ "$(readlink "$D/scripts/jobs/link-to-a")" = "a.sh" ] && ok "symlink placed with correct target" || bad "symlink wrong"
[ -z "$(find "$D" -name '.deploy-swap.*' -print -quit)" ] && ok "no .deploy-swap temp litter remains" || bad "temp files lingered: $(find "$D" -name '.deploy-swap.*')"

# ============================================================================
hr; echo "ATOMICITY — a concurrent exec of a swapped script never sees rc=127 / a partial file"; hr
# Advance a fatter tree while a hammer loop exec's the swapped script thousands of
# times. Because rename(2) is atomic within a filesystem, EVERY observation must be
# a complete old or complete new script — never ENOENT (rc 127) and never a
# truncated read. To widen the swap window we add MANY modified scripts so phase 2
# does many renames back-to-back.
D="$TR/atomic"
rm -rf "$D"; git init -q "$D"; git -C "$D" checkout -q -b main2
mkdir -p "$D/scripts/jobs"
for i in $(seq 1 40); do printf '#!/bin/bash\necho V1-%s\n' "$i" > "$D/scripts/jobs/s$i.sh"; chmod 755 "$D/scripts/jobs/s$i.sh"; done
git -C "$D" add -A; git -C "$D" "${git_id[@]}" commit -q -m v1
OLD="$(git -C "$D" rev-parse HEAD)"
for i in $(seq 1 40); do printf '#!/bin/bash\necho V2-%s\n' "$i" > "$D/scripts/jobs/s$i.sh"; done
git -C "$D" add -A; git -C "$D" "${git_id[@]}" commit -q -m v2
UP="$(git -C "$D" rev-parse HEAD)"
git -C "$D" checkout -q "$OLD" -- .; git -C "$D" reset --mixed -q "$OLD"

HAMMER_LOG="$TR/hammer.log"; : > "$HAMMER_LOG"
TARGET="$D/scripts/jobs/s20.sh"
STOP="$TR/hammer.stop"; rm -f "$STOP"
(
  bad_seen=0
  while [ ! -e "$STOP" ]; do
    out="$(bash "$TARGET" 2>/dev/null)"; hrc=$?
    if [ "$hrc" -ne 0 ]; then echo "RC=$hrc" >> "$HAMMER_LOG"; bad_seen=$((bad_seen+1)); fi
    case "$out" in
      V1-20|V2-20) : ;;                                   # a complete old or new read
      *) echo "PARTIAL='$out'" >> "$HAMMER_LOG"; bad_seen=$((bad_seen+1)) ;;
    esac
  done
  echo "hammer_bad=$bad_seen" >> "$HAMMER_LOG"
) &
hammer_pid=$!
# Run the advance repeatedly (old->up then reset back to old) so the hammer overlaps
# many real swaps rather than a single sub-millisecond one.
for round in $(seq 1 25); do
  atomic_advance_tree "$D" "$OLD" "$UP" >/dev/null 2>&1
  git -C "$D" checkout -q "$OLD" -- . ; git -C "$D" reset --mixed -q "$OLD"
done
touch "$STOP"; wait "$hammer_pid" 2>/dev/null || true
partials="$(grep -c PARTIAL "$HAMMER_LOG" 2>/dev/null || true)"
rc127="$(grep -c 'RC=127' "$HAMMER_LOG" 2>/dev/null || true)"
anyrc="$(grep -c 'RC=' "$HAMMER_LOG" 2>/dev/null || true)"
iters="$(grep -oE 'hammer_bad=[0-9]+' "$HAMMER_LOG" | head -1)"
[ "$partials" -eq 0 ] && ok "hammer saw ZERO partial reads across the swaps" || bad "hammer saw $partials partial reads: $(grep PARTIAL "$HAMMER_LOG" | head -3)"
[ "$rc127" -eq 0 ] && ok "hammer saw ZERO rc=127 (no absent-file exec)" || bad "hammer saw $rc127 rc=127 execs"
[ "$anyrc" -eq 0 ] && ok "hammer saw ZERO non-zero exec rc of any kind ($iters)" || bad "hammer saw $anyrc non-zero rc: $(grep 'RC=' "$HAMMER_LOG" | sort | uniq -c | head)"

# ============================================================================
hr; echo "SAFE ABORT — an unreadable incoming blob aborts before any live path is touched"; hr
D="$TR/abort"
read -r OLD UP < <(build_repo "$D")
before_tree="$(git -C "$D" rev-parse HEAD)"
before_a="$(cat "$D/scripts/jobs/a.sh")"
# Make every working-tree directory read-only (leaving .git readable, so `git diff`
# still enumerates the changes) so phase 1's sibling-temp write fails on the first
# incoming file — exercising the abort path WITHOUT ever renaming a live file.
find "$D" -path "$D/.git" -prune -o -type d -exec chmod 555 {} + 2>/dev/null || true
set +e
atomic_advance_tree "$D" "$OLD" "$UP" >/dev/null 2>&1; rc=$?
set -e
find "$D" -type d -exec chmod u+rwx {} + 2>/dev/null || true
[ "$rc" -eq 1 ] && ok "unreadable blob → rc 1 (aborted before touching a live file)" || bad "expected rc 1, got $rc"
[ "$(git -C "$D" rev-parse HEAD)" = "$before_tree" ] && ok "HEAD unchanged after a safe abort" || bad "HEAD moved on abort"
[ "$(cat "$D/scripts/jobs/a.sh")" = "$before_a" ] && ok "live file untouched after a safe abort" || bad "a.sh was modified despite abort"
[ -z "$(find "$D" -name '.deploy-swap.*' -print -quit)" ] && ok "no temp litter after a safe abort" || bad "temp files lingered after abort"

# ============================================================================
hr; echo "RESULT: $PASS passed, $FAIL failed"; hr
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
