#!/bin/bash
# issue-inbox-journal-linkage-test.sh — regression guard for the issue-inbox
# watcher's TICK-START journal-linkage self-heal (kriskowal/garden #24).
#
# The live failure (2026-07-04): a fresh maintainer issue (#24) got NO reactji and
# NO dispatched job. A garden-root relocation had severed the shared journal
# worktree's gitdir (`fatal: not a git repository: …/garden2/.git/worktrees/journal`),
# and because every read/dispatch the watcher does resolves the journal remote
# through that worktree, journal_remote was pushed to its die path and the WHOLE
# tick aborted in ensure_clone BEFORE the reactji/dispatch step — silently dropping
# the very issue this watcher exists to deliver.
#
# The fix (this test locks it down):
#   * the watcher repairs the journal worktree linkage at TICK START, before any
#     journal read, via the SHARED hardened prune-first repair
#     (repair_journal_worktree_gitdir in common.sh, factored from the keeper);
#   * journal_remote's last-resort sibling-clone fallback now also scans the
#     read-side watchers' own $GARDEN_STATE/<svc>/verify clones (not only
#     */journal), so a severed worktree resolves the remote from the watcher's OWN
#     verify clone instead of dying;
#   * a repair failure is SURFACED (WARN + a throttled maintainer signal), never a
#     silent abort.
#
# Cases:
#   A. SEVERED + admin gone (unrepairable in place), a prior verify clone present,
#      NO other remote source: the watcher SELF-HEALS via the verify-clone fallback
#      and STILL reactji+dispatches; the failure is surfaced (WARN + alert). This is
#      the exact #24 shape. It FAILS before the change (tick aborts, no post).
#   B. SEVERED + admin present (repairable in place): the worktree gitdir is
#      re-linked at tick start (rev-parse resolves again) AND the tick dispatches.
#
# Hermetic: a throwaway bare upstream on journal2, a real clone standing in for
# $GARDEN_ROOT with a linked `journal` worktree, deterministic source/post/react
# stubs. No GitHub, no claude, no network, no live journal. JOURNAL_REMOTE is left
# UNSET so the watcher must derive the remote through the (severed) worktree — the
# code path that dropped #24.
#
# Usage: issue-inbox-journal-linkage-test.sh
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
BRANCH=journal2
REPO=kriskowal/garden
SLUG=kriskowal-garden
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener running this test cannot splice its own
# GARDEN_*/JOURNAL_*/SELF_HEAL_* under the fixture (mirrors run-test.sh / relink-test).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR=/home/kris/.garden-iij-linkage-test
git_id=(-c user.name=test -c user.email=test@localhost)
UP="$TR/upstream.git"

# --- deterministic stubs ----------------------------------------------------
mk_stubs() {
  SRCSTUB="$TR/src.sh"; POSTSTUB="$TR/post.sh"; REACTSTUB="$TR/react.sh"; ALERTSTUB="$TR/alert.sh"
  cat > "$SRCSTUB" <<'EOF'
#!/bin/bash
# one new trusted issue #24 from kriskowal (ignores repo/since args)
printf 'issue\t2026-07-04T10:00:00Z\t900\t24\tkriskowal\tkriskowal\topen\t-\t-\thttps://github.com/kriskowal/garden/issues/24\tPlease harden the issue inbox\n'
EOF
  cat > "$POSTSTUB" <<EOF
#!/bin/bash
printf 'POST %s\n' "\$1" >> "$TR/post.log"; exit 0
EOF
  cat > "$REACTSTUB" <<EOF
#!/bin/bash
printf 'REACT %s %s\n' "\$2" "\$3" >> "$TR/react.log"; exit 0
EOF
  cat > "$ALERTSTUB" <<EOF
#!/bin/bash
printf 'ALERT %s\n' "\$1" >> "$TR/alert.log"; exit 0
EOF
  chmod +x "$SRCSTUB" "$POSTSTUB" "$REACTSTUB" "$ALERTSTUB"
}

seed_upstream() {  # a bare journal2 carrying config/garden-repo + maintainers/allowlist
  git init -q --bare "$UP"
  local seed="$TR/seed"; git init -q "$seed"; git -C "$seed" checkout -q -b "$BRANCH"
  mkdir -p "$seed/jobs/todo" "$seed/jobs/doin" "$seed/jobs/tada" "$seed/cursors" \
           "$seed/config" "$seed/maintainers" "$seed/inbox/maintainer/unread"
  for d in jobs/todo jobs/doin jobs/tada cursors; do touch "$seed/$d/.gitkeep"; done
  printf '%s\n' "$REPO" > "$seed/config/garden-repo"
  printf 'kriskowal\n'  > "$seed/maintainers/allowlist"
  git -C "$seed" add -A; git -C "$seed" "${git_id[@]}" commit -q -m seed
  git -C "$seed" remote add origin "$UP"; git -C "$seed" push -q -u origin "$BRANCH"
  git -C "$UP" symbolic-ref HEAD "refs/heads/$BRANCH"
  rm -rf "$seed"
}

make_root() {  # a clone standing in for $GARDEN_ROOT with a linked journal worktree
  local root="$1"
  git clone -q "$UP" "$root"
  git -C "$root" checkout -q --detach
  git -C "$root" "${git_id[@]}" worktree add -q "$root/journal" "$BRANCH"
}

# sever the worktree's forward .git pointer to a nonexistent garden2-style path
sever_forward_ptr() { printf 'gitdir: %s/garden2/.git/worktrees/journal\n' "$TR" > "$1/journal/.git"; }

run_watcher() {  # run_watcher <root> <state> <errfile>  (JOURNAL_REMOTE deliberately UNSET)
  env GARDEN_ROOT="$1" GARDEN_STATE="$2" GARDEN=linkhost \
      JOURNAL_BRANCH="$BRANCH" JOURNAL_REMOTE= \
      GARDEN_ALERT_CMD="$ALERTSTUB" \
      GARDEN_ISSUE_SOURCE="$SRCSTUB" GARDEN_ISSUE_POST="$POSTSTUB" \
      GARDEN_ISSUE_MSG="$POSTSTUB" GARDEN_ISSUE_REACTJI="$REACTSTUB" \
      "$JOBS/issue-inbox-watcher.sh" >/dev/null 2>"$3"
}

# ============================================================================
hr; echo "STATIC — the scripts parse (bash -n)"; hr
bash -n "$JOBS/common.sh"               && ok "common.sh parses"               || bad "common.sh syntax error"
bash -n "$JOBS/issue-inbox-watcher.sh"  && ok "issue-inbox-watcher.sh parses"  || bad "watcher syntax error"
bash -n "$JOBS/journal-worktree-keeper.sh" && ok "journal-worktree-keeper.sh parses" || bad "keeper syntax error"
grep -q 'repair_journal_worktree_gitdir' "$JOBS/common.sh" \
  && ok "shared repair_journal_worktree_gitdir helper is in common.sh" \
  || bad "shared repair helper missing from common.sh"
grep -q 'repair_journal_worktree_gitdir' "$JOBS/journal-worktree-keeper.sh" \
  && ok "keeper delegates to the shared helper (no duplicated repair logic)" \
  || bad "keeper does not use the shared helper"

# ============================================================================
hr; echo "A — #24 shape: severed worktree (admin GONE), verify clone present → self-heal + dispatch"; hr
rm -rf "$TR"; mkdir -p "$TR"; mk_stubs; seed_upstream
ROOT="$TR/root"; STATE="$TR/state"; make_root "$ROOT"
# a prior healthy tick left a verify clone that still carries the origin
mkdir -p "$STATE/issue-inbox"
git clone -q --single-branch --branch "$BRANCH" "$UP" "$STATE/issue-inbox/verify"
# SEVER: dangling garden2-style forward pointer AND remove the owning admin entry
# (unrepairable in place) AND remove the root origin — so the watcher's OWN verify
# clone is the ONLY remaining source of the journal remote.
sever_forward_ptr "$ROOT"
rm -rf "$ROOT/.git/worktrees/journal"
git -C "$ROOT" remote remove origin
git -C "$ROOT/journal" rev-parse --git-dir >/dev/null 2>&1 \
  && bad "fixture: worktree should be severed pre-run" \
  || ok "fixture reproduces the severed gitdir (rev-parse fails)"
: > "$TR/post.log"; : > "$TR/react.log"; : > "$TR/alert.log"
run_watcher "$ROOT" "$STATE" "$TR/errA.log"; rc=$?
[ "$rc" -eq 0 ] && ok "tick did NOT abort (exit 0) despite the severed linkage" || bad "tick exited $rc (regressed to the silent abort)"
grep -qx "REACT issue 24" "$TR/react.log" && ok "reactji fired on the pending issue (👀 reached, not dropped)" || bad "no reactji (tick aborted before ack): $(cat "$TR/react.log")"
grep -q "POST issue-$SLUG-24" "$TR/post.log" && ok "issue job DISPATCHED (issue-$SLUG-24) — the #24 drop is gone" || bad "issue not dispatched (post=$(cat "$TR/post.log"))"
grep -qi "severed and not repairable" "$TR/errA.log" && ok "the unrepairable linkage is SURFACED as a WARN (not swallowed)" || bad "no WARN surfaced: $(tail -3 "$TR/errA.log")"
grep -q "ALERT issue-inbox-journal-linkage" "$TR/alert.log" && ok "a throttled maintainer signal was raised" || bad "no maintainer signal raised (alert=$(cat "$TR/alert.log"))"

# ============================================================================
hr; echo "B — severed worktree with admin PRESENT (repairable) → re-linked at tick start + dispatch"; hr
rm -rf "$TR"; mkdir -p "$TR"; mk_stubs; seed_upstream
ROOT="$TR/root"; STATE="$TR/state"; make_root "$ROOT"
# SEVER only the forward pointer; leave the admin entry AND the root origin intact so
# `worktree repair` can re-link it in place.
sever_forward_ptr "$ROOT"
git -C "$ROOT/journal" rev-parse --git-dir >/dev/null 2>&1 \
  && bad "fixture: worktree should be severed pre-run" \
  || ok "fixture reproduces the severed gitdir (rev-parse fails)"
: > "$TR/post.log"; : > "$TR/react.log"; : > "$TR/alert.log"
run_watcher "$ROOT" "$STATE" "$TR/errB.log"; rc=$?
[ "$rc" -eq 0 ] && ok "tick exited 0" || bad "tick exited $rc"
git -C "$ROOT/journal" rev-parse --git-dir >/dev/null 2>&1 \
  && ok "worktree gitdir RE-LINKED in place at tick start (rev-parse resolves again)" \
  || bad "worktree still severed after the tick"
grep -qx "REACT issue 24" "$TR/react.log" && ok "reactji fired" || bad "no reactji: $(cat "$TR/react.log")"
grep -q "POST issue-$SLUG-24" "$TR/post.log" && ok "issue job dispatched" || bad "issue not dispatched (post=$(cat "$TR/post.log"))"
# A repairable linkage self-heals silently — no maintainer page needed.
[ ! -s "$TR/alert.log" ] && ok "no maintainer page on a self-healed (repairable) linkage" || bad "paged despite an in-place self-heal (alert=$(cat "$TR/alert.log"))"

# ============================================================================
hr; echo "RESULT: $PASS passed, $FAIL failed"; hr
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
