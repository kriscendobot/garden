#!/bin/bash
# journal-worktree-relink-test.sh — regression guard for the dangling-gitdir
# self-heal in common.sh (ensure_journal_worktree_linked + journal_remote).
#
# Failure this locks down: the canonical journal worktree ($GARDEN_ROOT/journal)
# is a LINKED worktree whose `.git` file is a forward pointer to an admin dir
# under $GARDEN_ROOT/.git/worktrees/journal. When that forward pointer dangles
# (points at a nonexistent/wrong admin dir — the observed shape was
# `/home/kris/.git/worktrees/journal` vs the real `/home/kris/garden2/.git/...`),
# every `git -C $GARDEN_ROOT/journal` dies `fatal: not a git repository`. The old
# journal_remote misread that as "no origin" and `die`d, so claim/monitor
# exit rc=1 FOREVER under systemd Restart — a fleet-wide crash loop.
#
# The fix is two-part and this test covers both:
#   1. ensure_journal_worktree_linked runs `git worktree repair` + `prune` to
#      re-link the pair when both the worktree checkout and the admin dir survive,
#      quietly self-healing the exact corruption above.
#   2. journal_remote gates on `rev-parse --git-dir` FIRST, so an UNrepairable
#      dangling gitdir dies with an accurate message that names the dangling
#      gitdir and tells the operator to run `worktree repair` — NOT the false
#      "no origin".
#
# Cases:
#   * dangling forward pointer, admin dir intact -> auto-repaired, origin returns
#   * unrepairable (admin dir gone)             -> die names the gitdir, not origin
#   * valid worktree, origin removed            -> die DOES say "no origin"
#     (proves the two diagnoses stay distinct)
#
# Hermetic: a throwaway bare upstream on branch journal2 + a real clone standing
# in for $GARDEN_ROOT with a linked `journal` worktree. No real garden/network.
#
# Usage: journal-worktree-relink-test.sh
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener running this test cannot splice its
# own GARDEN_*/JOURNAL_* state underneath the fixture (mirrors run-test.sh).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR=/home/kris/.garden-journal-relink-test
git_id=(-c user.name=test -c user.email=test@localhost)
UP="$TR/upstream.git"      # the shared origin (carries branch journal2)
GR="$TR/gr"                # stands in for $GARDEN_ROOT
JW="$GR/journal"           # the linked journal worktree
ADMIN="$GR/.git/worktrees/journal"   # its admin dir (the repair anchor)

setup_fixture() {
  rm -rf "$TR"; mkdir -p "$TR"
  git init -q --bare "$UP"
  local SEED="$TR/seed"; git init -q "$SEED"
  git -C "$SEED" checkout -q -b main
  printf 'a\n' > "$SEED/f"; git -C "$SEED" add -A; git -C "$SEED" "${git_id[@]}" commit -q -m m1
  git -C "$SEED" checkout -q -b journal2
  printf 'j\n' > "$SEED/f"; git -C "$SEED" add -A; git -C "$SEED" "${git_id[@]}" commit -q -m j1
  git -C "$SEED" remote add origin "$UP"; git -C "$SEED" push -q -u origin main journal2
  git -C "$UP" symbolic-ref HEAD refs/heads/main   # a plain clone checks out main
  rm -rf "$SEED"
  # $GARDEN_ROOT: a real clone (origin -> UP) with a linked journal2 worktree.
  git clone -q "$UP" "$GR"
  git -C "$GR" fetch -q origin journal2
  git -C "$GR" worktree add -q "$JW" journal2
}

# Source the real helpers under the fixture's GARDEN_ROOT. JOURNAL_REMOTE stays
# EMPTY so journal_remote is forced to derive origin from the worktree (the path
# that dies on a dangling gitdir).
export GARDEN_ROOT="$GR" GARDEN_STATE="$TR/state" GARDEN=testhost
export JOURNAL_BRANCH=journal2 JOURNAL_REMOTE=
# shellcheck source=../common.sh
setup_fixture
source "$JOBS/common.sh"

# Break only the worktree's forward `.git` pointer (admin dir left intact).
corrupt_forward_pointer() { printf 'gitdir: %s\n' "$TR/bogus/.git/worktrees/journal" > "$JW/.git"; }
# journal_remote calls die -> exit 1; run it in a subshell so the test survives.
run_journal_remote() { set +e; JR_OUT="$( journal_remote 2>&1 )"; JR_RC=$?; set -e; }

# ============================================================================
hr; echo "STATIC — common.sh parses (bash -n)"; hr
bash -n "$JOBS/common.sh" && ok "common.sh parses" || bad "syntax error"

# ============================================================================
hr; echo "SELF-HEAL — dangling forward pointer, admin dir intact: auto-repaired"; hr
setup_fixture
corrupt_forward_pointer
git -C "$JW" rev-parse --git-dir >/dev/null 2>&1 \
  && bad "fixture not corrupted (rev-parse still works)" \
  || ok "fixture reproduces the dangling gitdir (rev-parse fails)"
if ensure_journal_worktree_linked "$JW"; then
  ok "ensure_journal_worktree_linked reported success"
else
  bad "ensure_journal_worktree_linked returned failure on a repairable worktree"
fi
git -C "$JW" rev-parse --git-dir >/dev/null 2>&1 \
  && ok "worktree is a valid git repo after the repair" \
  || bad "worktree still broken after ensure_journal_worktree_linked"
grep -qF "worktrees/journal" "$JW/.git" \
  && ! grep -qF "/bogus/" "$JW/.git" \
  && ok "forward .git pointer re-linked to the real admin dir" \
  || bad "forward .git pointer not repaired ($(cat "$JW/.git"))"

# ============================================================================
hr; echo "SELF-HEAL — journal_remote transparently returns origin after repair"; hr
setup_fixture
corrupt_forward_pointer
run_journal_remote
[ "$JR_RC" -eq 0 ] && ok "journal_remote exit 0 (preflight self-healed)" || bad "journal_remote exit $JR_RC (should self-heal)"
[ "$JR_OUT" = "$UP" ] && ok "journal_remote returned the derived origin ($UP)" || bad "journal_remote returned '$JR_OUT' (expected $UP)"

# ============================================================================
hr; echo "UNREPAIRABLE — admin dir gone: die NAMES the gitdir, not 'no origin'"; hr
setup_fixture
corrupt_forward_pointer
rm -rf "$ADMIN"                     # remove the repair anchor -> unrepairable
run_journal_remote
[ "$JR_RC" -ne 0 ] && ok "journal_remote died on an unrepairable dangling gitdir" || bad "journal_remote did not die (rc=$JR_RC)"
grep -qF "broken journal worktree" <<<"$JR_OUT" && ok "die message reports the broken-worktree diagnosis" || bad "die message missing the broken-worktree phrasing: $JR_OUT"
grep -qF "/bogus/.git/worktrees/journal" <<<"$JR_OUT" && ok "die message NAMES the dangling gitdir" || bad "die message does not name the gitdir: $JR_OUT"
grep -qF "worktree repair" <<<"$JR_OUT" && ok "die message tells the operator to run 'worktree repair'" || bad "die message missing the repair remedy: $JR_OUT"
grep -qiF "no origin" <<<"$JR_OUT" && bad "die STILL misreports as 'no origin' (the bug)" || ok "die does NOT say 'no origin' (misdiagnosis fixed)"

# ============================================================================
hr; echo "DISTINCT — a VALID worktree with no origin still dies 'no origin'"; hr
# Proves the two diagnoses stay distinct: gate is on validity FIRST, then origin.
setup_fixture
git -C "$GR" remote remove origin           # valid worktree, but no origin remote
run_journal_remote
[ "$JR_RC" -ne 0 ] && ok "journal_remote died when a valid worktree has no origin" || bad "journal_remote did not die (rc=$JR_RC)"
grep -qF "no JOURNAL_REMOTE set and no origin" <<<"$JR_OUT" && ok "die message is the accurate 'no origin' one" || bad "wrong die message for the no-origin case: $JR_OUT"
grep -qF "broken journal worktree" <<<"$JR_OUT" && bad "no-origin case wrongly reports a broken worktree" || ok "no-origin case does NOT claim a broken worktree"

# ============================================================================
hr
echo "journal-worktree-relink-test: $PASS passed, $FAIL failed"
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
