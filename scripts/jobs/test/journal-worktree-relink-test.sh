#!/bin/bash
# journal-worktree-relink-test.sh — regression guard for the journal-remote
# self-heal in common.sh (ensure_journal_worktree_linked + journal_remote).
#
# Two failures this locks down:
#
# 1. DANGLING GITDIR. The canonical journal worktree ($GARDEN_ROOT/journal) is a
#    LINKED worktree whose `.git` file is a forward pointer to an admin dir under
#    $GARDEN_ROOT/.git/worktrees/journal. When that forward pointer dangles (points
#    at a nonexistent/wrong admin dir — the observed shape was
#    `/home/kris/.git/worktrees/journal` vs the real `/home/kris/garden2/.git/...`),
#    every `git -C $GARDEN_ROOT/journal` dies `fatal: not a git repository`. The old
#    journal_remote misread that as "no origin" and `die`d, so claim/monitor exit
#    rc=1 FOREVER under systemd Restart — a fleet-wide crash loop.
#    ensure_journal_worktree_linked runs `git worktree repair` + `prune` to re-link
#    the pair when both the worktree checkout and the admin dir survive.
#
# 2. TRANSIENT EMPTY READ. Even when the worktree is intact, the origin read can be
#    MOMENTARILY empty — a git config lock held by the worktree-keeper, or a deploy
#    window (the 2026-07-03 11:06-11:11Z outage: ~every garden-* unit died repeatedly
#    with "no JOURNAL_REMOTE set and no origin" while the origin was intact seconds
#    later). journal_remote must NOT FATAL-storm on that; it falls back — in order —
#    to (a) a per-host cache of the last good resolution ($JOURNAL_REMOTE_CACHE under
#    GARDEN_STATE) and (b) the shared root checkout's origin (journal2 + main2 live in
#    the SAME repo/remote), logging a single WARN, and only `die`s when ALL fail.
#    Every successful resolution is cached so a later empty read self-heals.
#
# Cases:
#   * dangling forward pointer, admin dir intact -> auto-repaired, origin returns
#   * unrepairable (admin dir gone) BUT root has origin -> self-heals via root
#     fallback + WARN, does NOT die (the FATAL storm is gone)
#   * worktree origin unreadable AND root origin gone, cache present -> cache wins
#   * successful resolution writes the per-host cache
#   * everything empty (valid worktree, no origin, no cache) -> die "no origin"
#   * broken worktree AND root origin gone AND no cache -> die names the gitdir
#     (proves the distinct diagnoses survive when nothing can self-heal)
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
# that dies on a dangling gitdir). GARDEN_STATE points at a fixture dir so the
# per-host journal-remote cache lands there; setup_fixture wipes $TR (state
# included) between cases so no cache leaks across them.
export GARDEN_ROOT="$GR" GARDEN_STATE="$TR/state" GARDEN=testhost
export JOURNAL_BRANCH=journal2 JOURNAL_REMOTE=
CACHE="$GARDEN_STATE/config/journal-remote"
# shellcheck source=../common.sh
setup_fixture
source "$JOBS/common.sh"

# Break only the worktree's forward `.git` pointer (admin dir left intact).
corrupt_forward_pointer() { printf 'gitdir: %s\n' "$TR/bogus/.git/worktrees/journal" > "$JW/.git"; }
# journal_remote may call die -> exit 1; run it in a subshell so the test survives.
# Capture stdout (the resolved remote) and stderr (WARN/FATAL logs) separately.
run_journal_remote() {
  set +e
  JR_OUT="$( journal_remote 2>"$TR/jr.err" )"; JR_RC=$?
  JR_ERR="$(cat "$TR/jr.err" 2>/dev/null)"
  set -e
}

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
hr; echo "CACHE — a successful resolution writes the per-host cache"; hr
setup_fixture
[ -e "$CACHE" ] && bad "cache pre-exists before any resolution" || ok "no cache before first resolution"
run_journal_remote
[ "$JR_RC" -eq 0 ] && [ "$JR_OUT" = "$UP" ] && ok "journal_remote resolved origin from the worktree" || bad "journal_remote did not resolve origin (rc=$JR_RC out='$JR_OUT')"
[ "$(cat "$CACHE" 2>/dev/null)" = "$UP" ] && ok "the resolved origin was cached to $CACHE" || bad "cache not written (got '$(cat "$CACHE" 2>/dev/null)')"

# ============================================================================
hr; echo "SELF-HEAL — unrepairable gitdir but ROOT has origin: root fallback, no die"; hr
# The old behavior FATAL-stormed the fleet here. The intended behavior now: the
# journal worktree is unreadable (admin dir gone, unrepairable) but $GARDEN_ROOT
# still has origin, so journal_remote falls back to it with a single WARN instead
# of dying. No cache present (setup_fixture wiped it) so the ROOT path is exercised.
setup_fixture
corrupt_forward_pointer
rm -rf "$ADMIN"                     # remove the repair anchor -> unrepairable
[ -e "$CACHE" ] && bad "cache leaked into the root-fallback case" || ok "no cache present (root fallback is exercised, not the cache)"
run_journal_remote
[ "$JR_RC" -eq 0 ] && ok "journal_remote did NOT die (the FATAL storm is gone)" || bad "journal_remote died (rc=$JR_RC) instead of self-healing via root origin"
[ "$JR_OUT" = "$UP" ] && ok "journal_remote returned the root origin ($UP)" || bad "journal_remote returned '$JR_OUT' (expected $UP)"
grep -q "^WARN\|WARN:" <<<"$JR_ERR" && ok "a WARN was logged for the fallback" || bad "no WARN logged on the fallback: $JR_ERR"
grep -qiF "FATAL" <<<"$JR_ERR" && bad "a FATAL was logged (should be a WARN self-heal)" || ok "no FATAL logged (self-heal, not crash)"

# ============================================================================
hr; echo "SELF-HEAL — worktree AND root origin unreadable, but CACHE wins"; hr
# Prove the cache fallback is ordered ahead of the root read: with the worktree
# origin unreadable AND the root's origin removed, only the per-host cache can
# rescue the resolution. Seed the cache, then break both live reads.
setup_fixture
mkdir -p "$(dirname "$CACHE")"; printf '%s\n' "$UP" > "$CACHE"   # seed last-good value
git -C "$GR" remote remove origin                                # kill the root read too
corrupt_forward_pointer; rm -rf "$ADMIN"                         # worktree unreadable
run_journal_remote
[ "$JR_RC" -eq 0 ] && ok "journal_remote self-healed from the cache (no die)" || bad "journal_remote died (rc=$JR_RC) despite a warm cache"
[ "$JR_OUT" = "$UP" ] && ok "journal_remote returned the cached origin ($UP)" || bad "journal_remote returned '$JR_OUT' (expected cached $UP)"
grep -qiF "cached" <<<"$JR_ERR" && ok "the WARN names the cache as the source" || bad "WARN does not mention the cache: $JR_ERR"

# ============================================================================
hr; echo "DIE — valid worktree, NO origin anywhere, NO cache: dies 'no origin'"; hr
# Everything that could self-heal is absent: the worktree is valid but origin is
# removed (shared config, so the root read is empty too) and no cache exists.
setup_fixture
git -C "$GR" remote remove origin           # valid worktree, but no origin remote
run_journal_remote
[ "$JR_RC" -ne 0 ] && ok "journal_remote died when nothing can resolve the remote" || bad "journal_remote did not die (rc=$JR_RC)"
grep -qF "no JOURNAL_REMOTE set and no origin" <<<"$JR_ERR" && ok "die message is the accurate 'no origin' one" || bad "wrong die message for the no-origin case: $JR_ERR"
grep -qF "broken journal worktree" <<<"$JR_ERR" && bad "no-origin case wrongly reports a broken worktree" || ok "no-origin case does NOT claim a broken worktree"

# ============================================================================
hr; echo "DIE — broken worktree, root origin gone, no cache: die NAMES the gitdir"; hr
# The truly-unrecoverable broken case: a dangling gitdir AND no root origin AND no
# cache. Only here does the broken-worktree diagnosis (naming the dangling gitdir)
# survive — it is not swallowed by a self-heal, because there is nothing to heal to.
setup_fixture
corrupt_forward_pointer; rm -rf "$ADMIN"    # unrepairable, unreadable worktree
git -C "$GR" remote remove origin           # root cannot rescue it either
run_journal_remote
[ "$JR_RC" -ne 0 ] && ok "journal_remote died on an unrepairable dangling gitdir" || bad "journal_remote did not die (rc=$JR_RC)"
grep -qF "broken journal worktree" <<<"$JR_ERR" && ok "die message reports the broken-worktree diagnosis" || bad "die message missing the broken-worktree phrasing: $JR_ERR"
grep -qF "/bogus/.git/worktrees/journal" <<<"$JR_ERR" && ok "die message NAMES the dangling gitdir" || bad "die message does not name the gitdir: $JR_ERR"
grep -qF "worktree repair" <<<"$JR_ERR" && ok "die message tells the operator to run 'worktree repair'" || bad "die message missing the repair remedy: $JR_ERR"

# ============================================================================
hr
echo "journal-worktree-relink-test: $PASS passed, $FAIL failed"
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
