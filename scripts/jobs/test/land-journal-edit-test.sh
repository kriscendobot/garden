#!/bin/bash
# land-journal-edit-test.sh — coverage for the scripted journal2 content-file
# edit lander (land-journal-edit.sh).
#
# Regression for the 2026-06-27 live-worktree-rebase hazard: a gardener wearing
# the scholar role landed a library content edit by rebasing the live, WIP-laden
# /home/kris/journal worktree, replaying ~80 already-upstream commits into a
# destructive conflict (entries/2026/06/27/095956Z-result-scholar-e213f5.md). The
# lander must instead land through the isolated producer clone, syncing the tip
# first and pushing with the CAS/verify guard — and it must REFUSE both an
# out-of-allowlist path and the live-worktree clone, mirroring the read-side
# guarantee documented in library-link-check.sh.
#
# Hermetic: a throwaway bare journal2 origin stands in for the shared journal.
# No real journal and no network are touched.
#
# Usage: land-journal-edit-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
LAND="$JOBS/land-journal-edit.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener invoking this test cannot splice its
# own GARDEN_*/JOURNAL_* state underneath the fixture (mirrors the sibling test).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR=/home/kris/.garden-landedit-test
BARE="$TR/origin.git"
STATE="$TR/state"
CLONE="$STATE/producer/journal"
git_id=(-c user.name=test -c user.email=test@localhost)

setup_fixture() {
  rm -rf "$TR"; mkdir -p "$TR"
  git init -q --bare "$BARE"
  local SEED="$TR/seed"; git init -q "$SEED"
  git -C "$SEED" checkout -q -b journal2
  mkdir -p "$SEED/library/concepts" "$SEED/projects/endo"
  printf '%s\n' "# keywords" > "$SEED/library/keywords.md"
  printf '%s\n' "# endo project" > "$SEED/projects/endo/README.md"
  git -C "$SEED" add -A
  git -C "$SEED" "${git_id[@]}" commit -q -m "seed journal2 fixture"
  git -C "$SEED" remote add origin "$BARE"
  git -C "$SEED" push -q -u origin journal2
}

# Run the lander against the fixture; fills $OUT, $RC. The new file body comes
# from $BODY (a here-string, so the function runs in THIS shell — a pipe would
# run it in a subshell and lose $OUT/$RC). Set BODY="" for the reject cases that
# never read a body.
run_land() {  # run_land [args...] ; body from $BODY
  set +e
  OUT="$(env JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
             GARDEN_STATE="$STATE" GARDEN_ROOT="$TR" \
             GARDEN_PRODUCER_CLONE="$CLONE" \
             GARDEN_NO_MAINTAINER_ALERT=1 \
             bash "$LAND" "$@" <<<"$BODY" 2>&1)"
  RC=$?
  set -e
}

# Read a path's content at the current origin/journal2 tip (empty if absent).
origin_show() {  # origin_show <relpath>
  git -C "$BARE" show "journal2:$1" 2>/dev/null || true
}

# ============================================================================
hr; echo "STATIC — the script parses (bash -n)"; hr
bash -n "$LAND" && ok "land-journal-edit.sh parses" || bad "syntax error"

# ============================================================================
hr; echo "LAND — a new file and a modify both reach origin/journal2"; hr
setup_fixture
BODY="$(printf '%s\n' "# caretaker-pattern" "the new page body")"
run_land library/concepts/caretaker-pattern.md
[ "$RC" -eq 0 ] && ok "exit 0 landing a new library file" || bad "exit $RC landing new file: $OUT"
got="$(origin_show library/concepts/caretaker-pattern.md)"
grep -qF "the new page body" <<<"$got" && ok "new file content reached origin/journal2" || bad "new file not on origin: '$got'"

BODY="$(printf '%s\n' "# keywords" "term | caretaker-pattern")"
run_land library/keywords.md
[ "$RC" -eq 0 ] && ok "exit 0 modifying an existing library file" || bad "exit $RC modifying: $OUT"
grep -qF "term | caretaker-pattern" <<<"$(origin_show library/keywords.md)" \
  && ok "modified content reached origin/journal2" || bad "modify not on origin"

# a projects/ edit also lands (second allowlisted tree):
BODY="$(printf '%s\n' "# endo" "a topic line")"
run_land projects/endo/topics.md
[ "$RC" -eq 0 ] && ok "exit 0 landing under projects/" || bad "exit $RC under projects/: $OUT"
grep -qF "a topic line" <<<"$(origin_show projects/endo/topics.md)" \
  && ok "projects/ edit reached origin/journal2" || bad "projects/ edit not on origin"

# idempotent re-land of identical content is a no-op success:
BODY="$(printf '%s\n' "# keywords" "term | caretaker-pattern")"
run_land library/keywords.md
[ "$RC" -eq 0 ] && ok "idempotent re-land exits 0" || bad "re-land exit $RC: $OUT"
grep -qi "no change" <<<"$OUT" && ok "idempotent re-land reports no change" || bad "re-land did not detect no-op: $OUT"

# ============================================================================
hr; echo "REJECT — an out-of-allowlist path is refused, nothing lands"; hr
BODY=""
run_land entries/2026/06/27/sneak.md
[ "$RC" -eq 2 ] && ok "out-of-allowlist path exits 2" || bad "out-of-allowlist exit $RC (want 2)"
grep -qi "not an allowlisted" <<<"$OUT" && ok "names the allowlist refusal" || bad "no allowlist refusal message: $OUT"
[ -z "$(origin_show entries/2026/06/27/sneak.md)" ] && ok "nothing landed for the rejected path" || bad "a rejected path landed on origin"

# a `..` traversal that would escape the allowlist is refused:
run_land "library/../jobs/todo/evil.md"
[ "$RC" -eq 2 ] && ok ".. traversal exits 2" || bad ".. traversal exit $RC (want 2)"
grep -qi "component" <<<"$OUT" && ok "names the traversal refusal" || bad "no traversal refusal message: $OUT"

# an absolute path is refused:
run_land "/etc/passwd"
[ "$RC" -eq 2 ] && ok "absolute path exits 2" || bad "absolute path exit $RC (want 2)"

# ============================================================================
hr; echo "REJECT — the live worktree is never operated on"; hr
# Stand up a real live worktree at \$GARDEN_ROOT/journal (a clone of the origin),
# then point the producer clone AT it: the lander must refuse rather than mutate
# the live tree, mirroring library-link-check.sh's read-side guarantee.
git clone -q --branch journal2 "$BARE" "$TR/journal"
set +e
OUT="$(env JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
           GARDEN_STATE="$STATE" GARDEN_ROOT="$TR" \
           GARDEN_PRODUCER_CLONE="$TR/journal" \
           GARDEN_NO_MAINTAINER_ALERT=1 \
           bash "$LAND" library/keywords.md <<<"# clobber" 2>&1)"
RC=$?
set -e
[ "$RC" -eq 2 ] && ok "live-worktree clone exits 2" || bad "live-worktree exit $RC (want 2): $OUT"
grep -qi "live worktree" <<<"$OUT" && ok "names the live-worktree refusal" || bad "no live-worktree refusal message: $OUT"
# the live worktree was left clean (untouched):
[ -z "$(git -C "$TR/journal" status --porcelain)" ] && ok "live worktree left clean" || bad "live worktree was mutated"

# ============================================================================
hr
echo "RESULTS: $PASS passed, $FAIL failed"
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
